#!/usr/bin/env Rscript

# Local-only media build for lecture 10. Run through build_animated_figures.sh
# so the course .Rprofile does not activate rv.
library(av)
library(data.table)
library(gapminder)
library(gganimate)
library(ggplot2)
library(ragg)
library(scales)
library(here)
lecture_dir <- here("lectures", "lecture_10")

theme_set(
  theme_bw(base_size = 12) %+replace%
    theme(
      plot.background = element_rect(fill = 'transparent', color = NA)
    )
)

save_animation <- function(
  animation,
  poster,
  video_name,
  poster_name,
  duration
) {
  fps <- 12
  video_path <- file.path(lecture_dir, video_name)
  poster_path <- file.path(lecture_dir, poster_name)

  ggsave(
    filename = poster_path,
    plot = poster,
    device = ragg::agg_png,
    width = 1280,
    height = 720,
    units = "px",
    dpi = 144
  )

  animate(
    animation,
    width = 1280,
    height = 720,
    fps = fps,
    nframes = duration * fps + 1,
    device = "ragg_png",
    res = 144,
    renderer = av_renderer(video_path)
  )

  message("Wrote: ", video_path)
  message("Wrote: ", poster_path)
}

plotdata <- as.data.table(gapminder::gapminder)[continent != "Oceania"]
plotdata[, country := as.character(country)]
plotdata[, continent := as.character(continent)]

countries <- sort(unique(plotdata$country))
country_colors <- grDevices::hcl.colors(length(countries), palette = "Dynamic")
names(country_colors) <- countries

make_rosling_plot <- function(data, title) {
  ggplot(
    data,
    aes(
      x = gdpPercap,
      y = lifeExp,
      size = pop,
      color = country
    )
  ) +
    geom_point(alpha = 0.6, show.legend = FALSE) +
    scale_color_manual(values = country_colors) +
    scale_size(range = c(2, 13)) +
    scale_x_log10(
      limits = c(150, 115000),
      labels = comma
    ) +
    facet_wrap(vars(continent)) +
    coord_fixed(ratio = 1 / 43) +
    labs(
      title = title,
      x = "GDP per capita",
      y = "Life expectancy"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      legend.position = "none",
      panel.grid.minor = element_blank(),
      plot.title = element_text(face = "bold")
    )
}

rosling_poster <- make_rosling_plot(plotdata[year == max(year)], "Year: 2007")
rosling_animation <- make_rosling_plot(plotdata, "Year: {frame_time}") +
  transition_time(year) +
  ease_aes("linear")

save_animation(
  animation = rosling_animation,
  poster = rosling_poster,
  video_name = "rosling-gapminder.mp4",
  poster_name = "rosling-gapminder-poster.png",
  duration = 10
)

fohm_dt <- fread(file.path(lecture_dir, "fohm_c19_death_data.csv"))[
  !is.na(date)
]
fohm_dt[, publication_date := as.IDate(publication_date)]
fohm_dt[, date := as.IDate(date)]

fohm_window <- fohm_dt[
  publication_date %between%
    as.IDate(c("2020-04-13", "2020-05-15")) &
    date %between% as.IDate(c("2020-03-01", "2020-04-30"))
]

make_fohm_plot <- function(data, title) {
  ggplot(data, aes(x = date, y = N, group = date)) +
    geom_col() +
    scale_x_date() +
    scale_y_continuous(expand = expansion(mult = c(0, 0.04))) +
    geom_vline(xintercept = as.Date("2020-04-08")) +
    geom_hline(yintercept = 70) +
    coord_cartesian(
      xlim = as.Date(c("2020-03-01", "2020-04-30")),
      ylim = c(0, 120)
    ) +
    labs(
      title = title,
      x = NULL,
      y = "Deaths"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      panel.grid.minor = element_blank(),
      plot.title = element_text(face = "bold")
    )
}

fohm_poster <- make_fohm_plot(
  fohm_window[publication_date == max(publication_date)],
  "Publication date: 2020-05-15"
)

fohm_animation <- make_fohm_plot(
  fohm_window,
  "Publication date: {frame_time}"
) +
  transition_time(publication_date) +
  ease_aes("linear")

save_animation(
  animation = fohm_animation,
  poster = fohm_poster,
  video_name = "fohm-deaths-by-publication-date.mp4",
  poster_name = "fohm-deaths-by-publication-date-poster.png",
  duration = 10
)
