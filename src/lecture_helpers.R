show_file <- function(path, lang = "r") {
  lines <- readLines(path, warn = FALSE)
  comment_prefix <- switch(
    lang,
    r = "# ",
    py = "# ",
    sh = "# ",
    bash = "# ",
    md = "<!-- ",
    "# "
  )
  comment_suffix <- if (identical(lang, "md")) " -->" else ""

  if (identical(lang, "r")) {
    lines <- lines[!grepl("^\\s*#", lines)]

    while (length(lines) > 0 && trimws(lines[1]) == "") {
      lines <- lines[-1]
    }

    while (length(lines) > 0 && trimws(lines[length(lines)]) == "") {
      lines <- lines[-length(lines)]
    }
  }

  cat(
    paste0(
      "```", lang, "\n",
      comment_prefix, path, comment_suffix, "\n",
      paste(lines, collapse = "\n"),
      "\n```\n"
    )
  )
}

show_code <- function(code, lang = "r") {
  cat(
    paste0(
      "```", lang, "\n",
      paste(code, collapse = "\n"),
      "\n```\n"
    )
  )
}

run_bad_file <- function(path, echo = FALSE, output = TRUE, traceback = FALSE) {
  if (echo) {
    show_file(path)
  }

  if (!output && !traceback) {
    return(invisible(NULL))
  }

  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  expr <- paste0(
    "old_error <- getOption(\"error\"); ",
    "on.exit(options(error = old_error), add = TRUE); ",
    "options(error = function() traceback(2)); ",
    "source(", encodeString(path, quote = "\""), ", chdir = TRUE)"
  )

  out <- system2(
    "Rscript",
    c("-e", shQuote(expr)),
    stdout = TRUE,
    stderr = TRUE
  )

  error_start <- grep("^Error", out)[1]
  traceback_start <- grep("^(Calls:|[0-9]+: )", out)[1]

  error_lines <- character()
  traceback_lines <- character()

  if (length(out) > 0) {
    if (is.na(error_start)) {
      error_lines <- out
    } else {
      error_end <- if (is.na(traceback_start)) length(out) else traceback_start - 1
      error_lines <- out[seq.int(error_start, error_end)]

      if (!is.na(traceback_start)) {
        traceback_lines <- out[seq.int(traceback_start, length(out))]
      }
    }
  }

  if (identical(knitr::opts_current$get("results"), "asis")) {
    opts <- knitr::opts_current$get()
    opts$results <- "markup"
    hook <- knitr::knit_hooks$get("output")

    render_output <- function(lines) {
      if (length(lines) == 0) {
        return(invisible(NULL))
      }

      cat(hook(paste0(paste(lines, collapse = "\n"), "\n"), opts))
    }

    if (output) {
      render_output(error_lines)
    }

    if (traceback) {
      show_code("traceback()")
      render_output(traceback_lines)
    }
  } else {
    lines_to_show <- c(
      if (output) error_lines,
      if (traceback) traceback_lines
    )

    if (length(lines_to_show) > 0) {
      writeLines(lines_to_show)
    }
  }

  invisible(out)
}
