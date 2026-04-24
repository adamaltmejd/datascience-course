#!/usr/bin/env Rscript

required_packages <- c("curl", "data.table", "jsonlite")
missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
]

if (length(missing_packages) > 0L) {
  stop(
    sprintf(
      "Missing required packages: %s",
      paste(missing_packages, collapse = ", ")
    ),
    call. = FALSE
  )
}

years <- 2016:2023
script_args <- commandArgs(trailingOnly = FALSE)
script_file_arg <- grep("^--file=", script_args, value = TRUE)
output_dir <- if (length(script_file_arg) == 1L) {
  dirname(normalizePath(sub("^--file=", "", script_file_arg)))
} else {
  getwd()
}
output_file <- file.path(
  output_dir,
  sprintf("municipal_opportunity_panel_%s_%s.csv", min(years), max(years))
)

scb_base <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/START"
kolada_base <- "https://api.kolada.se/v3"

scb_urls <- list(
  population = sprintf("%s/BE/BE0101/BE0101A/BefolkningNy", scb_base),
  education = sprintf("%s/UF/UF0506/UF0506B/Utbildning", scb_base),
  labour_old = sprintf("%s/AA/AA0003/AA0003X/IntGr1KomKonUtb", scb_base),
  labour_new = sprintf("%s/AA/AA0003/AA0003B/IntGr1KomUtbBAS", scb_base),
  income = sprintf("%s/AA/AA0003/AA0003F/IntGr5Kom", scb_base)
)

# These values are hard-coded because they are not fetched from the same APIs.
price_base_amounts <- data.table::data.table(
  year = years,
  price_base_amount = c(44300, 44800, 45500, 46500, 47300, 47600, 48300, 52500)
)

request_json <- function(
  url,
  method = c("GET", "POST"),
  body = NULL,
  attempts = 3L
) {
  method <- match.arg(method)

  for (attempt in seq_len(attempts)) {
    response <- tryCatch(
      {
        if (method == "GET") {
          curl::curl_fetch_memory(url)
        } else {
          handle <- curl::new_handle(
            post = TRUE,
            httpheader = c("Content-Type" = "application/json"),
            postfields = jsonlite::toJSON(
              body,
              auto_unbox = TRUE,
              null = "null"
            )
          )
          curl::curl_fetch_memory(url, handle = handle)
        }
      },
      error = identity
    )

    if (inherits(response, "error")) {
      if (attempt == attempts) {
        stop(
          sprintf("Request failed for %s: %s", url, response$message),
          call. = FALSE
        )
      }

      Sys.sleep(attempt)
      next
    }

    if (response$status_code >= 200L && response$status_code < 300L) {
      return(jsonlite::fromJSON(
        rawToChar(response$content),
        simplifyVector = FALSE
      ))
    }

    if (attempt == attempts) {
      stop(
        sprintf(
          "Request failed for %s with status %s: %s",
          url,
          response$status_code,
          rawToChar(response$content)
        ),
        call. = FALSE
      )
    }

    Sys.sleep(attempt)
  }
}

parse_scb_response <- function(payload) {
  if (length(payload$data) == 0L) {
    return(data.table::data.table())
  }

  column_codes <- vapply(payload$columns, `[[`, character(1), "code")
  column_types <- stats::setNames(
    vapply(payload$columns, `[[`, character(1), "type"),
    column_codes
  )

  dt <- data.table::rbindlist(
    lapply(
      payload$data,
      function(row) {
        values <- c(row$key, row$values)
        data.table::as.data.table(stats::setNames(
          as.list(values),
          column_codes
        ))
      }
    ),
    fill = TRUE
  )

  for (column in names(column_types)[column_types %in% c("t", "c")]) {
    dt[, (column) := type.convert(get(column), as.is = TRUE)]
  }

  dt
}

scb_query <- function(url, selections, sleep_seconds = 1.1) {
  payload <- request_json(
    url = url,
    method = "POST",
    body = list(
      query = lapply(
        names(selections),
        function(code) {
          selection <- selections[[code]]

          if (is.list(selection) && !is.null(selection$filter)) {
            selection <- list(
              filter = selection$filter,
              values = as.list(as.character(selection$values))
            )
          } else {
            selection <- list(
              filter = "item",
              values = as.list(as.character(selection))
            )
          }

          list(
            code = code,
            selection = selection
          )
        }
      ),
      response = list(format = "json")
    )
  )

  Sys.sleep(sleep_seconds)
  parse_scb_response(payload)
}

