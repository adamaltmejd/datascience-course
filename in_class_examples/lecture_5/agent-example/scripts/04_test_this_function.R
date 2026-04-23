# ============================================================
# Example 4 — Agent as a test writer
#
# The function below has a *silent* bug. It runs without error
# on any valid panel and returns a data frame that looks
# plausible — but the `risk_group` labels are wrong.
#
# Goal: use the agent to write a testthat test that would
# catch the bug, *without* asking it to fix the function yet.
# Then fix the function yourself and re-run the test.
#
# Writing the test first is the point. It pins down the
# intended behaviour before any code changes, so the agent's
# fix can only pass if it actually gets the logic right.
#
# Try in Copilot Chat (Agent mode):
#
#   #file:scripts/04_test_this_function.R
#   Write a testthat test for classify_unemployment() that
#   would catch the silent bug. Use a tiny hand-built data
#   frame as input. Do not modify the function — just add the
#   test at the bottom of the file.
#
# Follow-ups:
#   - Run the test and watch it fail on the current function.
#   - Ask the agent to propose the smallest fix to the function
#     that makes the test pass.
#   - Ask it to write one more test for the threshold boundary
#     (`unemployment_rate == threshold`).
# ============================================================

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

panel <- read.csv(
  "data/mini_panel.csv",
  colClasses = c(municipality_code = "character")
)

classify_unemployment(panel, threshold = 10)
