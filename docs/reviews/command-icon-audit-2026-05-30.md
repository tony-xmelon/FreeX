# FreeX Command Icon Audit

**Date:** 2026-05-30
**Branch:** `codex/icon-audit-20260530`
**Status:** Reviewable proposal only. No icon or UI implementation changes are included in this branch.

## Scope

This audit covers command icons and command-like icon controls in:

- title bar and quick access commands
- ribbon tabs, contextual PivotTable tabs, ribbon dropdown menus, and collapsed ribbon menus
- backstage navigation, recent/pinned file controls, and backstage context menus
- worksheet, sheet tab, PivotTable field, AutoFilter, and Quick Analysis context menus
- formula bar, sheet tab navigation, horizontal/zoom/status controls
- dialog action clusters where icons would be meaningful
- the SVG command asset library in `src/FreeX.App.Host/Resources/CommandIconsSvg`

Primary source files reviewed:

- `src/FreeX.App.Host/MainWindow.xaml`
- `src/FreeX.App.Host/MainWindow.Ribbon.cs`
- `src/FreeX.App.Host/MainWindow.RibbonAdaptive.cs`
- `src/FreeX.App.Host/RibbonCommandPresentationPlanner*.cs`
- `src/FreeX.App.Host/RibbonIconFactory*.cs`
- `src/FreeX.App.Host/RibbonMenuIconSeeder.cs`
- `src/FreeX.App.Host/BorderMenuIcon.cs`
- `src/FreeX.App.Host/WorksheetContextMenuPlanner.cs`
- dialog files under `src/FreeX.App.Host/*Dialog*.cs` and `src/FreeX.App.Host/*Dialog*.xaml`

External references used for Excel and Microsoft style comparison:

- Microsoft Support, Excel ribbon/navigation documentation: <https://support.microsoft.com/office/use-a-screen-reader-to-explore-and-navigate-excel-cbf024e8-2abd-4764-b639-f24eed659a53>
- Microsoft Support, Excel command documentation for common Home/Data/Formulas/View/Page Layout workflows: <https://support.microsoft.com/excel>
- Microsoft Fluent iconography guidance: <https://learn.microsoft.com/windows/apps/design/signature-experiences/iconography>

## Review Legend

Use the empty columns in each table as the review control.

| Field | Meaning |
|---|---|
| Accept | Implement the recommendation as proposed. |
| Decline | Keep the current icon behavior. |
| Comment | Reviewer note, variant request, or exception. |

Priority:

- `P0`: consistency rule or source-of-truth fix that affects many commands
- `P1`: visible command is misleading, generic, or stylistically inconsistent
- `P2`: visible command is understandable but should be refined
- `P3`: keep as-is, with optional future cleanup

## Baseline Findings

### Size System

The current runtime size system is usable and should remain the baseline unless we deliberately redesign the ribbon height.

| Surface | Current observed sizes | Assessment | Action |
|---|---:|---|---|
| App icon | `.ico` application icon | Not audited as brand art in this pass. | Keep for now; run a separate brand icon review later. |
| Title/QAT | 16 px icons in compact buttons | Good. | Keep 16 px. |
| Window system buttons | 18 px glyphs | Good. | Keep 18 px. |
| Large ribbon commands | 32 px artwork in 34 px slot | Good Excel-like weight. | Keep 32 px. |
| Small/medium ribbon commands | 22 px artwork in 24 px slot | Good target, but needs more small-specific SVGs. | Keep 22 px. |
| Menu icons | 18 px | Good. | Keep 18 px. |
| Backstage navigation | 15 px white icons | Slightly small, but acceptable. | Keep 15 or move to 16 px consistently. |
| Recent pin buttons | 12 px | Too small compared with backstage rows. | Increase to 14-16 px if row height allows. |
| Formula/status/sheet controls | text glyphs, 18-22 px | Mostly appropriate for chrome controls. | Keep custom chrome glyphs; do not force SVG. |
| Dialog buttons | usually no icon | Correct for OK/Cancel-style modal actions. | Add icons only to toolbar-like action clusters. |

### SVG Asset Health

Inventory of `Resources/CommandIconsSvg`:

- 246 SVG files
- 237 base icon names
- 9 small-specific variants
- 0 large-specific variants
- viewBox mix:
  - 119 icons use `0 0 54 54`
  - 112 icons use `0 0 32 32`
  - 9 icons use `0 0 22 22`
  - 6 icons use `0 0 20 20`
- frequent baked colors:
  - `#242424`, `#202124`, `#FFFFFF`
  - `#0F6D8C`, `#0078D4`, `#E6F6FA`, `#DCECFF`
  - `#FFB900`, `#D32F2F`, `#F7630C`, `#8B5CF6`

Assessment:

- The library is broad, but artboards and stroke weights are mixed. This is visible when 54 px assets are scaled into 22 px ribbon slots.
- Only alignment icons have dedicated small variants. Dense formula, data, draw, and chart-detail icons need small variants first.
- Some command names have exact SVG assets, but backstage white icons bypass SVG loading and use fallback drawings because `CreateStaticRibbonCommandIcon` switches to fallback when the source brush is white.
- Many visible commands are good, but broad planner fallbacks still produce semantically vague icons for command families such as chart detail commands, PivotTable tools, Draw tools, and several backstage entries.

### Excel/Fluent Comparison

Excel generally uses:

- direct command metaphors, not generic "category" metaphors, for visible ribbon commands
- stable command families, e.g. clipboard, font, alignment, number, formula auditing, sort/filter, page setup, view/window
- compact icons with strong silhouettes at small sizes
- limited semantic color, with color used to clarify command type or data category rather than decorate every icon
- text-only modal OK/Cancel buttons, while icon treatment is reserved for ribbon, menu, pane, and toolbar commands

