# 2026 Lecture Plan

Status: working migration map for `main`

## Fixed inputs

- `2025` is now the archive branch for the pilot course.
- `main` is the working branch for the 2026 refactor.
- The running empirical example is the municipal labour-market opportunity backbone built from `SCB` and `Kolada`.
- Early lectures should use the frozen teaching snapshot.
- The API lecture should revisit the build script rather than force live API complexity too early.
- `data.table` is the core grammar. `dplyr` can appear only as comparison or translation.

## Design rules

- Split content by prerequisites, not by old lecture boundaries.
- Do not keep a standalone "servers and VMs" lecture unless shared infrastructure actually exists.
- Introduce AI as a working tool early, but keep AI as a data-processing method for the final lecture block.
- Use the municipal backbone across lectures whenever possible instead of switching between disconnected toy examples.

## 2025 to 2026 mapping

| 2026 lecture | Main purpose | Main legacy source | Main rewrite decision |
| --- | --- | --- | --- |
| 1. Introduction to Data Science for Economists | Course identity, workflow, motivating demo, launch `PS0` | `lecture_1` | Keep the workflow spine and one motivating example. Replace Gapminder and survey-feedback demos with one concrete municipal-backbone demo. Move most R basics out. |
| 2. R Basics I | Running code, objects, vectors, missing values, basic functions | `lecture_3` plus small pieces of `lecture_1` | Treat this as a true beginner lecture. Strip away workflow and AI detours. |
| 3. R Basics II: Tabular Data and Tidy Thinking | Tables, categorical data, logical subsetting, tidy-data mental model, basic checks | `lecture_3` plus tidy-data material from `lecture_1` | Keep the tabular-data focus. Introduce `data.frame` and `data.table` here, not in lecture 1. |
| 4. Project Workflows and Version Control | Project structure, relative paths, READMEs, raw vs processed data, Git basics | `lecture_2` | Keep project hygiene and Git together. Do not bury them inside shell mechanics. |
| 5. Shell and Independent Workflows | File navigation, search, command-line comfort, Git recovery habits | `lecture_2` | Split shell from project/Git basics. Keep remote work optional. |
| 6. Data Wrangling I | Importing data, encoding, column types, missing data codes, core `data.table` syntax | early `lecture_5` | Use the municipal backbone and source tables instead of generic dog data where possible. |
| 7. Data Wrangling II | Grouped summaries, joins, reshape, strings, dates, validation | later `lecture_5` | Make validation explicit instead of treating it as a side note. |
| 8. Visualization | Exploration, validation, communication, grammar of graphics | `lecture_4` | Retain the strong visualization material, but pivot examples toward the backbone dataset. |
| 9. APIs and External Data | HTTP, JSON, auth, rate limits, turning responses into tables | API half of `lecture_6` | Rebuild part of the municipal backbone from `SCB` and `Kolada`. Web scraping stays secondary. |
| 10. LLMs for Data Processing | Structured extraction, classification, summarization, validation, automation | LLM half of `lecture_6` | Use text extension material such as `Arbetsformedlingen` job-ad data. Keep this grounded in verification, not hype. |

## Immediate implementation order

1. Rewrite lecture 1 around the municipal backbone and `PS0`.
2. Split the old R material into lectures 2 and 3.
3. Split the old project/Git/shell lecture into lectures 4 and 5.
4. Split the wrangling material into lectures 6 and 7.
5. Rework visualization examples around the backbone for lecture 8.
6. Split the old APIs/LLMs lecture into lectures 9 and 10, with remote/cloud content kept conditional.

## Content moves that should happen early

- Remove the old lecture-1 LLM example. It belongs in lecture 10.
- Remove the old lecture-1 Gapminder intro example. The course should open on the running backbone instead.
- Move most R-versus-Stata comparison out of the center of lecture 1. One short justification is enough.
- Keep `PS0` as an actual smoke test: open project, run script, commit once, prove the environment works.

## Open implementation questions

- Whether remote/cloud computing makes the core course depends on actual infrastructure, not aspiration.
- Whether to freeze the backbone at `2016-2023` or add selected `2024` series can wait until the slide refactor reaches lectures 9 and 10.
- The problem-set sequence should be written against the new lecture order, not retrofitted from the 2025 pilot.
