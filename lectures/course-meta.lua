-- course-meta.lua
-- Reads course-code, course-name, institution, lecture-number from YAML.
-- Injects:
--   1. Footer text via JS: "EC7422: Lecture 4 · Stockholm University"
--   2. Course header on title slide via JS
-- Shared fields go in _metadata.yml, lecture-number per lecture.

function Pandoc(doc)
  local code = pandoc.utils.stringify(doc.meta["course-code"] or "")
  local name = pandoc.utils.stringify(doc.meta["course-name"] or "")
  local inst = pandoc.utils.stringify(doc.meta["institution"] or "")
  local num  = pandoc.utils.stringify(doc.meta["lecture-number"] or "")

  if code == "" then return doc end

  local date = pandoc.utils.stringify(doc.meta["date"] or "")

  -- Build footer text: EC7422 · Lecture 4 · Stockholm University
  local footer_parts = { code }
  if num ~= "" then table.insert(footer_parts, "Lecture " .. num) end
  if inst ~= "" then table.insert(footer_parts, inst) end
  local footer = table.concat(footer_parts, " · ")

  -- Update subtitle to include date: "Lecture 4 · 2026-04-16"
  if num ~= "" and date ~= "" then
    doc.meta.subtitle = pandoc.Inlines({
      pandoc.Str("Lecture " .. num .. " · " .. date)
    })
  end

  -- Get author info. Quarto flattens author to a MetaList of MetaInlines.
  -- Email is in the original YAML but not in the flattened structure,
  -- so we read it from a custom field or the raw author block.
  local author_name = ""
  if doc.meta.author then
    author_name = pandoc.utils.stringify(doc.meta.author[1] or doc.meta.author)
  end
  -- Quarto stores email separately; fall back to custom field
  local author_email = pandoc.utils.stringify(doc.meta["author-email"] or "")

  -- JS that sets footer and injects course header on title slide
  local course_line = code .. ": " .. name .. ", " .. inst
  local instructor_line = ""
  if author_name ~= "" then
    instructor_line = "Instructor: " .. author_name
    if author_email ~= "" then
      instructor_line = instructor_line .. ", " .. author_email
    end
  end

  local js = string.format([[
<script>
document.addEventListener('DOMContentLoaded', function() {
  // Set footer and hide on title slide
  var f = document.querySelector('.reveal .footer');
  if (f) {
    f.textContent = %q;
    function toggleFooter(slide) {
      f.style.display = (slide.id === 'title-slide') ? 'none' : '';
    }
    if (typeof Reveal !== 'undefined' && Reveal.isReady && Reveal.isReady()) {
      toggleFooter(Reveal.getCurrentSlide());
    }
    Reveal.on('ready', function(e) { toggleFooter(e.currentSlide); });
    Reveal.on('slidechanged', function(e) { toggleFooter(e.currentSlide); });
  }

  // Add course header to title slide
  var ts = document.getElementById('title-slide');
  if (ts) {
    var h = document.createElement('div');
    h.className = 'course-header';
    h.innerHTML = %q + '<br>' + %q;
    ts.insertBefore(h, ts.firstChild);
  }
});
</script>
]], footer, course_line, instructor_line)

  doc.blocks:insert(pandoc.RawBlock("html", js))
  return doc
end
