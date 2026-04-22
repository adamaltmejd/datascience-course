get_municipality_history <- function(panel, municipality_code) {
  panel[panel$municipality_code == municipality_code, , drop = FALSE]
}

get_latest_rate <- function(municipality_panel) {
  latest_year <- max(municipality_panel$year)

  municipality_panel[
    municipality_panel$year == latest_year,
    "unemployment_rate"
  ][[1]]
}

get_reference_rate <- function(municipality_panel, reference_year) {
  reference_rate <- municipality_panel[
    municipality_panel$year == reference_year,
    "unemployment_rate"
  ]

  reference_rate[[1]]
}

compute_change_from_reference <- function(municipality_panel, reference_year) {
  latest_rate <- get_latest_rate(municipality_panel)
  reference_rate <- get_reference_rate(municipality_panel, reference_year)

  latest_rate - reference_rate
}

build_municipality_report <- function(
  panel,
  municipality_code,
  reference_year
) {
  municipality_panel <- get_municipality_history(panel, municipality_code)
  change_pp <- compute_change_from_reference(municipality_panel, reference_year)

  data.frame(
    municipality_code = municipality_code,
    municipality_name = municipality_panel$municipality_name[1],
    reference_year = reference_year,
    latest_year = max(municipality_panel$year),
    change_pp = change_pp
  )
}

panel <- read.csv(
  here::here("in_class_examples/lecture_5/data/mini_panel.csv"),
  colClasses = c(municipality_code = "character")
)

build_municipality_report(
  panel,
  municipality_code = "0180",
  reference_year = 2020
)
