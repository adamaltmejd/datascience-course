-- auto-agenda.lua
-- Generates agenda/TOC slides at each H1 section header, listing all
-- sections with the current one highlighted. Absorbed from
-- andrie/reveal-auto-agenda; CSS lives in datascience-theme.scss.
--
-- Options (set in YAML front matter):
--   auto-agenda:
--     bullets: bullet | numbered | none
--     heading: "Outline"    # optional heading text
--     clickable: true       # make items link to their section

local stringify = pandoc.utils.stringify
local sections = pandoc.List()  -- {content = Inlines, id = string}

local options_bullets = "bullet"
local options_heading = nil
local options_clickable = false

local function read_meta(meta)
  local options = meta["auto-agenda"]
  if options == nil then return end
  if options.bullets ~= nil then
    options_bullets = stringify(options.bullets)
  end
  if options.heading ~= nil then
    options_heading = options.heading
  end
  options_clickable = options.clickable == true
end

local bullet_classes = {
  none     = function(x) return x end,
  numbered = pandoc.OrderedList,
  bullet   = pandoc.BulletList,
}

local function scan_headers(el)
  if el.level == 1 then
    sections:insert({content = el.content, id = el.identifier or ""})
  end
end

local function scan_blocks(blocks)
  local new = pandoc.List()
  local header_n = 0
  local bullet_class = bullet_classes[options_bullets] or pandoc.BulletList

  for _, block in ipairs(blocks) do
    if block.t == "Header"
      and block.level == 1
      and not block.attr.classes:includes("no-auto-agenda")
    then
      header_n = header_n + 1
      block.attr.classes = {"agenda-slide"}
      new:insert(block)

      if options_heading ~= nil then
        new:insert(pandoc.Div(
          pandoc.Para(options_heading),
          pandoc.Attr("", {"agenda-heading"})
        ))
      end

      local items = pandoc.List()
      for i = 1, #sections do
        local cls = i == header_n and {"agenda-active"} or {"agenda-inactive"}
        local el
        if options_clickable then
          table.insert(cls, "agenda-clickable")
          el = pandoc.Link(sections[i].content, "#" .. sections[i].id)
        else
          el = pandoc.Para(sections[i].content)
        end
        items:insert(pandoc.Div(el, pandoc.Attr("", cls)))
      end

      new:insert(pandoc.Div(
        bullet_class(items),
        pandoc.Attr("", {"agenda"})
      ))
    else
      new:insert(block)
    end
  end

  return new
end

if quarto.doc.isFormat("revealjs") then
  return {
    {Meta = read_meta},
    {Header = scan_headers},
    {Blocks = scan_blocks}
  }
end