FreeX is closest to Excel where it has exact SVGs and weakest where it uses generic fallback icons, bare text glyphs, or white fallback drawings.

## Global Recommendations

| ID | Recommendation | Assessment | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| G1 | Keep the 16 / 18 / 22 / 32 px size system. | Balanced with the current ribbon density and Excel-like command proportions. | P3 | [ ] | [ ] |  |
| G2 | Make SVG assets the source of truth on all command surfaces, including white backstage/title icons. | Current white icon path ignores exact SVG assets for commands such as Open, Save As, Export, Home, and Options. | P0 | [ ] | [ ] |  |
| G3 | Normalize future SVG authoring to one canonical artboard plus explicit small variants. | Mixed 54/32/22/20 viewBoxes make stroke weight unpredictable at 22 px. | P1 | [ ] | [ ] |  |
| G4 | Add small-specific SVGs for dense 22 px commands beyond alignment. | Formula, chart, data, and draw icons lose clarity when scaled down. | P1 | [ ] | [ ] |  |
| G5 | Replace visible planner/generic fallbacks before decorative polish. | Wrong metaphor is a bigger problem than slight style mismatch. | P1 | [ ] | [ ] |  |
| G6 | Keep OK/Cancel/Apply dialog buttons text-only. | Matches Windows and Excel modal behavior. | P3 | [ ] | [ ] |  |
| G7 | Add icons to dialog toolbar/action clusters only. | Sort, Error Checking, Watch Window, Select Data Source, and Accessibility actions behave like command toolbars. | P2 | [ ] | [ ] |  |
| G8 | Add a generated icon contact sheet at 15, 16, 18, 22, and 32 px. | Makes future visual QA repeatable. | P2 | [ ] | [ ] |  |
| G9 | Add a source check that visible ribbon commands do not resolve to `Generic` unless allow-listed. | Prevents silent regressions as commands are added. | P2 | [ ] | [ ] |  |
| G10 | Reduce baked accent color where a command also receives an accent slot. | Double color treatment is heavier than Excel's current command style. | P2 | [ ] | [ ] |  |

## Command Decision Register

### Title Bar, Formula Bar, Sheet Tabs, Status Bar

| Surface | Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|---|
| Title/QAT | Save | `Save`, 16 px | Clear. | Keep; later use SVG source with white recolor. | P3 | [ ] | [ ] |  |
| Title/QAT | Undo | `Undo`, 16 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Title/QAT | Redo | `Redo`, 16 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Title bar | Minimize | `WindowMinimize`, 18 px | Clear and Windows-like. | Keep. | P3 | [ ] | [ ] |  |
| Title bar | Maximize/Restore | `WindowMaximize` / `WindowRestore`, 18 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Title bar | Close | `WindowClose`, 18 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Formula bar | Insert Function | `Function` / `insert-function.svg`, 18-22 px | Excel-like `fx` metaphor. | Keep. | P3 | [ ] | [ ] |  |
| Formula bar | Expand Formula Bar | text/chevron chrome glyph | Chrome control, not a command icon. | Keep as glyph; ensure hover/focus style matches green chrome. | P3 | [ ] | [ ] |  |
| Sheet tabs | Scroll Tabs Left | text `<`, 27 px hit height | Better as chrome glyph than SVG. | Keep. | P3 | [ ] | [ ] |  |
| Sheet tabs | Insert Sheet | text `+` in ghost tab | Correct tentative-tab metaphor. | Keep. | P3 | [ ] | [ ] |  |
| Sheet tabs | Scroll Tabs Right | text `>`, 27 px hit height | Better as chrome glyph than SVG. | Keep. | P3 | [ ] | [ ] |  |
| Status bar | Zoom Out | text `-`, green bar chrome | Clear. | Keep after alignment pass. | P3 | [ ] | [ ] |  |
| Status bar | Zoom In | text `+`, green bar chrome | Clear. | Keep after alignment pass. | P3 | [ ] | [ ] |  |

### Backstage And App Navigation

| Surface | Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|---|
| Backstage | Back | `Previous`, 18 px white fallback | Clear. | Keep, but source through SVG pipeline if possible. | P3 | [ ] | [ ] |  |
| Backstage | Home | `Grid`, 15 px white fallback | Looks like worksheet/grid, not file-home. | Use `home.svg` recolored white. | P1 | [ ] | [ ] |  |
| Backstage | Local Account | `Info`, 15 px white fallback | Acceptable but generic. | Use `account.svg` white. | P2 | [ ] | [ ] |  |
| Backstage | Options | `View`, 15 px white fallback | Semantically wrong. | Use `options.svg` white. | P1 | [ ] | [ ] |  |
| Backstage | New | `Insert`, 15 px white fallback | Acceptable but not workbook-specific. | Use `new.svg` white. | P2 | [ ] | [ ] |  |
| Backstage | Open | `GetData`, 15 px white fallback | Wrong; reads as data import. | Use `open.svg` white. | P1 | [ ] | [ ] |  |
| Backstage | Share | `Share`, 15 px white fallback | Clear. | Keep, prefer SVG recolor. | P3 | [ ] | [ ] |  |
| Backstage | Info | `Info`, 15 px white fallback | Clear. | Keep, prefer SVG recolor. | P3 | [ ] | [ ] |  |
| Backstage | Save | `Save`, 15 px white fallback | Clear. | Keep, prefer SVG recolor. | P3 | [ ] | [ ] |  |
| Backstage | Save As | `Save`, 15 px white fallback | Too similar to Save. | Use `save-as.svg` white. | P1 | [ ] | [ ] |  |
| Backstage | Print | `Print`, 15 px white fallback | Clear. | Keep, prefer SVG recolor. | P3 | [ ] | [ ] |  |
| Backstage | Export PDF/XPS | `Share`, 15 px white fallback | Wrong; export already has an asset. | Use `export.svg` white. | P1 | [ ] | [ ] |  |
| Backstage | Close | `WindowClose`, 15 px white fallback | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Backstage | Recent | `recent.svg` planner, 18/22 class | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Backstage | Pinned | no stable command icon | Missing visual cue. | Add `pin-to-list.svg` / `unpin-from-list.svg` in tab header or leave as text if it crowds. | P2 | [ ] | [ ] |  |
| Backstage | Pin File | `Pin`, 12 px | Too small. | Use `pin-to-list.svg`, 14-16 px. | P2 | [ ] | [ ] |  |
| Backstage | Unpin File | `Pin`, 12 px | Same as Pin, not distinct. | Use `unpin-from-list.svg`, 14-16 px. | P2 | [ ] | [ ] |  |
| Backstage context | Pin to list / Unpin from list / Remove from list | menu seeded 18 px where resolved | Good concept. | Keep; ensure exact pin/unpin/remove assets are used. | P3 | [ ] | [ ] |  |

