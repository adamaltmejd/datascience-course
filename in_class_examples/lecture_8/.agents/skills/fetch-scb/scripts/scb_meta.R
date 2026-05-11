scb_metadata <- function(table_id, lang = "en") {
  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("Package 'httr2' is required.", call. = FALSE)
  }

  url <- sprintf(
    "https://statistikdatabasen.scb.se/api/v2/tables/%s/metadata",
    table_id
  )

  httr2::request(url) |>
    httr2::req_url_query(lang = lang) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

dim_codes <- function(meta, dimension, n = Inf) {
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  labels <- meta$dimension[[dimension]]$category$label
  if (is.null(labels)) {
    stop(sprintf("Unknown dimension: %s", dimension), call. = FALSE)
  }

  dt <- data.table::data.table(
    code = names(labels),
    label = unlist(labels, use.names = FALSE)
  )

  if (is.finite(n)) {
    return(utils::head(dt, n))
  }

  dt
}

dim_eliminable <- function(meta) {
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  data.table::data.table(
    dimension = names(meta$dimension),
    eliminable = vapply(
      meta$dimension,
      function(dimension) isTRUE(dimension$extension$elimination),
      logical(1)
    )
  )
}