fetch_municipalities <- function() {
  payload <- request_json(sprintf("%s/municipality", kolada_base))

  data.table::rbindlist(
    lapply(
      payload$values,
      function(entry) {
        data.table::data.table(
          municipality_code = entry$id,
          municipality_name = entry$title,
          region_type = entry$type
        )
      }
    )
  )[region_type == "K", .(municipality_code, municipality_name)]
}

build_population <- function(municipality_codes) {
  message("Fetching population totals")
  population_total <- scb_query(
    scb_urls$population,
    list(
      Region = list(filter = "all", values = "*"),
      Alder = "tot",
      ContentsCode = "BE0101N1",
      Tid = years
    )
  )[
    Region %chin% municipality_codes,
    .(
      municipality_code = Region,
      year = as.integer(Tid),
      population_total = as.integer(BE0101N1)
    )
  ]

  message("Fetching working-age population")
  working_age_chunks <- list(20:41, 42:64)

  population_working_age <- data.table::rbindlist(
    lapply(
      working_age_chunks,
      function(age_chunk) {
        scb_query(
          scb_urls$population,
          list(
            Region = list(filter = "all", values = "*"),
            Alder = age_chunk,
            ContentsCode = "BE0101N1",
            Tid = years
          )
        )
      }
    )
  )[
    Region %chin% municipality_codes,
    .(
      population_working_age = sum(as.integer(BE0101N1))
    ),
    by = .(municipality_code = Region, year = as.integer(Tid))
  ]

  merge(
    population_total,
    population_working_age,
    by = c("municipality_code", "year"),
    all = TRUE
  )
}

build_education <- function(municipality_codes) {
  message("Fetching education counts")
  education_age_chunks <- list(25:36, 37:48, 49:56, 57:64)

  postsecondary_count <- data.table::rbindlist(
    lapply(
      education_age_chunks,
      function(age_chunk) {
        scb_query(
          scb_urls$education,
          list(
            Region = list(filter = "all", values = "*"),
            Alder = age_chunk,
            UtbildningsNiva = c("5", "6", "7"),
            ContentsCode = "UF0506A1",
            Tid = years
          )
        )
      }
    )
  )[
    Region %chin% municipality_codes,
    .(
      postsecondary_count_25_64 = sum(as.integer(UF0506A1))
    ),
    by = .(municipality_code = Region, year = as.integer(Tid))
  ]

  education_population <- data.table::rbindlist(
    lapply(
      list(25:44, 45:64),
      function(age_chunk) {
        scb_query(
          scb_urls$education,
          list(
            Region = list(filter = "all", values = "*"),
            Alder = age_chunk,
            ContentsCode = "UF0506A1",
            Tid = years
          )
        )
      }
    )
  )[
    Region %chin% municipality_codes,
    .(
      education_population_25_64 = sum(as.integer(UF0506A1))
    ),
    by = .(municipality_code = Region, year = as.integer(Tid))
  ]

  merge(
    postsecondary_count,
    education_population,
    by = c("municipality_code", "year"),
    all = TRUE
  )[,
    share_postsecondary := postsecondary_count_25_64 /
      education_population_25_64
  ][,
    .(municipality_code, year, share_postsecondary)
  ]
}

build_labour_market <- function(municipality_codes) {
  message("Fetching labour-market series")

  # The old and new tables are kept explicit because the stitched series is not seamless.
  labour_old <- scb_query(
    scb_urls$labour_old,
    list(
      Region = list(filter = "all", values = "*"),
      Kon = "1+2",
      UtbNiv = "000",
      BakgrVar = "tot20-64",
      ContentsCode = c("000001T8", "000001TC"),
      Tid = years[years <= 2021]
    )
  )[
    Region %chin% municipality_codes,
    .(
      municipality_code = Region,
      year = as.integer(Tid),
      labour_market_source_table = "IntGr1KomKonUtb",
      employment_rate = as.numeric(`000001T8`),
      unemployment_rate = as.numeric(`000001TC`)
    )
  ]

  labour_new <- scb_query(
    scb_urls$labour_new,
    list(
      Region = list(filter = "all", values = "*"),
      Kon = "1+2",
      UtbNiv = "000",
      BakgrVar = "TOT",
      ContentsCode = c("000007K3", "000007K8"),
      Tid = years[years >= 2022]
    )
  )[
    Region %chin% municipality_codes,
    .(
      municipality_code = Region,
      year = as.integer(Tid),
      labour_market_source_table = "IntGr1KomUtbBAS",
      employment_rate = as.numeric(`000007K3`),
      unemployment_rate = as.numeric(`000007K8`)
    )
  ]

  data.table::rbindlist(list(labour_old, labour_new), use.names = TRUE)
}

