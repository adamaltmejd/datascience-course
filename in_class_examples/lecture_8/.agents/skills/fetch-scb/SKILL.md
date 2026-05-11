---
name: fetch-scb
description: Search SCB tables and fetch tidy slices as data.table. Use for Swedish official-statistics questions by region, year, or demographic.
---

# fetch-scb

R scripts for searching, querying, and parsing live in `scripts/`:

- `scripts/scb_search.R` defines `scb_search_tables(...)` for finding relevant tables by keyword
- `scripts/scb_meta.R` defines `scb_metadata(...)` for fetching data codes and slicing dimensions
- `scripts/scb_query.R` defines `scb_query(...)` for fetching and parsing tidy data

## Workflow

1. If the user names a topic, search with `scb_search_tables(...)`. Show top hits, ask which to use.
2. `scb_metadata(...)`: confirm metric (`ContentsCode`) and dimensions.
3. `scb_query(...)`: with `selections` listing only the dimensions to pin

## Example

```r
source("scripts/scb_search.R")
source("scripts/scb_meta.R")
source("scripts/scb_query.R")

scb_search_tables("population marital status", lang = "en", page_size = 3)

meta <- scb_metadata("TAB638", lang = "en")
dim_codes(meta, "ContentsCode")

population <- scb_query(
  "TAB638",
  selections = list(
    Region = c("0114", "0180", "1480", "2480"),
    Tid = "top(5)",
    ContentsCode = "BE0101N1"
  ),
  lang = "en"
)
population
```

## Gotchas

- **Labour-market series breaks in 2022.** Pre-2022 lives in one table,
  2022+ in another. The series is *not* seamless — keep a `source_table`
  column so the join is auditable.
- **414 URI Too Long.** `valueCodes[Alder]` with many ages overflows the
  URL. Split age ranges into chunks of ≤ 25 codes and `rbindlist`.
- **Income is in price-base amounts (`pbb`)**, not SEK. Join the yearly
  `prisbasbelopp` to convert. Real-terms comparisons need the index too.

## Rules

1. Always set `outputFormat=json-px` — the parser expects that shape.
2. Pin `ContentsCode` and `Tid`. Drop dimensions where `elimination = TRUE`.
3. Sleep ≥ 0.4 s between calls (SCB's 30-per-10-s limit). Retry once on `503`.
4. SCB returns everything as character — convert numeric columns explicitly.
5. Cite table ID, `ContentsCode`, and time range in any output that uses the data.