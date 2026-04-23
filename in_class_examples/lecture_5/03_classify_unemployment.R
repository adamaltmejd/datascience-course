classify_unemployment <- function(panel, threshold = 10) {
  latest_year <- max(panel$year)
  current <- panel[panel$year == latest_year, ]

  current$risk_group <- ifelse(
    current$unemployment_rate <= threshold,
    "high",
    "low"
  )
  current
}
mini_panel <- read.csv(
  here::here("in_class_examples", "lecture_5", "data", "mini_panel.csv"),
  colClasses = c(municipality_code = "character")
)
classify_unemployment(mini_panel, threshold = 10)
