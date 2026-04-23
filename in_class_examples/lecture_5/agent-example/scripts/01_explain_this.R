# ============================================================
# Example 1 — Agent as a reading aid
#
# The code below runs fine. Your goal is to practice using the
# agent to *understand* existing code — the lowest-stakes way
# to start working with an AI agent.
#
# Try in Copilot Chat (Agent mode):
#
#   #file:scripts/01_explain_this.R
#   Explain what this script does step by step. What does the
#   final data frame contain, and what would its column names
#   be?
#
# Follow-ups to try once the first answer lands:
#   - Which line would break if a municipality only had one year
#     of data?
#   - Rewrite the last two lines without `do.call(rbind, ...)`.
#   - Is there a simpler base-R way to express the whole thing?
# ============================================================

panel <- read.csv(
  "data/mini_panel.csv",
  colClasses = c(municipality_code = "character")
)

municipality_trend <- function(chunk) {
  chunk <- chunk[order(chunk$year), ]
  data.frame(
    municipality_code = chunk$municipality_code[1],
    first_year = min(chunk$year),
    last_year = max(chunk$year),
    change_pp = chunk$unemployment_rate[nrow(chunk)] -
      chunk$unemployment_rate[1]
  )
}

by_municipality <- split(panel, panel$municipality_code)
trends <- lapply(by_municipality, municipality_trend)
trends_df <- do.call(rbind, trends)

print(trends_df)
