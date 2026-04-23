# ============================================================
# Example 2 — Agent as a debugging partner
#
# This script errors when you source it. Your goal is to use
# the agent to locate the *first bad assumption*, not to let
# the agent "try things" until the script happens to run.
#
# Try in Copilot Chat (Agent mode):
#
#   #file:scripts/02_find_the_bug.R
#   This script errors. Explain what the first bad assumption
#   is and propose the smallest possible fix. Do not rewrite
#   the script or add packages.
#
# Follow-ups to try:
#   - Ask: "What would a traceback() look like for this error?"
#   - Ask for one guard that would catch this mistake next time.
#   - Revert the fix, change the instructions in
#     `.github/copilot-instructions.md`, and re-run to see how
#     the agent behaves differently.
# ============================================================

panel <- read.csv(
  "data/mini_panel.csv",
  colClasses = c(municipality_code = "character")
)

latest_year_rates <- function(panel) {
  latest <- max(panel$year)
  panel[panel$year == latest, "unemployment_rate"]
}

average_latest_rate <- function(panel) {
  rates <- latest_year_rates(panel)
  meen(rates)
}

average_latest_rate(panel)
