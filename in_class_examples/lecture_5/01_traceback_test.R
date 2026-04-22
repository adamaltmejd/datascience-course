prepare_series <- function(x) growth_rates(trimws(x))
growth_rates <- function(x) log_change(x)
log_change <- function(x) diff(log(x))
average_growth <- function(x) mean(prepare_series(x))

average_growth(c("100", "120", "oops", "150"))


f <- function(x) {
  apply(x, 1, mean)
}
