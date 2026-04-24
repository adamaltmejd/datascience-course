# Municipal Opportunity Panel

## Files

- `municipal_opportunity_panel_2016_2023.csv`
- `build_municipal_opportunity_panel.R`

## Purpose

Frozen teaching backbone for the 2026 course redesign.

The dataset gives the course a coherent municipality-year story about labour-market opportunity, income, education, entrepreneurship, and local labour-market outcomes. It is descriptive, not causal.

Use the frozen CSV in early lectures. Use the build script later when API work is the point.

## Unit and Keys

- unit: municipality-year
- keys: `municipality_code`, `year`
- coverage: 2016-2023
- municipalities: 290
- rows: 2320

Read `municipality_code` as text, not numeric. Several municipality codes have leading zeroes.

## Variables

- `municipality_code`: four-digit municipality code
- `municipality_name`: municipality name from `Kolada`
- `year`: calendar year
- `population_total`: total population from `SCB`
- `population_working_age`: population aged `20-64`
- `share_postsecondary`: share of people aged `25-64` with post-secondary education
- `employment_rate`: stitched `SCB` employment measure
- `unemployment_rate`: stitched `SCB` registered unemployment measure
- `labour_market_source_table`: `SCB` source table used for the labour-market series in that year
- `disposable_income_pbb`: median disposable income in price base amounts
- `price_base_amount`: annual price base amount used for nominal conversion
- `disposable_income_sek_nominal`: nominal SEK version of `disposable_income_pbb`
- `new_firm_starts_per_1000_16_64`: `Kolada` KPI `N00999`
- `program_exit_to_work_or_study_share`: `Kolada` KPI `U40455`

## Source Mapping

- `SCB BE0101A/BefolkningNy`: population totals and working-age population
- `SCB UF0506B/Utbildning`: education counts
- `SCB AA0003X/IntGr1KomKonUtb`: labour-market variables for 2016-2021
- `SCB AA0003B/IntGr1KomUtbBAS`: labour-market variables for 2022-2023
- `SCB AA0003F/IntGr5Kom`: income series
- `Kolada N00999`: new firm starts
- `Kolada U40455`: municipal labour-market program outcome

The panel window is frozen at 2016-2023 because it is the overlap implemented in the current build and avoids overselling a newer panel whose source coverage has not been checked.

## Build Notes

Run from the repository root:

```sh
Rscript data-sources/data/municipal-opportunity-panel/build_municipal_opportunity_panel.R
```

The script writes the CSV next to itself.

Required R packages:

- `curl`
- `data.table`
- `jsonlite`

Implementation choices:

- keep `municipality_code` as a zero-padded four-character string
- use total gender values where the source exposes gender
- build `share_postsecondary` from counts rather than using a precomputed rate
- keep `labour_market_source_table` because the labour-market measures are stitched
- keep both `disposable_income_pbb` and `disposable_income_sek_nominal`

## Important Caveats

- `employment_rate` is not a seamless long series. It is stitched across two `SCB` tables and should be taught with a continuity warning.
- `unemployment_rate` is cleaner than `employment_rate`, but it is still stitched across two `SCB` tables.
- `disposable_income_sek_nominal` is easier to interpret than `disposable_income_pbb`, but it is nominal rather than fixed-price.
- `program_exit_to_work_or_study_share` has substantial missingness in some municipality-years and should not be treated as uniformly complete.
- `Kolada` values and metadata can be revised without separate notice.

## Teaching Role

Good uses:

- import checks and key handling
- grouped summaries
- joins and validation
- missingness checks
- wide-long reshaping
- descriptive visualization
- later API reconstruction

Good optional extensions:

- municipal turnout from `Valmyndigheten` or `SCB`
- similar municipalities from `Kolada`
- `Företagsklimat Insikt - Totalt, Index`, with explicit handling of the 2024 definition break
- `Arbetsformedlingen` job-ad text as a later API/text/LLM extension

Do not make these core variables in the first teaching version:

- long-term economic assistance
- school outcomes
- planning or building-permit times
- generic municipal finance indicators

They are plausible extensions, but they pull the dataset away from the labour-market opportunity story.
