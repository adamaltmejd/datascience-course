# SCB

Researched: 2026-03-19

## What it is

Statistics Sweden (`SCB`) provides official statistics, the Statistical Database, open geodata, and other open datasets.

## Access and licensing

- SCB open data is free to use.
- SCB uses the `CC0` licence for its own open data.
- The API allows at most 10 calls in a 10-second period from one IP address.
- The API returns at most 100,000 values per table.

## API notes

- `PxWebApi v2` was launched in October 2025.
- v2 supports `GET`, not only `POST`.
- v2 has more stable URL structure and exposes more metadata than v1.

## Course-relevant data found so far

- Population by municipality, age, education, and year:
  https://www.statistikdatabasen.scb.se/sq/125351
- Labour-market variables by municipality, sex, education, and background variable, 1997-2021:
  https://www.statistikdatabasen.scb.se/goto/sv/ssd/IntGr1KomKonUtb
- Income variables by municipality, 1997-2023:
  https://www.statistikdatabasen.scb.se/pxweb/sv/ssd/START__AA__AA0003__AA0003F/IntGr5Kom/
- Population by region, civil status, sex, and year:
  https://www.statistikdatabasen.scb.se/sq/154317
- Municipal turnout:
  https://www.statistikdatabasen.scb.se/sq/92086
- CPI / CPIF by detailed consumption category.
- Household expenditure (`HUT`) tables for expenditure shares by household group.
- Household housing-expense statistics.

## What makes SCB attractive for the course

- Official and stable source.
- Municipality and year identifiers make it easy to teach joins.
- The data is rich enough for wrangling, reshaping, and visualization.
- It supports both broad municipal panels and narrower sectoral stories.
- API usage is real but still manageable on ordinary laptops.

## What makes SCB awkward

- Even with the improved API, it is not beginner-simple.
- Large tables force students to think about filtering and dimensional structure.
- Different tables update on different schedules.
- Some potentially useful labour-market tables lag the most recent years.
- CPI / CPIF category changes and base-year changes need explicit handling across breaks.

## Inflation and Consumption Notes

The inflation-consumption idea did not become a dataset. The viable course angle is national inflation by detailed consumption category, combined with household spending shares from `HUT`, to build synthetic group-specific inflation exposure measures.

Useful SCB facts:

- CPI / CPIF data are available by `COICOP` product groups.
- `HUT` provides household expenditure patterns by household type, tenure, and municipality-group style categories.
- `HUT` is periodic, not an annual panel.
- Open SCB data does not appear to provide municipality-level CPI for ordinary consumption baskets.
- Open SCB data also does not appear to provide a reusable item-level price panel for all representative CPI products.

Good possible questions:

- Which consumption categories drove inflation?
- Which household groups were most exposed, given their expenditure weights?
- How much do results depend on category definitions and weights?

Weak or misleading questions:

- Municipality-level consumer inflation from open SCB data.
- Item-level "cheap goods versus expensive goods" inflation without a separate item-price source.

Important caveat:

- From January 2026, CPI-related series changed `COICOP` classification and base year, so spanning 2025-2026 requires explicit treatment.

## Provisional course role

`SCB` should be the main backbone source for the course.

## Sources

- https://www.scb.se/en/services/open-data-api/
- https://www.scb.se/vara-tjanster/oppna-data/pxwebapi/pxwebapi-v2/
- https://www.scb.se/kortadresser/kpi/
- https://www.scb.se/hitta-statistik/statistik-efter-amne/priser-och-ekonomiska-tendenser/priser/konsumentprisindex-kpi/produktrelaterat/aktuellt/kpi-byter-klassificering-och-basar/
- https://www.scb.se/hitta-statistik/statistik-efter-amne/hushallens-ekonomi/hushallens-utgifter/hushallens-utgifter-hut/
- https://www.scb.se/vara-tjanster/bestall-data-och-statistik/register/hushallens-utgifter-hut/
- https://www.scb.se/hitta-statistik/statistik-efter-amne/hushallens-ekonomi/hushallens-utgifter/hushallens-boendeutgifter