build_income <- function(municipality_codes) {
  message("Fetching income series")

  income <- scb_query(
    scb_urls$income,
    list(
      Region = list(filter = "all", values = "*"),
      Bakgrund = "tot20-64",
      ContentsCode = "AA0003GJ",
      Tid = years
    )
  )[
    Region %chin% municipality_codes,
    .(
      municipality_code = Region,
      year = as.integer(Tid),
      disposable_income_pbb = as.numeric(AA0003GJ)
    )
  ]

  merge(
    income,
    price_base_amounts,
    by = "year",
    all.x = TRUE
  )[,
    disposable_income_sek_nominal := disposable_income_pbb * price_base_amount
  ]
}

extract_kolada_total <- function(entry) {
  total_value <- Filter(function(x) identical(x$gender, "T"), entry$values)

  if (length(total_value) == 0L) {
    return(
      data.table::data.table(
        municipality_code = entry$municipality,
        year = as.integer(entry$period),
        value = NA_real_
      )
    )
  }

  total_value <- total_value[[1]]
  value <- if (length(total_value$value) == 0L || is.null(total_value$value)) {
    NA_real_
  } else {
    as.numeric(total_value$value)
  }

  data.table::data.table(
    municipality_code = entry$municipality,
    year = as.integer(entry$period),
    value = value
  )
}

build_kolada_series <- function(kpi_id, value_name) {
  message(sprintf("Fetching Kolada KPI %s", kpi_id))

  dt <- data.table::rbindlist(
    lapply(
      years,
      function(year) {
        payload <- request_json(
          sprintf(
            "%s/data/kpi/%s/year/%s?region_type=municipality",
            kolada_base,
            kpi_id,
            year
          )
        )

        Sys.sleep(0.2)

        data.table::rbindlist(
          lapply(payload$values, extract_kolada_total),
          fill = TRUE
        )
      }
    ),
    fill = TRUE
  )

  data.table::setnames(dt, "value", value_name)
  dt
}

municipalities <- fetch_municipalities()
municipality_codes <- municipalities$municipality_code

panel <- data.table::CJ(
  municipality_code = municipality_codes,
  year = years,
  unique = TRUE
)

panel <- merge(panel, municipalities, by = "municipality_code", all.x = TRUE)
panel <- merge(
  panel,
  build_population(municipality_codes),
  by = c("municipality_code", "year"),
  all.x = TRUE
)
panel <- merge(
  panel,
  build_education(municipality_codes),
  by = c("municipality_code", "year"),
  all.x = TRUE
)
panel <- merge(
  panel,
  build_labour_market(municipality_codes),
  by = c("municipality_code", "year"),
  all.x = TRUE
)
panel <- merge(
  panel,
  build_income(municipality_codes),
  by = c("municipality_code", "year"),
  all.x = TRUE
)
panel <- merge(
  panel,
  build_kolada_series("N00999", "new_firm_starts_per_1000_16_64"),
  by = c("municipality_code", "year"),
  all.x = TRUE
)
panel <- merge(
  panel,
  build_kolada_series("U40455", "program_exit_to_work_or_study_share"),
  by = c("municipality_code", "year"),
  all.x = TRUE
)

data.table::setcolorder(
  panel,
  c(
    "municipality_code",
    "municipality_name",
    "year",
    "population_total",
    "population_working_age",
    "share_postsecondary",
    "employment_rate",
    "unemployment_rate",
    "labour_market_source_table",
    "disposable_income_pbb",
    "price_base_amount",
    "disposable_income_sek_nominal",
    "new_firm_starts_per_1000_16_64",
    "program_exit_to_work_or_study_share"
  )
)

panel[, municipality_code := sprintf("%04d", as.integer(municipality_code))]
data.table::setorder(panel, municipality_code, year)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
data.table::fwrite(panel, output_file, na = "", quote = TRUE)

message(sprintf("Wrote %s rows to %s", nrow(panel), output_file))
