---
applyTo: "scripts/**/*.R"
---

Data lives in `data/mini_panel.csv`. Columns:

- `municipality_code` — character, leading zeros matter (e.g. `"0180"` is Stockholm)
- `municipality_name` — character
- `year` — integer, 2021–2023
- `unemployment_rate` — numeric, percent, 0–100

Always load the CSV with:

```r
read.csv("data/mini_panel.csv", colClasses = c(municipality_code = "character"))
```

to preserve leading zeros.

When editing an R script in `scripts/`:

- Use `str()`, `class()`, `head()` to inspect before editing.
- Use `stop()`, `warning()`, `message()` for guards over assertion packages.
- Keep functions short and explicit; one purpose per function.
- When debugging, find the first bad assumption before rewriting anything.
