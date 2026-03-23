# Data science for Economists (Stockholm university)

This repository contains course material for EC7422, "Data science for economic analysis", at Stockholm University.

# Repository structure

- `lectures/`: lecture slides and supporting assets
- `problem_sets/`: problem set material
- `in_class_examples/`: short example scripts used in class

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).

# Building the slides

The [course repository](https://github.com/adamaltmejd/datascience-course) uses [Quarto](https://quarto.org) and `R` to build the slides and documents. If you want to build the repository locally, you first need to install Quarto and R, and clone the repository. Once that is done, open an R session and run `renv::restore()` to install all required packages. This might take a while. But after it is done it should be possible to run `quarto render` (from a shell) to build all documents.
