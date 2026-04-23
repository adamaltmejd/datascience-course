# Agent guide

A small playground for practicing Copilot Chat in **agent mode** inside VS Code
or Positron. Each file in `scripts/` has a comment block at the top with the
task and a suggested prompt.

## How this repo steers the agent

Three files tell the agent how to behave here. Open them, read them, edit them
and watch the behaviour change:

- `AGENTS.md` — this file. Read by most agents (Copilot, Claude, Codex, Cursor).
- `.github/copilot-instructions.md` — included automatically in every Copilot chat.
- `.github/instructions/r-scripts.instructions.md` — scoped to `scripts/**/*.R` via `applyTo`.

## Rules for the agent

- Stay in base R unless the script already imports another package.
- Keep diffs small. Do not rewrite whole scripts or rename files.
- Before proposing a fix, name the *first bad assumption* in one or two sentences.
- Use `stop()`, `warning()`, `message()` for guards — not `assertthat` or `assertr`.
- Use `testthat` for tests. One `test_that(...)` block per behaviour.
- Never invent packages or functions. If unsure, say so.
- If the task is vague, ask for the smallest useful next step instead of guessing.

## How students should use this

1. Open this folder as its own workspace in VS Code or Positron.
2. Open Copilot Chat and switch to **Agent** mode.
3. Work through `scripts/01_…` to `scripts/04_…` in order.
4. For each: read the comment block, try the suggested prompt, read the diff
   before accepting, then run the code.
