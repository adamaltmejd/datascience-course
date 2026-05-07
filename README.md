# EC7422 - Econometrics 3: Data science for economic analysis

Course website: <https://adamaltmejd.github.io/datascience-course/>.

# Lectures

1. Introduction to Data Science for Economists. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_1/lecture_1.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_1/lecture_1.pdf)]
2. Project Workflows and Version Control. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_2/lecture_2.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_2/lecture_2.pdf)]
3. R Basics I. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_3/lecture_3.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_3/lecture_3.pdf)]
4. R Basics II: Vectors, Tables, and Tidy Thinking. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_4/lecture_4.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_4/lecture_4.pdf)]
5. Independent Workflows, Debugging, and AI Support. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_5/lecture_5.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_5/lecture_5.pdf)]
6. Data Wrangling I. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_6/lecture_6.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_6/lecture_6.pdf)]
7. Data Wrangling II. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_7/lecture_7.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_7/lecture_7.pdf)]
8. APIs and External Data. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_8/lecture_8.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_8/lecture_8.pdf)]
9. LLMs for Data Processing.
10. Visualization and Communication. [[Slides](https://adamaltmejd.github.io/datascience-course/lectures/lecture_10/lecture_10.html) | [Handout PDF](https://adamaltmejd.github.io/datascience-course/lectures/lecture_10/lecture_10.pdf)]

# Problem sets

Problem sets are released through GitHub Classroom. Except for the instructions to PS0, available [here](https://adamaltmejd.github.io/datascience-course/problem_sets/problem_set_0/problem_set_0.html).

# References / resources

The material in this course builds upon several excellent courses, books, and articles on programming and data science. I provide attributions throughout the notes, but want to highlight the following excellent resources:

The courses by Grant McDermott ([EC 607](https://github.com/uo-ec607/)) and Matthew Blackwell ([Gov 50](https://gov50-f23.github.io/)) have been of particular importance in preparing these materials. So have the books by Kieran Healy ([Data visualization](https://socviz.co/)) and Hadley Wickham ([R for Data Science](https://r4ds.hadley.nz/) and [Advanced R](https://adv-r.hadley.nz/)).

# Building the repo

The [course repository](https://github.com/adamaltmejd/datascience-course) uses [Quarto](https://quarto.org) and `R` to build the slides and documents. To build it locally, install Quarto, R, and the [rv](https://github.com/a2-ai/rv) CLI (on macOS: `brew install a2-ai/homebrew-tap/rv`), then clone the repository and run `rv sync` from the project root to install all required R packages. This might take a while. Afterwards, `quarto render` will build all documents into `_site/`.

If Quarto cannot write under `~/Library/Caches/quarto` or `~/Library/Application Support/quarto` in a restricted environment, use `scripts/quarto.sh` instead. It gives Quarto a repo-local home under `.quarto-home/` for that command only.

Examples:

- `scripts/quarto.sh render`
- `scripts/quarto.sh render lectures/lecture_7/lecture_7.qmd`
- `scripts/quarto.sh preview`
