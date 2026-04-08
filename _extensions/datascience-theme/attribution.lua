-- attribution.lua
-- Moves .attribution divs from inside slide sections to .reveal
-- (viewport space) so they stay fixed at the right edge regardless
-- of Reveal's scaling. A small JS listener toggles per slide.
--
-- Usage in .qmd:
--   ::: {.attribution}
--   <https://example.com>
--   :::

function Pandoc(doc)
  if not quarto.doc.isFormat("revealjs") then return doc end

  local current_slide_id = ""
  local has_attributions = false

  for _, block in ipairs(doc.blocks) do
    if block.t == "Header" and (block.level == 1 or block.level == 2) then
      current_slide_id = block.identifier
    elseif block.t == "Div" and block.classes:includes("attribution") then
      if current_slide_id ~= "" then
        block.attributes["data-slide-id"] = current_slide_id
        has_attributions = true
      end
    end
  end

  if has_attributions then
    doc.blocks:insert(pandoc.RawBlock("html", [[
<script>
document.addEventListener('DOMContentLoaded', function() {
  var reveal = document.querySelector('.reveal');
  var attrs = Array.from(document.querySelectorAll('.attribution[data-slide-id]'));
  attrs.forEach(function(el) {
    el.parentNode.removeChild(el);
    el.style.display = 'none';
    reveal.appendChild(el);
  });
  function showAttr(slide) {
    attrs.forEach(function(el) {
      el.style.display = el.dataset.slideId === slide.id ? '' : 'none';
    });
  }
  if (typeof Reveal !== 'undefined' && Reveal.isReady && Reveal.isReady()) {
    showAttr(Reveal.getCurrentSlide());
  } else {
    Reveal.on('ready', function(e) { showAttr(e.currentSlide); });
  }
  Reveal.on('slidechanged', function(e) { showAttr(e.currentSlide); });
});
</script>
]]))
  end

  return doc
end
