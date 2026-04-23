# ============================================================
# Example 3 — Agent as a safety engineer
#
# The code below works on today's input but has no guards.
# Any small change — missing column, wrong path, empty filter,
# unexpected NA, bad year — will make it crash cryptically or
# return silent garbage.
#
# Try in Copilot Chat (Agent mode):
#
#   #file:scripts/03_add_safety_checks.R
#   Add fail-early checks to this script using stop(),
#   warning(), and message(). Do not restructure the script
#   or add packages. Keep the checks close to where the
#   assumption is first used.
#
# A good answer should check at least:
#   - The input file exists
#   - Required columns are present
#   - The filter on `chosen_code` did not return zero rows
#   - `unemployment_rate` is numeric and within 0–100
#   - `year` values are in a plausible range
#
# Follow-up: ask the agent to break one assumption on purpose
# (e.g. misspell a column) and show that the new guard fires
# with a readable message.
# ============================================================

panel_path <- "data/mini_panel.csv"
panel <- read.csv(panel_path, colClasses = c(municipality_code = "character"))

chosen_code <- "0180"
chosen_rows <- panel[panel$municipality_code == chosen_code, ]

latest_year <- max(chosen_rows$year)
latest_rate <- chosen_rows$unemployment_rate[chosen_rows$year == latest_year]

cat(
  "Latest rate for",
  chosen_code,
  "in",
  latest_year,
  "=",
  latest_rate,
  "%\n"
)
