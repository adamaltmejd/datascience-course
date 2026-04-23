-- course-meta.lua
-- Reads course-code, course-name, institution, lecture-number from YAML.
-- Injects:
--   1. Footer text: "EC7422 · Lecture 4 · Stockholm University"
--   2. Course header + detail line on title slide
--   3. Handout mode: stacks aside + notes boxes so they don't overlap
-- Shared fields go in _metadata.yml, lecture-number per lecture.

function Pandoc(doc)
  if not quarto.doc.isFormat("revealjs") then return doc end

  local code = pandoc.utils.stringify(doc.meta["course-code"] or "")
  local name = pandoc.utils.stringify(doc.meta["course-name"] or "")
  local inst = pandoc.utils.stringify(doc.meta["institution"] or "")
  local num  = pandoc.utils.stringify(doc.meta["lecture-number"] or "")
  local date = pandoc.utils.stringify(doc.meta["date"] or "")

  if code == "" then return doc end

  local footer_parts = { code }
  if num ~= "" then table.insert(footer_parts, "Lecture " .. num) end
  if inst ~= "" then table.insert(footer_parts, inst) end
  local footer = table.concat(footer_parts, " · ")

  -- Quarto flattens author to a MetaList of MetaInlines.
  -- Email is not in the flattened structure, so we read a custom field.
  local author_name = ""
  if doc.meta.author then
    author_name = pandoc.utils.stringify(doc.meta.author[1] or doc.meta.author)
  end
  local author_email = pandoc.utils.stringify(doc.meta["author-email"] or "")

  local course_line = code .. ": " .. name .. ", " .. inst
  local instructor_line = ""
  if author_name ~= "" then
    instructor_line = "Instructor: " .. author_name
    if author_email ~= "" then
      instructor_line = instructor_line .. ", " .. author_email
    end
  end

  local detail_parts = {}
  if num ~= "" then table.insert(detail_parts, "Lecture " .. num) end
  if date ~= "" then table.insert(detail_parts, date) end
  local detail_line = table.concat(detail_parts, " · ")

  local js = string.format([[
<script>
document.addEventListener('DOMContentLoaded', function() {
  var f = document.querySelector('.reveal .footer');
  if (f) {
    f.textContent = %q;
    function toggleFooter(slide) {
      var hide = slide.id === 'title-slide'
        || slide.classList.contains('agenda-slide')
        || slide.hasAttribute('data-background-color');
      f.style.display = hide ? 'none' : '';
    }
    if (typeof Reveal !== 'undefined' && Reveal.isReady && Reveal.isReady()) {
      toggleFooter(Reveal.getCurrentSlide());
    } else {
      Reveal.on('ready', function(e) { toggleFooter(e.currentSlide); });
    }
    Reveal.on('slidechanged', function(e) { toggleFooter(e.currentSlide); });
  }

  var ts = document.getElementById('title-slide');
  if (ts) {
    var h = document.createElement('div');
    h.className = 'course-header';
    var line1 = document.createTextNode(%q);
    h.appendChild(line1);
    h.appendChild(document.createElement('br'));
    h.appendChild(document.createTextNode(%q));
    ts.insertBefore(h, ts.firstChild);
    var detail = %q;
    if (detail) {
      var d = document.createElement('div');
      d.className = 'course-details';
      d.textContent = detail;
      ts.appendChild(d);
    }
  }

  // ?handout=true: the rest of this block is handout-only layout fixups
  if (new URLSearchParams(location.search).has('handout')) {
    document.body.classList.add('handout');

    // Push abs-positioned .aside up so it doesn't overlap abs-positioned note.
    function stackNotes(slide) {
      var note = slide.querySelector(':scope > aside.notes');
      var aside = slide.querySelector(':scope > aside:not(.notes)');
      if (note && aside) {
        var h = note.offsetHeight;
        requestAnimationFrame(function() {
          aside.style.bottom = (h + 8) + 'px';
        });
      }
    }

    // Mark overflowing pre blocks so CSS can render an explicit "continues
    // below" cue. Scrollbars don't render in static decktape PDFs, and
    // reveal hides non-current slides with display:none (scrollHeight=0),
    // so we re-check per slide on activation. Tolerance absorbs subpixel
    // rounding where clientHeight and scrollHeight disagree by 1-2px.
    function markOverflowingPre(slide) {
      if (!slide) return;
      slide.querySelectorAll('pre').forEach(function(pre) {
        pre.classList.toggle('is-overflowing', pre.scrollHeight > pre.clientHeight + 4);
      });
    }

    function runHandoutFixups(slide) {
      stackNotes(slide);
      markOverflowingPre(slide);
    }

    if (typeof Reveal !== 'undefined' && Reveal.isReady && Reveal.isReady()) {
      runHandoutFixups(Reveal.getCurrentSlide());
    } else if (typeof Reveal !== 'undefined') {
      Reveal.on('ready', function(e) { runHandoutFixups(e.currentSlide); });
    }
    if (typeof Reveal !== 'undefined') {
      Reveal.on('slidechanged', function(e) { runHandoutFixups(e.currentSlide); });
    }
  }
});
</script>
]], footer, course_line, instructor_line, detail_line)

  doc.blocks:insert(pandoc.RawBlock("html", js))
  return doc
end
