library(ellmer)
library(data.table)
source(file.path(
  here::here(),
  "in_class_examples",
  "lecture_8",
  ".agents",
  "skills",
  "fetch-scb",
  "scripts",
  "scb_query.R"
))

municipality_codes <- c(
  Stockholm = "0180",
  Göteborg = "1480",
  Malmö = "1280",
  Uppsala = "0380",
  Linköping = "0580",
  Lund = "1281"
)

fetch_population <- function(municipality) {
  scb_query(
    "TAB638",
    selections = list(
      Region = municipality_codes[[municipality]],
      Tid = as.character(2016:2024),
      ContentsCode = "BE0101N1"
    )
  )[, .(year = Tid, population = as.integer(BE0101N1))]
}

chat <- chat_google_gemini(model = "gemini-3-flash-preview")

chat$register_tool(tool(
  fetch_population,
  name = "fetch_population",
  description = "Yearly population of a Swedish municipality, 2016–2024.",
  arguments = list(
    municipality = type_enum(
      values = names(municipality_codes),
      description = "Municipality name"
    )
  )
))

chat$chat(
  "How has the population of Uppsala changed since 2016? Answer in two sentences."
)
