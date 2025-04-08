# Data science for Economists (Stockholm university)

This is a repository for my course "Data science for Economists" to be given for the first time in april 2025. This first year is a trial version of only 6 lectures, covering the most important topics.

# Lectures

* Lecture 1: Introduction ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_1/lecture_1.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_1/lecture_1.html?view=print))
* Lecture 2: Lecture 2: Project management, version control, and the shell ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_2/lecture_2.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_2/lecture_2.html?view=print))
* Lecture 3: R basics ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_3/lecture_3.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_3/lecture_3.html?view=print))
* Lecture 4: Visualization ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_4/lecture_4.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_4/lecture_4.html?view=print))
* Lecture 5: Data wrangling in R ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_5/lecture_5.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_5/lecture_5.html?view=print))
* Lecture 6: Servers, VMs, APIs, LLMs ([slides](https://adamaltmejd.se/datascience-course/lectures/lecture_6/lecture_6.html), [handout](https://adamaltmejd.se/datascience-course/lectures/lecture_6/lecture_6.html?view=print))

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).


# Cloining the repository and building the slides

The repository uses [Quarto](https://quarto.org) and `R` to build the slides and documents. If you want to build the repository locally, you first need to install Quarto and R, and clone the repository. Once that is done, open an R session and run `renv::restore()` to install all required packages. This might take a while. But after it is done it should be possible to run `quarto render` (from a shell) to build all documents.