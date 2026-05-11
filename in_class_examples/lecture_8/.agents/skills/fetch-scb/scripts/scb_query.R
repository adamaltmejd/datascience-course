parse_json_px <- function(payload) {
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  if (length(payload$data) == 0L) {
    return(data.table::data.table())
  }

  column_codes <- vapply(payload$columns, `[[`, character(1), "code")

  data.table::rbindlist(lapply(payload$data, function(row) {
    data.table::setnames(
      data.table::as.data.table(as.list(c(row$key, row$values))),
      column_codes
    )
  }))
}

scb_query <- function(table_id, selections, lang = "en") {
  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("Package 'httr2' is required.", call. = FALSE)
  }

  if (is.null(names(selections)) || any(names(selections) == "")) {
    stop("`selections` must be a named list.", call. = FALSE)
  }

  params <- c(
    list(lang = lang, outputFormat = "json-px"),
    lapply(selections, function(values) {
      paste(as.character(values), collapse = ",")
    })
  )
  names(params)[-(1:2)] <- sprintf(
    "valueCodes[%s]",
    names(selections)
  )

  url <- sprintf(
    "https://statistikdatabasen.scb.se/api/v2/tables/%s/data",
    table_id
  )
  request <- httr2::request(url)
  request <- do.call(httr2::req_url_query, c(list(request), params))

  payload <- request |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  parse_json_px(payload)
}