### Home Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Paste | `paste.svg` / `Paste`, 32 px large, 18 px menu | Clear and Excel-like. | Keep. | P3 | [ ] | [ ] |  |
| Paste Values / Formulas / Formatting / Transpose / Paste Special | seeded 18 px menu icons | Menu icons are useful; some are fallback-based. | Keep menu icons; add exact paste-variant SVGs later. | P2 | [ ] | [ ] |  |
| Cut | explicit `Cut`, 10 px in legacy stack plus 18 px menu | 10 px is too small. | Migrate to shared 22 px small command content or raise legacy icon to 16 px. | P1 | [ ] | [ ] |  |
| Copy | explicit `Copy`, 10 px in legacy stack plus 18 px menu | 10 px is too small. | Same as Cut. | P1 | [ ] | [ ] |  |
| Format Painter | explicit `FormatPainter`, 11 px plus 18 px menu | Too small in ribbon row. | Use shared 22 px small command content. | P1 | [ ] | [ ] |  |
| Font | combo box, no icon | Correct for Excel-like combo. | Keep text/combo only. | P3 | [ ] | [ ] |  |
| Font Size | combo box, no icon | Correct for Excel-like combo. | Keep text/combo only. | P3 | [ ] | [ ] |  |
| Increase Font Size | custom A/up glyph; SVG exists | Understandable but bypasses shared asset style. | Use `increase-font-size.svg` or `grow-font.svg` in shared icon slot. | P2 | [ ] | [ ] |  |
| Decrease Font Size | custom A/down glyph; SVG exists | Same issue. | Use `decrease-font-size.svg` or `shrink-font.svg`. | P2 | [ ] | [ ] |  |
| Bold | custom typographic B | Excel-like and clear. | Keep typographic command; align baseline with Italic/Underline. | P3 | [ ] | [ ] |  |
| Italic | custom typographic I | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Underline | custom U plus line | Clear. | Keep; verify baseline. | P3 | [ ] | [ ] |  |
| Strikethrough | custom S strike | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Borders | `BorderMenuIcon` custom menu set, 18 px menu | Strong and command-specific. | Keep; normalize color/stroke with SVG family later. | P3 | [ ] | [ ] |  |
| Border menu variants | All, Outside, Inside, None, Bottom, Top, Left, Right, Thick, Double, Draw, Erase, More | Good use of custom previews. | Keep all; do not replace with generic border icon. | P3 | [ ] | [ ] |  |
| Fill Color | `fill-color.svg`, 22 px | Good metaphor; yellow accent can feel heavy. | Keep but check accent containment at 22 px. | P2 | [ ] | [ ] |  |
| Font Color | `font-color.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Top/Middle/Bottom Align | small-specific alignment SVGs, 22 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Orientation | `orientation.svg`, 22 px and menu icons | Correct for text orientation. | Keep. | P3 | [ ] | [ ] |  |
| Wrap Text | `wrap-text.svg` / explicit `Wrap`, 16-22 px | Clear. | Prefer shared SVG path; keep metaphor. | P3 | [ ] | [ ] |  |
| Align Left / Center / Align Right | small-specific SVGs, 22 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Decrease / Increase Indent | small-specific SVGs, 22 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Merge & Center | `merge-center.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Number Format | combo/dropdown, no icon | Acceptable because Excel uses format selector text. | Keep text/combo. | P3 | [ ] | [ ] |  |
| Accounting Number Format | `accounting-currency.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Percent Style | `percent-style.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Comma Style | `comma-style.svg`, 22 px | Slightly light at small size. | Add small variant or increase stroke. | P2 | [ ] | [ ] |  |
| Increase / Decrease Decimal | `increase-decimal.svg`, `decrease-decimal.svg`, 22 px | Dense but understandable. | Add small variants. | P2 | [ ] | [ ] |  |
| Conditional Formatting | `conditional-formatting.svg`, 32 px, menu seeded 18 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Conditional Formatting rule menu | Highlight Cells, Top/Bottom, Data Bars, Color Scales, Icon Sets, New/Clear/Manage Rules | Mixed seeded icons; disabled gallery headers correctly mostly iconless. | Keep icons for actionable items; keep section headers iconless. | P2 | [ ] | [ ] |  |
| Format as Table | `format-as-table.svg`/`Table`, 32 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Cell Styles | `cell-styles.svg` / Theme-like icon, 32 px | Acceptable. | Keep; do not over-icon each style swatch beyond menu seeding. | P3 | [ ] | [ ] |  |
| Insert | explicit `Insert`, 11 px legacy | Too small. | Use `insert.svg` at 22 px shared small command size. | P1 | [ ] | [ ] |  |
| Delete | explicit `Delete`, 11 px legacy | Too small. | Use `delete.svg` at 22 px shared small command size. | P1 | [ ] | [ ] |  |
| Format | explicit `FormatPainter`, 11 px legacy | Wrong metaphor for Format Cells/row/column options. | Use `format-cells.svg` or `format.svg`, 22 px. | P1 | [ ] | [ ] |  |
| AutoSum | `autosum.svg` / `Sum`, 32 px | Clear and Excel-like. | Keep. | P3 | [ ] | [ ] |  |
| AutoSum menu | Sum, Average, Count Numbers, Count All, Max, Min, More Functions | 18 px menu seeded, mostly good. | Keep; add exact count/count-all icons only if needed. | P3 | [ ] | [ ] |  |
| Fill | `fill.svg`, 18-22 px | Clear enough. | Keep; check yellow accent weight. | P2 | [ ] | [ ] |  |
| Clear | `clear.svg`, 18-22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Sort & Filter | `sort.svg`, 18-22 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Find & Select | `find.svg` / `Search`, 18-22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |

