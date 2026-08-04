# FreeW Avalonia Side-to-Side horizontal page grid

Wave 153 closes the documented Avalonia gap in the live Side-to-Side editor surface.

The existing Avalonia paginator remains the authority for page breaks, sections, footnotes,
endnotes, headers, footers, tables, floating objects, and caret positions. After that pass is
complete, the editor projects each page-owned record into a horizontal page strip. The projection
carries the complete page geometry: text glyphs and sentinels, table and paragraph surfaces,
inline and floating drawings (including nested groups), comments and revision decorations, line
number inputs, headers/footers, note bands, drop caps, selection surfaces, and shape-text caret
stops. Page backgrounds, borders, watermarks, gridlines, and margin annotations use the same page
origins.

The live surface now reports a horizontal content extent, routes hit testing by page origin, and
scrolls horizontally when a caret moves onto a later page. Pair navigation advances by two full
page strides, including both inter-page gaps. PDF export deliberately creates a normal print-layout
adapter because Side-to-Side is a screen projection rather than a PDF coordinate system.

Focused evidence:

- `ViewTabDepthTests.Side_to_side_projects_later_pages_horizontally_and_routes_hit_and_caret_geometry`
  proves page-2-or-later caret geometry, horizontal extent, and pointer routing.
- `ViewTabDepthTests.MainWindow_side_to_side_navigation_steps_page_pairs` proves pair navigation and
  horizontal offset movement.
- `PagedEditParityTests` continues to prove that the live editor remains the editable page surface.

The focused Avalonia lane passed `33/33` after the slice. Visual pixel calibration of the Linux
surface remains a separate follow-up from this functional page-flow closure.
