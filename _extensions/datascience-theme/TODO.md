# Theme TODO

## Future layout refactor

Current decision:
- Leave the current Reveal/Quarto layout setup as-is for now.
- Do not add more one-off layout monkey-patches beyond narrowly fixing real bugs.

Potential future PR:
- Revisit the theme's slide layout model more systematically instead of relying on fixed `max-height` cutoffs and local patches.
- Treat this as a larger refactor, not a small tweak.

Possible direction:
- Audit whether Reveal's global slide `display` setting should remain `block` or become part of a broader custom-layout strategy.
- Do not flip Reveal's global `display` to `flex` in isolation. That is too blunt and likely to break unrelated slide types.
- Prefer explicit layout primitives and opt-in slide patterns over hidden global behavior.

Target behavior to support:
- Title takes natural height.
- Output takes natural height.
- Code uses the remaining height in the slide.
- Code scrolls vertically when needed.
- Output remains fully visible when reasonably small.
- Code keeps a minimum visible height of about 10 lines.

Implementation ideas for a later PR:
- Introduce theme-level layout utilities for fill-height slides/regions.
- Consider slide-level or wrapper-level grid/flex layouts for code-plus-output slides.
- Ensure `min-height: 0` is used correctly in scrollable flex/grid children.
- Add screenshot-based regression checks across representative slide types:
  - code + output
  - bullet slides
  - columns
  - figures/tables/widgets
  - handout/PDF export

Reason to defer:
- The current setup is acceptable.
- A proper foundation change should be deliberate and tested, not improvised from one bug report.

## Dark-background text color (`datascience-theme.scss:583-588`)

`section[data-background-color]` currently forces `h1/h2/h3/p/li/span` to white. That selector matches *any* background color, including light ones (e.g. `$secondary` yellow), producing white-on-light text.

Fix direction:
- Replace the attribute selector with an opt-in class (e.g. `.dark-bg`), or
- Gate on a luminance test (would require manual tagging since CSS can't read the color).
- Keep `section.level1` in the selector — section dividers are reliably dark.

## Extract inline `<script>` from `course-meta.lua` + `attribution.lua`

Both Lua filters build large inline `<script>` blocks via string templating. The same `Reveal.isReady ? run : Reveal.on('ready')` + `Reveal.on('slidechanged')` boilerplate is copy-pasted three times across the two files.

Refactor direction:
- Move the JS to one external file under the extension.
- Load via `quarto.doc.add_html_dependency`.
- Pass per-deck values as `data-` attributes on a single `<meta>` tag (or a `<script type="application/json">` block) instead of stringifying through Lua `%q`.
- Share a tiny `onSlideActive(cb)` helper so the readiness dance lives in one place.

Roughly −80 lines, but touches the way every deck gets its footer/title-block/handout-mode wiring. Defer until paired with the next item.

## Replace custom footer/title-block with Quarto natives

`course-meta.lua` injects the footer string and title-slide DOM via JS. Quarto's revealjs already supports `footer:` (with per-slide overrides) and `institute:`/`subtitle:`/`date:` in the title block. The current SCSS even hides `.quarto-title-authors` and `.date` and the Lua re-injects equivalent content — clear round-trip.

Refactor direction:
- Set `meta.footer` from a Pandoc Meta walker; drop the JS that mutates `.reveal .footer`.
- Move course-header / lecture-detail lines into `institute:` / `subtitle:` and style via SCSS.
- Use `data-footer=""` (Reveal-native) or a CSS rule on `#title-slide`/`.agenda-slide` to hide the footer where needed, instead of the JS slidechanged toggle.

Will affect every existing deck visually — pair with screenshot regression checks listed above.

## `!important` audit in `datascience-theme.scss`

~30 uses across the file. Some are genuine Quarto/Reveal specificity fights and need to stay; others are habitual and can come out.

Approach:
- Remove each `!important` one at a time, render an affected lecture, verify nothing changes.
- Likely-unnecessary candidates (rough list, verify before deleting): line 180 area, line 588, line 741, the `.agenda-slide` block where the parent selector already wins.
- Keep `!important` on rules that override Reveal's inline styles or Quarto theme defaults (those are the legitimate uses).

## `disable-on-params` comma-split footgun in `slide-remote/filter.lua`

`filter.lua` joins `disable-on-params` values with commas; `slide-remote.js` splits the resulting `<meta>` content on `,`. Breaks the day a param value contains a comma.

Fix: replace the three `<meta>` tags with a single `<script type="application/json" id="slide-remote-config">…</script>` block emitting the full config object, and read it in JS via `JSON.parse`. Removes the comma-split, also removes the stringly-typed boolean round-trip on `show-button`.
