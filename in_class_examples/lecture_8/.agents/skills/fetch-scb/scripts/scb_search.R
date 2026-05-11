scb_search_tables <- function(query, lang = "en", page_size = 10) {
  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("Package 'httr2' is required.", call. = FALSE)
  }
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  payload <- httr2::request(
    "https://statistikdatabasen.scb.se/api/v2/tables"
  ) |>
    httr2::req_url_query(
      query = query,
      lang = lang,
      pageSize = page_size
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (length(payload$tables) == 0L) {
    return(data.table::data.table(
      id = character(),
      label = character(),
      period = character()
    ))
  }

  value_or_na <- function(value) {
    if (is.null(value) || length(value) == 0L) {
      return(NA_character_)
    }
    as.character(value)
  }

  data.table::rbindlist(lapply(payload$tables, function(table) {
    data.table::data.table(
      id = value_or_na(table$id),
      label = value_or_na(table$label),
      period = paste(
        value_or_na(table$firstPeriod),
        value_or_na(table$lastPeriod),
        sep = "-"
      )
    )
  }))
}
