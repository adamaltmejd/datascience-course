# Data science for Economists (Stockholm university)

This is the course repository for "Data science for Economists" (EC7412), a course within the M.Sc. program in Economics at Stockholm university, to be given for the first time in April 2025. This first year the course is only 6 lectures long, covering the most important topics. It will be extended to a full 7.5 ECTS course in 2026.

# Lectures

* Lecture 1: Introduction ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_1/lecture_1.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_1/lecture_1.html?view=print))
* Lecture 2: Lecture 2: Project management, version control, and the shell ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_2/lecture_2.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_2/lecture_2.html?view=print))
* Lecture 3: R basics ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_3/lecture_3.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_3/lecture_3.html?view=print))
* Lecture 4: Visualization ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_4/lecture_4.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_4/lecture_4.html?view=print))
* Lecture 5: Data wrangling in R ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_5/lecture_5.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_5/lecture_5.html?view=print))
* Lecture 6: Servers, VMs, APIs, LLMs ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_6/lecture_6.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_6/lecture_6.html?view=print))

The lectures are in html format to support interactive content. The handouts are prepared for printing. If you want the slides as pdfs, the best way is to print the handout, but select "Save as PDF" in the print dialog.

# Problem sets

* [Problem set 0](https://adamaltmejd.se/datascience-course/problem_sets/problem_set_0/problem_set_0.html)
* Problem set 1 (will be published after lecture 4)
* Problem set 2 (will be published after lecture 6)

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).

# Cloining the repository and building the slides

The [course repository](https://github.com/adamaltmejd/datascience-course) uses [Quarto](https://quarto.org) and `R` to build the slides and documents. If you want to build the repository locally, you first need to install Quarto and R, and clone the repository. Once that is done, open an R session and run `renv::restore()` to install all required packages. This might take a while. But after it is done it should be possible to run `quarto render` (from a shell) to build all documents.