### Insert Ribbon And Chart Commands

| Command(s) | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| PivotTable | `pivottable.svg`, 22/32 px | Clear and Excel-like. | Keep. | P3 | [ ] | [ ] |  |
| Recommended PivotTables | planner fallback unless exact asset added | Visible command can look too generic. | Add `recommended-pivottables.svg` with table plus suggestion cue. | P1 | [ ] | [ ] |  |
| Table | `table.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Pictures | `picture.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Shapes, Rectangle, Ellipse, Line | `shapes.svg`, `rectangle.svg`, `ellipse.svg`, `line.svg`, 18/22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Get Add-ins, My Add-ins | exact SVGs exist, disabled state | Correct if exact SVGs render; otherwise fallback is misleading. | Ensure exact assets render in disabled state. | P2 | [ ] | [ ] |  |
| Recommended Charts | planner fallback risk | Visible command should be more specific. | Add `recommended-charts.svg`. | P1 | [ ] | [ ] |  |
| Column, Stacked Column, 100% Stacked Column, 3D Column | mostly chart fallback | Semantics are close but variants are indistinct. | Use one column icon plus stack/100/3D modifier where visible. | P2 | [ ] | [ ] |  |
| Bar, Stacked Bar, 100% Stacked Bar, 3D Bar | mostly chart fallback | Same as column family. | Add bar-family modifiers. | P2 | [ ] | [ ] |  |
| Line, 3D Line | `line-chart.svg` for base, fallback for 3D | Good base; 3D indistinct. | Keep Line; add 3D modifier if 3D remains visible. | P2 | [ ] | [ ] |  |
| Area, 3D Area | `area-chart.svg` for base, fallback for 3D | Good base. | Keep Area; add 3D modifier if visible. | P2 | [ ] | [ ] |  |
| Stock, Radar, Surface, Treemap, Sunburst, Histogram, Pareto, Box and Whisker, Waterfall, Funnel, Map | mostly fallback/generic chart | Supported chartEx families are now visible enough to deserve clearer metaphors; Map remains hidden/deferred. | Add family icons for visible supported chart types; hidden/deferred tooling can share chart fallback. | P2 | [ ] | [ ] |  |
| Pie, 3D Pie, Doughnut | pie/doughnut asset expected but variants may fall back | Base metaphor good. | Ensure `pie-doughnut-chart.svg` maps all three; add 3D modifier if visible. | P2 | [ ] | [ ] |  |
| Scatter, Bubble | scatter/bubble asset expected | Clear enough. | Keep, add bubble size cue if needed. | P3 | [ ] | [ ] |  |
| Change Chart Type, Select Data Source, Move Chart | chart fallback | Acceptable hidden/contextual, but generic. | Add exact assets if these remain visible in Insert. | P2 | [ ] | [ ] |  |
| Chart Styles, Format Chart Area | style/format fallback | Generic but acceptable as contextual tools. | Add chart-style and chart-format icons if visible. | P2 | [ ] | [ ] |  |
| Data Labels, Data Label Position, Category Name, Series Name, Percentage, Label Separator, Label Number Format, Data Callout, Data Label Fill/Text/Border/Size/Angle, Format Data Point Label | label/chart fallback | Too many detailed commands for unique icons unless visibly surfaced. | Use a small family: label base plus fill/text/border/size/angle modifiers. | P2 | [ ] | [ ] |  |
| Chart Titles, Chart Title Color/Size, Axis Title Color/Size | label/chart fallback | Same family issue. | Use title/label base with color/size modifiers. | P2 | [ ] | [ ] |  |
| Plot Area Fill/Border, Legend Text/Fill/Border/Font Size/Overlay | chart fallback | Too generic. | Use chart-region base plus fill/border/text modifiers. | P2 | [ ] | [ ] |  |
| Trendline, Trendline Type, Moving Average Period, Polynomial Order, Trendline Equation, R-squared, Trendline Color/Dash/Width | line-chart fallback | Excel metaphor is line/trend cue. | Use trendline base plus modifier set. | P2 | [ ] | [ ] |  |
| Error Bars, Secondary Axis, Axis Bounds, Log Scale, Number Format, Gridlines, Gridline Style, Ticks, Labels, Axis Line, Secondary Axis Series, Combo Chart, Combo Chart Series, Series Color/Width/Dash/Marker, Marker Size | chart fallback | Too detailed for unique top-level icons unless exposed. | Use one chart-axis/series modifier family; keep generic only for hidden commands. | P2 | [ ] | [ ] |  |
| 3D Map | chart/data fallback | Vague. | Use map/terrain icon or leave disabled/text-only if deferred. | P2 | [ ] | [ ] |  |
| Sparklines: Line, Column, Win/Loss | `sparklines.svg`/chart family | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Insert Slicer, Insert Timeline | filter/date fallback | Acceptable but not exact Excel metaphors. | Add slicer and timeline icons. | P2 | [ ] | [ ] |  |
| Link | `hyperlink.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Comment | `comment-note.svg`, 22/32 px | Clear. | Keep; ensure label fits. | P2 | [ ] | [ ] |  |
| Text Box, Header & Footer, Object, Equation, Symbol | exact or close assets, 22/32 px | Mostly clear. | Keep, but use `header-footer.svg` for Header & Footer if not already resolving. | P2 | [ ] | [ ] |  |

### Draw Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Draw with Touch | `draw-with-touch.svg`, 22/32 px | Good if rendered exact; fallback line would be weak. | Keep exact SVG. | P3 | [ ] | [ ] |  |
| Eraser | clear/fallback | Understandable but not draw-specific. | Add `eraser.svg` or exact alias. | P2 | [ ] | [ ] |  |
| Lasso Select | `lasso-select.svg` | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Pen | `pen.svg` | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Pencil | `pencil.svg` | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Highlighter | `highlighter.svg` | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Add Pen | `add-pen.svg` | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Ink to Shape | shapes/math fallback risk | Needs conversion metaphor. | Add ink-stroke-to-shape icon or exact alias. | P2 | [ ] | [ ] |  |
| Ink to Math | math icon | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Bring Forward / Send Backward / Selection Pane | exact assets available | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Rotate Object / Object Size | rotate/size assets | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Shape Fill / Object Outline | fill/outline assets | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Crop Picture / Reset Crop | `crop.svg` expected | Clear when exact. | Keep exact asset; use reset-crop variant only if exposed often. | P3 | [ ] | [ ] |  |
| Shape Gradient / Shape Effects | fallback/generic risk | Not specific enough. | Add `gradient.svg` and stronger `effects.svg` mapping. | P1 | [ ] | [ ] |  |

### Page Layout Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Themes | `themes.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Theme Colors | `theme-colors.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Theme Fonts | `fonts.svg` should be used | Needs to be distinct from effects/colors. | Ensure exact `fonts.svg` maps. | P2 | [ ] | [ ] |  |
| Theme Effects | `effects.svg` should be used | Needs to be distinct from fonts/colors. | Ensure exact `effects.svg` maps. | P2 | [ ] | [ ] |  |
| Margins | `margins.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Orientation | `page-orientation.svg` should be used | If fallback uses text orientation, it is wrong for page layout. | Force exact `page-orientation.svg`. | P1 | [ ] | [ ] |  |
| Size | `paper-size.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Print Area | `print-area.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Breaks | `breaks.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Background | `background.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Print Titles | `print-titles.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Scale to Fit | `scale-to-fit.svg`, 22/32 px | Adequate. | Keep; verify at 22 px. | P3 | [ ] | [ ] |  |
| View/Print Gridlines, View/Print Headings | checkbox commands, no strong icon need | Excel also treats these as checkbox-style controls. | Keep current compact checkbox treatment. | P3 | [ ] | [ ] |  |
| Arrange: Bring Forward, Send Backward, Selection Pane, Rotate Object, Object Size | shared draw/arrange assets | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Page Layout dropdown menus | Office, Colorful, Grayscale, Customize, margins, orientation, size, print area, breaks, background | 18 px menu seeded where useful; many textual choices should stay text-only. | Add icons only for action commands, not every preset. | P3 | [ ] | [ ] |  |

### Formulas Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Insert Function | `insert-function.svg`, 22/32 px | Strong and Excel-like. | Keep. | P3 | [ ] | [ ] |  |
| AutoSum | `autosum.svg`, 22/32 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Recently Used | `recent.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Financial | `financial.svg`, 22 px | Good but dense. | Add small variant if needed. | P2 | [ ] | [ ] |  |
| Logical | `logical.svg`, 22 px | Needs clarity check at 22 px. | Add small variant with TRUE/FALSE cue if current asset is weak. | P2 | [ ] | [ ] |  |
| Text | `text.svg`, 22 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Date & Time | `date-time.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Lookup & Reference | `lookup-reference.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Math & Trig | `math-trig.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| More Functions | `more-functions.svg`, 22 px | Clear if exact. | Keep; add small variant if cramped. | P2 | [ ] | [ ] |  |
| Name Manager | `name-manager.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Define Name | `define-name.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Use in Formula | `use-in-formula.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Create from Selection | `create-from-selection.svg`, 22 px | Clear enough. | Keep; verify at small size. | P3 | [ ] | [ ] |  |
| Trace Precedents | `trace-precedents.svg`, 22 px | Right metaphor. | Keep; ensure direction is obvious. | P2 | [ ] | [ ] |  |
| Trace Dependents | `trace-dependents.svg`, 22 px | Right metaphor. | Keep; ensure it differs from precedents. | P2 | [ ] | [ ] |  |
| Remove Arrows | `remove-arrows.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Show Formulas | `show-formulas.svg`, 22 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Error Checking | `error-checking.svg`, 22 px | Strong. | Keep. | P3 | [ ] | [ ] |  |
| Error Checking Options | menu seeded | Gear/options not obvious if fallback. | Use `options.svg` or error-options variant. | P2 | [ ] | [ ] |  |
| Evaluate Formula | `evaluate-formula.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Watch Window | `watch-window.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Add Watch | fallback risk | Needs specific plus/watch metaphor. | Add watch plus icon. | P2 | [ ] | [ ] |  |
| Delete Watch | fallback risk | Needs specific delete/watch metaphor. | Add watch delete icon. | P2 | [ ] | [ ] |  |
| Calculate Now | `calculate-now.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Calculate Sheet | `calculate-sheet.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Calculation Options | `calculation-options.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |

