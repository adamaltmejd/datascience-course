# Data science for Economists (Stockholm university)

This repository now tracks the 2026 refactor of EC7422, "Data science for economic analysis", at Stockholm University.

# Branches

- `main`: active 2026 development branch
- `2025`: archived 2025 pilot course

The current `lectures/lecture_1` through `lectures/lecture_6` directories are legacy 2025 source material. They are being split and rewritten into the 2026 structure rather than treated as the final lecture layout.

# 2026 plan

- Working lecture plan and migration map: [docs/lecture-plan-2026.md](docs/lecture-plan-2026.md)
- Running empirical backbone: municipal labour-market opportunity panel built from `SCB` and `Kolada`
- Target assessment structure: `PS0` plus 3 graded problem sets and a written exam

`main` will contain a transitional state for a while. That is intentional. The old 2025 course now lives on the `2025` branch instead of being implicitly mixed into the active branch.

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).

# Building the slides

The [course repository](https://github.com/adamaltmejd/datascience-course) uses [Quarto](https://quarto.org) and `R` to build the slides and documents. If you want to build the repository locally, you first need to install Quarto and R, and clone the repository. Once that is done, open an R session and run `renv::restore()` to install all required packages. This might take a while. But after it is done it should be possible to run `quarto render` (from a shell) to build all documents.
