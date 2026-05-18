library(ellmer)

get_current_time <- function() {
  format(Sys.time(), tz = "Europe/Stockholm", usetz = TRUE)
}

chat <- chat_google_gemini(model = "gemini-3-flash-preview")

chat$register_tool(tool(
  get_current_time,
  name = "get_current_time",
  description = "Returns the current wall-clock time in the Europe/Stockholm time zone."
))

chat$chat(
  "How long ago exactly was Neil Armstrong's moon landing?
   Answer in years, months, and days."
)