### Data Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Get Data | `get-data.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Refresh All | `refresh-all.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Queries & Connections | `queries-connections.svg` expected | Clear if exact; generic cylinder if not. | Ensure exact asset maps. | P2 | [ ] | [ ] |  |
| Stocks | `stocks.svg`, 22 px | Clear if exact. | Keep. | P3 | [ ] | [ ] |  |
| Geography | `geography.svg`, 22 px | Clear if exact. | Keep. | P3 | [ ] | [ ] |  |
| Sort A to Z | `sort-ascending.svg`, 16/22 px | Clear. | Keep; use exact in both ribbon and menus. | P3 | [ ] | [ ] |  |
| Sort Z to A | `sort-descending.svg`, 16/22 px | Clear. | Keep; use exact in both ribbon and menus. | P3 | [ ] | [ ] |  |
| Filter | `filter.svg`, 16/22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Clear Filter / Clear | `clear-filter.svg` or `clear.svg`, 16/22 px | Clear if exact. | Prefer `clear-filter.svg` when action is filter-specific. | P2 | [ ] | [ ] |  |
| Advanced | `advanced-filter.svg`, 16/22 px | Clear if exact. | Keep exact asset. | P3 | [ ] | [ ] |  |
| Reapply | filter fallback | Not distinct enough. | Add reapply-filter icon or use refresh plus funnel. | P2 | [ ] | [ ] |  |
| Text to Columns | `text-to-columns.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Flash Fill | `flash-fill.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Remove Duplicates | `remove-duplicates.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Data Validation | `data-validation.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Consolidate | `consolidate.svg`, 22/32 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| What-If Analysis | target fallback | Too generic for Excel parity. | Add what-if/simulation icon or use submenu icons for Goal Seek/Scenario/Data Table. | P1 | [ ] | [ ] |  |
| Goal Seek / Scenario Manager / Data Table | menu seeded fallback | Needs distinct submenu metaphors. | Use `goal-seek.svg`, `scenario-manager.svg`, `data-table.svg`. | P1 | [ ] | [ ] |  |
| Forecast Sheet | `forecast-sheet.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Group | `group.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Ungroup | `ungroup.svg`, 22 px | Clear but uses strong red. | Keep; consider lighter red to match icon palette. | P2 | [ ] | [ ] |  |
| Subtotal | `subtotal.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Collapse Group / Expand Group | fallback risk | Needs plus/minus outline cue. | Use `hide-detail.svg` and `show-detail.svg` or exact aliases. | P2 | [ ] | [ ] |  |

### Review Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Spelling | `spell-check.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Workbook Statistics | `statistics.svg` alias expected | Clear if exact. | Ensure alias maps. | P2 | [ ] | [ ] |  |
| Check Accessibility | `accessibility-checker.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Alt Text | `alt-text.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| New Comment | `comment-note.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| New Note / Edit Note / Delete Note / Previous Note / Next Note / Show Notes | note/comment, delete, prev/next assets | Mostly clear. | Keep; add exact note variants only if screenshots show ambiguity. | P2 | [ ] | [ ] |  |
| Protect Sheet | `protect-sheet.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Protect Workbook | `protect-workbook.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Allow Users to Edit Ranges | `allow-edit-ranges.svg`, 22/32 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Share Workbook | share icon | Clear. | Keep. | P3 | [ ] | [ ] |  |

### View Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Normal | `normal.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Page Break Preview | `page-break-preview.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Page Layout | `page-layout.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Custom Views | `custom-views.svg`, 22/32 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Gridlines / Headings / Ruler / Formula Bar | checkbox-style view toggles | Excel-like as toggles. | Keep; icons optional only in collapsed group menus. | P3 | [ ] | [ ] |  |
| Zoom | `zoom.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| 100% | `zoom-to-100.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Zoom to Selection | `zoom-to-selection.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| New Window | `new-window.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Arrange All | `arrange-all.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Freeze Panes | `freeze-panes.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Split | `split.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Hide / Unhide | `hide-unhide.svg`, `hide-sheet.svg`, `unhide-sheet.svg` aliases | Clear if exact. | Ensure exact hide/unhide assets in menus. | P2 | [ ] | [ ] |  |
| View Side by Side | `view-side-by-side.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Synchronous Scrolling | `synchronous-scrolling.svg`, 22 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Reset Window Position | `reset-window-position.svg`, 22 px | Clear enough. | Keep. | P3 | [ ] | [ ] |  |
| Switch Windows | `switch-windows.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Macros | `macros.svg`, 22/32 px | Clear. | Keep. | P3 | [ ] | [ ] |  |

### PivotTable Contextual Tabs

| Command(s) | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| PivotTable Name, PivotTable Options | label/options fallback | Usable, but not specific. | Use PivotTable base plus name/options modifiers. | P2 | [ ] | [ ] |  |
| Show Details, Field Settings | show-detail/list fallback | Clear enough. | Keep if exact assets resolve. | P3 | [ ] | [ ] |  |
| Group Field, Ungroup | group/ungroup assets | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Insert Slicer, Insert Timeline | filter/date fallback | Same as Insert tab. | Add slicer/timeline icons. | P2 | [ ] | [ ] |  |
| Refresh, Change Data Source | refresh/get-data assets | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Clear, Select, Move PivotTable | clear/search/table fallback | Clear enough but generic. | Add exact select/move PivotTable icons if visible often. | P2 | [ ] | [ ] |  |
| Calculated Field, Calculated Item | function/list fallback | Needs formula/Pivot distinction. | Use PivotTable plus `fx` icon. | P2 | [ ] | [ ] |  |
| PivotChart, Change Chart Type, PivotChart Options | chart fallback | Good enough. | Keep or add PivotChart-specific base later. | P3 | [ ] | [ ] |  |
| Field List | list icon | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Grand Totals, Subtotals, Report Layout, Blank Rows | layout/subtotal/page fallback | Acceptable but generic. | Use PivotTable layout modifier set. | P2 | [ ] | [ ] |  |
| Banded Rows, Banded Columns, Row Headers, Column Headers | table fallback | Clear enough. | Keep; exact table-style variants optional. | P3 | [ ] | [ ] |  |
| PivotTable Styles | theme/table style | Clear. | Keep. | P3 | [ ] | [ ] |  |

### Help Ribbon

| Command | Current icon and sizes | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|
| Help Online | `help.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Feedback | `send-feedback.svg` expected | Clear if exact; fallback comment icon is acceptable. | Ensure exact asset maps. | P2 | [ ] | [ ] |  |
| Copy Diagnostics | info/copy fallback risk | Needs diagnostic/log cue. | Add `copy-diagnostics.svg` or use copy plus info. | P2 | [ ] | [ ] |  |
| Check for Updates | `check-for-updates.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| About FreeX | `about.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Contact Support | `contact-support.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |
| Show Training | book/help fallback | Clear enough. | Use book/training icon if implemented. | P3 | [ ] | [ ] |  |
| What's New | `what-s-new.svg`, 22 px | Clear. | Keep. | P3 | [ ] | [ ] |  |

### Context Menus

| Surface | Commands | Current icon behavior | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|---|
| Ribbon dropdown menus | Paste variants, borders, orientation, conditional formatting, cell styles, cells, fill/clear/sort/find, chart menus, page layout menus, formulas menus, data menus, view menus | `RibbonMenuIconSeeder` seeds 18 px icons, and border menu uses `BorderMenuIcon`. | Good system. Some fallback mappings are too generic. | Keep 18 px menu icons; add allow-list so section headers remain iconless and visible actions avoid Generic. | P2 | [ ] | [ ] |  |
| Worksheet context menu | Cut, Copy, Paste, Paste Special, Insert, Delete, Sort, Filter, Quick Analysis, Define Name, tables, data tools, comments/notes, Format Cells, Clear commands, hyperlinks | auto seeded 18 px icons by menu header | Good Excel-like direction; several actions need exact icons. | Add exact/alias icons for Quick Analysis, Insert Copied Cells, Pick From Drop-down List, Reapply Filter, Resolve/Unresolve Comment, Row/Column sizing. | P1 | [ ] | [ ] |  |
| Row/column selection menus | Cut, Copy, Paste, Insert/Delete row/column, Group/Ungroup, Format Cells, Clear Contents | auto seeded 18 px | Good. | Keep; add row/column-specific insert/delete assets if menus feel generic. | P2 | [ ] | [ ] |  |
| Drawing/object context menus | Format Picture/Object, Crop, Reset Crop, Size and Properties, Rotate, Shape Fill/Outline, Alt Text, Selection Pane, Bring Forward, Send Backward | auto seeded 18 px | Mostly good, but generic for object-specific commands. | Add shape/object variants for format, size, rotate, fill, outline. | P2 | [ ] | [ ] |  |
| Sheet tab context menu | Rename, Insert Sheet, Duplicate, Delete Sheet, Hide, Unhide, Tab Color, Select All Sheets, Ungroup Sheets, Move Left, Move Right | auto seeded 18 px where resolved | Good and Excel-like. | Ensure exact `tab-color.svg`, `select-all-sheets.svg`, `ungroup-sheets.svg`, `move-left.svg`, `move-right.svg` are used. | P2 | [ ] | [ ] |  |
| Pivot field context menus | Sort A to Z, Sort Z to A, Select Items, Label Filter, Value Filter, Clear Filter, Value Field Settings | auto seeded 18 px | Good core set, but Select/Value settings are generic. | Add field-specific select/settings icons if menu is frequent. | P2 | [ ] | [ ] |  |
| AutoFilter menus | Sort, clear filter, text/number/date filters, select all, clear all, color choices | mostly text buttons and submenus | Excel-like; not every button needs an icon. | Add icons only to Sort/Clear/Filter-family buttons; keep color swatches as visual control. | P2 | [ ] | [ ] |  |
| Quick Analysis menu | preview icons from `QuickAnalysisPreviewIconFactory` | Good because previews describe the action better than generic icons. | Keep. | P3 | [ ] | [ ] |  |

### Dialogs

Dialog OK/Cancel/Apply buttons should generally remain text-only. The following dialog action clusters should be audited for optional icons because they behave like command toolbars or side actions.

| Dialog or cluster | Commands | Current icon behavior | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|---|---|
| Sort dialog | Add Level, Delete Level, Copy Level, Move Up, Move Down, Options | text buttons | Toolbar-like cluster; icons would improve scanability. | Add 16 px plus/delete/copy/up/down/options icons beside text. | P2 | [ ] | [ ] |  |
| Error Checking dialog | Help on this error, Show Calculation Steps, Ignore Error, Edit Formula, Go To, Previous, Next, Trace Error | text buttons | Side action stack is command-heavy. | Add 16 px help, trace, ignore, edit, go-to, previous/next icons. | P2 | [ ] | [ ] |  |
| Watch Window / Add Watch | Add Watch, Delete Watch, Go To, Close | mostly text | Command-like window. | Add watch plus/delete/go-to icons. | P2 | [ ] | [ ] |  |
| Select Data Source dialog | Add/Edit/Remove series, Move Up/Down, switch rows/columns | text buttons | Toolbar-like and Excel-like candidate. | Add series plus/edit/delete/up/down/switch icons. | P2 | [ ] | [ ] |  |
| Accessibility Checker | Go To, Close | text buttons | Go To is command-like. | Add small go-to icon to Go To; keep Close text-only. | P3 | [ ] | [ ] |  |
| Allow Edit Range dialog | Delete, Clear All, range picker | text buttons | Delete/Clear are command-like. | Add delete/clear/range-picker icons if visual density allows. | P3 | [ ] | [ ] |  |
| Spell Check dialog | Ignore Once, Ignore All, Change, Change All, Add to Dictionary, Cancel | text buttons | Excel keeps many spelling actions text-first. | Keep text-only unless dialog gets a toolbar treatment. | P3 | [ ] | [ ] |  |
| AutoFilter dialog | Clear Filter, Text/Number/Date Filters, Select All, Clear All, OK/Cancel | mostly text | Functional and Excel-like. | Add only sort/filter/clear icons if a broader dialog icon pass happens. | P3 | [ ] | [ ] |  |
| Format Cells dialog | font/fill/border color pickers, border preset buttons | swatches and previews | Swatches/previews are better than icons. | Keep visual controls; do not add generic icons. | P3 | [ ] | [ ] |  |
| Page Setup / Header Footer dialogs | range pickers, picture format, print options | text/buttons | Icons only useful for range picker and picture format. | Keep modal actions text-only; add 16 px picker icons consistently if missing. | P3 | [ ] | [ ] |  |
| Print Preview | print/navigation/settings controls | command toolbar behavior | Icons expected. | Audit separately with rendered print preview screenshot. | P2 | [ ] | [ ] |  |
| Color/theme/palette dialogs | color swatches, customize actions | swatches | Swatches carry meaning. | Keep icons minimal. | P3 | [ ] | [ ] |  |
| Chart formatting dialogs | color pickers, axis/series options | text + swatches | Icons are optional; chart preview matters more. | Add icons only to repeated picker/preview commands. | P3 | [ ] | [ ] |  |
| Data Validation, Text to Columns, Pivot dialogs, Scenario, Consolidate, Remove Duplicates, Subtotal | OK/Cancel plus field actions | text-first dialogs | Text-only matches Excel modal style. | Keep; add picker icons where a range-selector button appears. | P3 | [ ] | [ ] |  |

## Implementation Order Proposal

| Step | Work | Rationale | Accept | Decline | Comment |
|---|---|---|---|---|---|
| 1 | Fix SVG recolor/use path for white backstage/title icons. | High leverage, low visible risk, immediately corrects semantic mismatches. | [ ] | [ ] |  |
| 2 | Replace the legacy 10/11 px Home icons with shared 22 px command content. | Visible polish, biggest size inconsistency. | [ ] | [ ] |  |
| 3 | Add exact aliases/assets for high-priority visible fallbacks. | Makes ribbon more Excel-like without redesigning layout. | [ ] | [ ] |  |
| 4 | Add small variants for dense 22 px icons. | Improves readability at normal and scaled DPI. | [ ] | [ ] |  |
| 5 | Add context-menu Generic fallback checks and allow-list. | Prevents noisy or wrong menu icons. | [ ] | [ ] |  |
| 6 | Add optional dialog action-cluster icons. | Lower risk after the main command language is stable. | [ ] | [ ] |  |
| 7 | Generate visual contact sheets and screenshot verification fixtures. | Gives a repeatable acceptance workflow. | [ ] | [ ] |  |

## Initial High-Priority Asset/Alias List

These are the first icons I would add or remap if the audit is accepted:

| Asset or alias | Why | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|
| `home.svg` in backstage white path | Home currently reads as grid. | P1 | [ ] | [ ] |  |
| `options.svg` in backstage white path | Options currently reads as View. | P1 | [ ] | [ ] |  |
| `open.svg` in backstage white path | Open currently reads as Get Data. | P1 | [ ] | [ ] |  |
| `save-as.svg` in backstage white path | Save As currently duplicates Save. | P1 | [ ] | [ ] |  |
| `export.svg` in backstage white path | Export currently reads as Share. | P1 | [ ] | [ ] |  |
| `recommended-pivottables.svg` | Visible Insert command. | P1 | [ ] | [ ] |  |
| `recommended-charts.svg` | Visible Insert command. | P1 | [ ] | [ ] |  |
| `what-if-analysis.svg` | Visible Data command. | P1 | [ ] | [ ] |  |
| `reapply-filter.svg` | Visible Data/menu command. | P2 | [ ] | [ ] |  |
| `collapse-group.svg` / `expand-group.svg` aliases | Visible Data outline commands. | P2 | [ ] | [ ] |  |
| `watch-add.svg` / `watch-delete.svg` | Visible Formulas commands. | P2 | [ ] | [ ] |  |
| `copy-diagnostics.svg` | Visible Help command. | P2 | [ ] | [ ] |  |
| `quick-analysis.svg` | Worksheet context menu. | P2 | [ ] | [ ] |  |
| `insert-copied-cells.svg` | Worksheet context menu. | P2 | [ ] | [ ] |  |
| `pick-from-dropdown.svg` | Worksheet context menu. | P2 | [ ] | [ ] |  |
| `resolve-comment.svg` / `unresolve-comment.svg` | Worksheet context menu. | P2 | [ ] | [ ] |  |

## Open Questions

| Question | Recommendation | Accept | Decline | Comment |
|---|---|---|---|---|
| Should disabled/deferred commands show full icons at reduced opacity? | Yes. Keep the same icon geometry at 38-45% opacity. | [ ] | [ ] |  |
| Should every menu item receive an icon? | No. Action items yes, section headers and purely textual presets no. | [ ] | [ ] |  |
| Should chart-detail commands each receive unique icons? | Only if visible in normal ribbon states; otherwise use a small modifier family. | [ ] | [ ] |  |
| Should modal OK/Cancel buttons have icons? | No. Text-only is clearer and closer to Windows/Excel conventions. | [ ] | [ ] |  |
| Should the app icon/brand mark be redesigned in this pass? | No. Treat app branding separately from command iconography. | [ ] | [ ] |  |
