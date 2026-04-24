# Kolada

Researched: 2026-03-19

## What it is

`Kolada` is an open database for municipalities and regions run by `RKA`. It contains more than 6,000 indicators and several comparison tools.

## Access and licensing

- Kolada data and API use are free of charge.
- No agreement is required.
- If Kolada data is used directly in a service, the source should be stated as `Källa: Kolada`.
- If the data is processed by the user, Kolada should not be stated as the source.

## API notes

- API v3 was released on 2025-04-04.
- API v2 is retired on 2026-03-31.
- Kolada explicitly says data can be revised without separate notice.
- Individual indicators can disappear if their underlying source changes.
- Swagger UI exists, but the API is still aimed at users who already know how to work with APIs.

## Metadata strengths

Each indicator has metadata such as:

- `id`
- `title`
- `description`
- `municipality_type`
- `operating_area`
- `perspective`
- `publication_date`
- `publication_period`
- `has_ou_data`

This is useful for teaching metadata awareness and source criticism.

## What makes Kolada attractive for the course

- Excellent complement to `SCB` for municipality-level outcomes and performance.
- Strong coverage of schools, social services, business climate, housing, planning, costs, and quality indicators.
- Includes publication metadata and structured indicator descriptions.
- Supports richer municipal stories than SCB alone.

Examples seen during exploration:

- `Företagsklimat Insikt - Totalt, Index`
- `Nystartade företag, antal/1000 inv, 16-64 år`
- `Resultat vid avslut i kommunens arbetsmarknadsverksamhet, deltagare som börjat arbeta eller studera, andel (%)`
- `Vuxna biståndsmottagare (18+ år) med långvarigt ekonomiskt bistånd, andel (%) av biståndsmottagare 18+ år`
- `Elever i åk 9, meritvärde, hemkommun, genomsnitt (17 ämnen)`
- `Elever i åk 9 som är behöriga till yrkesprogram, hemkommun, andel (%)`
- `Gymnasieelever med examen inom 4 år, hemkommun, andel (%)`
- `Handläggningstid ... för bygglov ... antal dagar`

## What makes Kolada awkward

- Too many indicators for a beginner course unless the course pre-curates a small set.
- API behaviour and documentation are not beginner-friendly.
- Rolling publication and quiet revisions make it less stable pedagogically than SCB.
- Students can easily drown in source choice unless the course narrows the scope.

## Provisional course role

`Kolada` should be the main municipal complement to `SCB`, not the first source students meet.

## Sources

- https://kolada.se/
- https://kolada.se/om-oss/api/
- https://www.kolada.se/help/liknande-kommuner-regioner
