# Eurostat

Researched: 2026-03-19

## What it is

Eurostat provides a statistics API oriented around `JSON-stat`.

## Access notes

- The API is designed to support visualisations and other machine-readable use.
- Requests follow a structured REST pattern with dataset code, format, language, and filters.
- Regional datasets can be filtered by `geoLevel`, including different `NUTS` levels.
- Large regional datasets can be big enough that filtering is not optional.

## What makes Eurostat attractive for the course

- Strong for teaching API structure and filtering.
- Excellent if the course wants a European regional or international comparison angle.
- Good fit for a more advanced API lecture.

## What makes Eurostat awkward

- `JSON-stat` is more cognitively demanding than plain tabular CSV or simpler JSON.
- The data is often cleaner than what is ideal for an early wrangling course.
- Less natural local relevance for Stockholm economics students than Swedish sources.

## Provisional course role

Use as an optional international extension, not as the main backbone.

## Sources

- https://ec.europa.eu/eurostat/web/user-guides/data-browser/api-data-access/api-getting-started/api
