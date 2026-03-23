# Data science for Economists (Stockholm university)

This repository contains course material for EC7422, "Data science for economic analysis", at Stockholm University.

# 2026 schedule

Times below are preliminary and may change.
Students should rely on the official schedule in [TimeEdit](https://cloud.timeedit.net/su/web/stud1/s.html?sid=8&object=cevt_33060_VT2026&type=courseevent&h=t&startdate=20260221&enddate=20260905&l=en), not this table.
Material links will be added as lecture slides and handout PDFs are published.

| Lecture | Date | Time | Materials |
| --- | --- | --- | --- |
| 1. Introduction to Data Science for Economists | Tuesday, March 24, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 2. Project Workflows and Version Control | Monday, March 30, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 3. R Basics I | Tuesday, April 7, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 4. R Basics II: Tabular Data and Tidy Thinking | Thursday, April 16, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 5. Shell and Independent Workflows | Thursday, April 23, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 6. Data Wrangling I | Tuesday, April 28, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 7. Data Wrangling II | Tuesday, May 5, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |
| 8. APIs and External Data | Tuesday, May 12, 2026 | 13:00-15:00 | Slides: pending. Handout PDF: pending. |
| 9. LLMs for Data Processing | Tuesday, May 19, 2026 | 13:00-15:00 | Slides: pending. Handout PDF: pending. |
| 10. Visualization and Communication | Thursday, May 28, 2026 | 10:00-12:00 | Slides: pending. Handout PDF: pending. |

## Office hours and exam

- Office hours: Thursday, March 26, 2026, `14:00-15:00` (location not set in calendar)
- Office hours: Thursday, April 16, 2026, `14:00-15:00` (location not set in calendar)
- Written exam: Thursday, June 4, 2026, `08:00-11:00` (location to be announced)
- Re-exam: Friday, August 28, 2026, `08:00-11:00` (location to be announced)

# Problem sets

Problem sets are released through GitHub Classroom.
The working target is about two weeks of student working time for each regular problem set. Exact due dates will be announced later.

- `PS0` is published in lecture 1.
- `PS1` is published after lecture 2.
- `PS2` is published after lecture 6.
- `PS3` is published after lecture 9.

# Repository structure

- `lectures/`: lecture slides and supporting assets
- `problem_sets/`: problem set material
- `in_class_examples/`: short example scripts used in class

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).

# Building the slides

The [course repository](https://github.com/adamaltmejd/datascience-course) uses [Quarto](https://quarto.org) and `R` to build the slides and documents. If you want to build the repository locally, you first need to install Quarto and R, and clone the repository. Once that is done, open an R session and run `renv::restore()` to install all required packages. This might take a while. But after it is done it should be possible to run `quarto render` (from a shell) to build all documents.
