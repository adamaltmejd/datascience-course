## This script builds a very small lecture demo dataset.
## It does four things:
## 1. downloads unemployment data from two SCB API tables,
## 2. downloads a municipality key from the Kolada API,
## 3. merges municipality codes to municipality names,
## 4. saves the result and makes two quick plots.

library(data.table)
library(httr2)
library(jsonlite)
library(ggplot2)

## SCB changed labour-market tables after 2021, so we need one URL for
## 2016-2021 and another for 2022-2023.
##
## Browsable table URLs:
## https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__AA__AA0003__AA0003X/IntGr1KomKonUtb/
## https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__AA__AA0003__AA0003B/IntGr1KomUtbBAS/
old_url <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/START/AA/AA0003/AA0003X/IntGr1KomKonUtb"
new_url <- "https://api.scb.se/OV0104/v1/doris/sv/ssd/START/AA/AA0003/AA0003B/IntGr1KomUtbBAS"

## Kolada gives us a simple lookup table from municipality code to
## municipality name.
##
## API URL:
## https://api.kolada.se/v3/municipality
key_url <- "https://api.kolada.se/v3/municipality"

## Save the lecture dataset next to the lecture slides.
output_file <- file.path("lectures", "lecture_1", "lecture_1_demo_panel.csv")

## ---- Download unemployment data from the old SCB table -----------------
##
## The query says:
## - all municipalities,
## - both sexes together,
## - all education levels together,
## - ages 20-64,
## - unemployment rate,
## - years 2016-2021.
labour_old_raw <- request(old_url) |>
  req_body_json(list(
    query = list(
      list(code = "Region", selection = list(filter = "all", values = list("*"))),
      list(code = "Kon", selection = list(filter = "item", values = list("1+2"))),
      list(code = "UtbNiv", selection = list(filter = "item", values = list("000"))),
      list(code = "BakgrVar", selection = list(filter = "item", values = list("tot20-64"))),
      list(code = "ContentsCode", selection = list(filter = "item", values = list("000001TC"))),
      list(
        code = "Tid",
        selection = list(filter = "item", values = as.list(as.character(2016:2021)))
      )
    ),
    response = list(format = "json")
  )) |>
  req_perform() |>
  resp_body_string() |>
  fromJSON(simplifyVector = FALSE)

## SCB gives the result back as nested JSON. Here we turn each returned
## row into a simple data.table with just the variables we care about.
labour_old <- rbindlist(lapply(labour_old_raw$data, function(row) {
  data.table(
    municipality_code = row$key[[1]],
    year = as.integer(row$key[[5]]),
    unemployment_rate = as.numeric(row$values[[1]])
  )
}))

## ---- Download unemployment data from the new SCB table -----------------
##
## Same idea, but the table structure and variable codes changed in 2022.
labour_new_raw <- request(new_url) |>
  req_body_json(list(
    query = list(
      list(code = "Region", selection = list(filter = "all", values = list("*"))),
      list(code = "Kon", selection = list(filter = "item", values = list("1+2"))),
      list(code = "UtbNiv", selection = list(filter = "item", values = list("000"))),
      list(code = "BakgrVar", selection = list(filter = "item", values = list("TOT"))),
      list(code = "ContentsCode", selection = list(filter = "item", values = list("000007K8"))),
      list(
        code = "Tid",
        selection = list(filter = "item", values = as.list(as.character(2022:2023)))
      )
    ),
    response = list(format = "json")
  )) |>
  req_perform() |>
  resp_body_string() |>
  fromJSON(simplifyVector = FALSE)

labour_new <- rbindlist(lapply(labour_new_raw$data, function(row) {
  data.table(
    municipality_code = row$key[[1]],
    year = as.integer(row$key[[5]]),
    unemployment_rate = as.numeric(row$values[[1]])
  )
}))

## ---- Download municipality names ---------------------------------------
##
## Kolada returns many region-like objects. We only keep municipalities,
## which are marked with type == "K".
municipality_key_raw <- request(key_url) |>
  req_perform() |>
  resp_body_string() |>
  fromJSON(simplifyVector = FALSE)

municipality_key <- rbindlist(lapply(municipality_key_raw$values, function(row) {
  data.table(
    municipality_code = row$id,
    municipality_name = row$title,
    type = row$type
  )
}))[type == "K", .(municipality_code, municipality_name)]

## ---- Merge the pieces ---------------------------------------------------
##
## First stack the two unemployment tables on top of each other.
## Then merge in municipality names using municipality_code.
panel <- merge(
  rbindlist(list(labour_old, labour_new)),
  municipality_key,
  by = "municipality_code",
  all.x = TRUE
)[order(year, municipality_code), .(
  municipality_code,
  municipality_name,
  year,
  unemployment_rate
)]

## Save the finished lecture demo dataset so the slides can load it later.
fwrite(panel, output_file)

## Print a small preview so students can see what we built.
print(panel[1:10])

## Collapse to one average unemployment rate per year.
unemployment_summary <- panel[
  ,
  .(unemployment_rate = mean(unemployment_rate, na.rm = TRUE)),
  by = year
]

## ---- Plot 1: one national average line ---------------------------------
##
## This is a very simple summary plot: one point and one line per year.
print(
  ggplot(unemployment_summary, aes(x = year, y = unemployment_rate)) +
    geom_line(linewidth = 1.1, color = "#0d3b66") +
    geom_point(size = 2.4, color = "#0d3b66") +
    scale_x_continuous(breaks = sort(unique(unemployment_summary$year))) +
    labs(
      title = "Average municipal unemployment rate",
      subtitle = "Simple national mean from the saved lecture demo dataset",
      x = NULL,
      y = NULL
    ) +
    theme_minimal(base_size = 18) +
    theme(panel.grid.minor = element_blank())
)

## ---- Plot 2: one grey line per municipality -----------------------------
##
## This plot is much busier. That is useful in class because it shows:
## - how quickly a plot becomes hard to read,
## - why aggregation can be useful,
## - why plotting all units at once can still be informative.
print(
  ggplot(
    panel,
    aes(
      x = year,
      y = unemployment_rate,
      group = municipality_code,
      color = municipality_name
    )
  ) +
    geom_line(alpha = 0.35, linewidth = 0.5, show.legend = FALSE) +
    scale_color_grey(start = 0.25, end = 0.75) +
    scale_x_continuous(breaks = sort(unique(panel$year))) +
    labs(
      title = "Municipal unemployment rates",
      subtitle = "Each grey line is one municipality",
      x = NULL,
      y = NULL
    ) +
    theme_minimal(base_size = 18) +
    theme(
      legend.position = "none",
      panel.grid.minor = element_blank()
    )
)
