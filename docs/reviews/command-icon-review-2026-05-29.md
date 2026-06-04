# FreeX Command Icon Review

**Date:** 2026-05-29  
**Status:** Proposal for design review, no implementation applied  
**Scope:** Title bar/QAT, ribbon commands, formula bar, sheet tabs, status bar, backstage, and command menus where icon metadata is present.

## Evidence Used

- Current XAML and runtime normalization rules in `MainWindow.xaml`, `MainWindow.Ribbon.cs`, `RibbonIconFactory*`, `RibbonCommandPresentationPlanner*`, `RibbonMenuIconSeeder.cs`, and `BorderMenuIcon.cs`.
- Fresh screenshot tour generated with `FREEX_SS_TOUR=1`.
- Contact sheets:
  - `screenshots/icon-audit/ribbon-max-contact.png`
  - `screenshots/icon-audit/ribbon-1100-contact.png`
  - `screenshots/icon-audit/ribbon-900-contact.png`
  - `screenshots/icon-audit/ribbon-750-contact.png`
- Structured inventory from `local:RibbonTooltip.Title` found 363 command titles:
  - Title/QAT: 3
  - Ribbon: 332
  - Formula bar: 2
  - Panes: 2
  - Sheet tabs: 3
  - Status bar: 2
  - Backstage/overlay: 19
- SVG asset inventory: 228 command SVG files, but only 9 small-specific variants. About 193 ribbon command titles currently resolve to fallback or generic art; many of these are hidden/contextual chart or PivotTable commands, but several visible commands are affected.

## Current Size System

The current runtime system is internally consistent enough to keep as the baseline.

| Surface | Current size | Review |
|---|---:|---|
| Title/QAT | 16 px icon in 26x22 button | Good. Readable and aligned with the title bar. |
| Window system buttons | 18 px icon in wide caption hit target | Good after the green-hover pass. |
| Large ribbon commands | 32 px artwork in 34 px slot, 76 px button height | Good. The older 40 px proposal would require a taller ribbon and is not recommended for this pass. |
| Medium/small ribbon commands | 22 px artwork in 24 px slot | Good. Needs more dedicated small SVGs for dense icons. |
| Home icon-only commands | 22 px artwork in 24 px visual cell | Good, but typographic icons need baseline audit. |
| Menu icons | 18 px | Good. Border menu icons are clear at 18 px. |
| Formula/sheet/status small controls | 18-22 px text/custom glyphs | Mostly good after the zoom alignment fix. |

**Decision proposal:** keep the 16 / 18 / 22 / 32 px size system and update older design docs to match it, unless we intentionally redesign the ribbon height.

## Global Proposals

| ID | Proposal | Reason | Priority | Decision |
|---|---|---|---|---|
| G1 | Keep large ribbon artwork at 32 px and small artwork at 22 px. | The rendered screenshots look balanced; 40 px large icons would make the ribbon heavier. | P1 |  |
| G2 | Add small-specific SVG variants for dense icons rendered at 22 px, not only alignment icons. | Current base SVGs often scale down acceptably, but text-heavy icons become fuzzy or crowded. | P1 |  |
| G3 | Replace visible fallback/generic mappings with dedicated assets before doing decorative polish. | The biggest readability problems are wrong semantics, not raw size. | P1 |  |
| G4 | Standardize disabled command treatment: same icon geometry at 38-45% opacity, never blank strips. | Help and add-in disabled commands currently show either overly strong fallback art or nearly blank icon columns. | P1 |  |
| G5 | Add a generated icon review sheet for 16, 18, 22, and 32 px render sizes. | This gives repeatable visual QA for future icon work. | P2 |  |
| G6 | Add a source test that visible ribbon commands do not resolve to `Generic` unless explicitly allow-listed. | Prevents later commands from silently falling back to generic art. | P2 |  |

## Command-by-Command Improvement Proposals

### Title, QAT, Status, Sheet Tabs

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Save | 16 px white line icon, good. | Keep. Optional future step: use the same SVG source as ribbon Save with white recolor. | P3 |  |
| Undo | 16 px white line icon, good. | Keep. | P3 |  |
| Redo | 16 px white line icon, good. | Keep. | P3 |  |
| Minimize / Maximize / Restore / Close | 18 px white system icons, good. | Keep. | P3 |  |
| Scroll Tabs Left | Text `<` glyph in 27 px hit area. | Keep current simple glyph; optional future SVG only if sheet-tab buttons get icon assets. | P3 |  |
| Insert Sheet | Text `+` in custom tab shape. | Keep current custom shape; do not replace with asset icon. | P3 |  |
| Scroll Tabs Right | Text `>` glyph in 27 px hit area. | Keep current simple glyph. | P3 |  |
| Zoom Out | 18 px text glyph aligned to slider rail. | Keep after current alignment fix. | P3 |  |
| Zoom In | 18 px text glyph aligned to slider rail. | Keep after current alignment fix. | P3 |  |

### Home

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Paste | 32 px clipboard, readable. | Keep. | P3 |  |
| Cut | 22 px scissors, readable. | Keep. | P3 |  |
| Copy | 22 px pages, readable. | Keep. | P3 |  |
| Format Painter | 22 px brush, readable. | Keep. | P3 |  |
| Increase Font Size | 22 px SVG, adequate. | Keep, but add dedicated small variant if strokes blur at 125% scaling. | P3 |  |
| Decrease Font Size | 22 px SVG, adequate. | Keep, same small-variant note as Increase Font Size. | P3 |  |
| Bold | Typographic 22 px style, readable. | Keep, but verify baseline with Italic/Underline after any font changes. | P3 |  |
| Italic | Typographic 22 px style, readable. | Keep. | P3 |  |
| Underline | Typographic 22 px style, readable. | Keep. | P3 |  |
| Strikethrough | Typographic 22 px style, readable. | Keep. | P3 |  |
| Borders | 22 px grid, readable. | Keep; border menu icons are clear at 18 px. | P3 |  |
| Fill Color | Good asset, but the yellow accent can read like a loose vertical strip. | Contain the accent fully inside the 24 px icon slot and verify at 22 px. | P2 |  |
| Font Color | Good asset. | Keep. | P3 |  |
| Top Align | Dedicated small asset, good. | Keep. | P3 |  |
| Middle Align | Dedicated small asset, good. | Keep. | P3 |  |
| Bottom Align | Dedicated small asset, good. | Keep. | P3 |  |
| Orientation | Text-orientation icon is appropriate in Home. | Keep. | P3 |  |
| Wrap Text | Good semantic icon. | Keep. | P3 |  |
| Align Left | Dedicated small asset, good. | Keep. | P3 |  |
| Center | Dedicated small asset, good. | Keep. | P3 |  |
| Align Right | Dedicated small asset, good. | Keep. | P3 |  |
| Decrease Indent | Dedicated small asset, good. | Keep. | P3 |  |
| Increase Indent | Dedicated small asset, good. | Keep. | P3 |  |
| Merge & Center | 22 px grid merge icon, readable. | Keep. | P3 |  |
| Accounting Number Format | Typographic `$`, readable but different from asset family. | Accept as Excel-like typographic command, or switch to `accounting-currency.svg` if we want all controls asset-backed. | P3 |  |
| Percent Style | Typographic `%`, readable. | Keep. | P3 |  |
| Comma Style | Typographic comma, readable but visually light. | Slightly increase stroke/weight or use `comma-style.svg` in the 24 px slot. | P2 |  |
| Increase Decimal Places | Dense `.0` style. | Use `increase-decimal.svg` small-specific asset; current tiny digits are marginal at compact widths. | P2 |  |
| Decrease Decimal Places | Dense `.0` style. | Use `decrease-decimal.svg` small-specific asset. | P2 |  |
| Conditional Formatting | 32 px colored grid, strong. | Keep. | P3 |  |
| Format as Table | 32 px table, strong. | Keep. | P3 |  |
| Cell Styles | 32 px star/table, readable. | Keep. | P3 |  |
| Insert | 22 px table/plus, readable. | Keep. | P3 |  |
| Delete | 22 px table/delete, readable. | Keep. | P3 |  |
| Format | 22 px format icon, readable. | Keep. | P3 |  |
| AutoSum | 32 px sigma, readable. | Keep. | P3 |  |
| Fill | Accent strip reads slightly detached. | Revise `fill.svg` to keep the yellow accent inside the slot. | P2 |  |
| Clear | Eraser is readable. | Keep. | P3 |  |
| Sort & Filter | Compact but understandable. | Keep, then revisit only if the Data sort icons are redesigned. | P3 |  |
| Find & Select | Magnifier is clear. | Keep. | P3 |  |

### Insert

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| PivotTable | 32 px green table, good. | Keep. | P3 |  |
| Recommended PivotTables | 32 px table, good. | Keep. | P3 |  |
| Table | 32 px table, good. | Keep. | P3 |  |
| Pictures | Black picture glyph, readable but visually plainer than adjacent green table commands. | Use `picture.svg` with the standard large slot treatment. | P2 |  |
| Shapes | Black shape glyph, readable. | Keep or add blue insert accent if Illustrations should match Tables/Charts. | P3 |  |
| Get Add-ins | Disabled; currently uses database/fallback-like visual, misleading. | Add `get-add-ins.svg` or alias to a puzzle/plug add-in icon; disabled at 40% opacity. | P1 |  |
| My Add-ins | Disabled; same database/fallback issue. | Add `my-add-ins.svg` or reuse add-in base with user/check overlay. | P1 |  |
| Recommended Charts / Charts | Blue chart slot, good. | Keep. | P3 |  |
| Tours | Black chart-like bars, vague. | Add `tours.svg` with a map/route or guided chart icon; keep 32 px if visible as a large command. | P2 |  |
| Sparklines | Small chart-in-cell is good. | Keep. | P3 |  |
| Filters | Funnel is clear. | Keep. | P3 |  |
| Links | Chain is clear. | Keep. | P3 |  |
| New Comment / Comments | Label truncates to `Comme...` at max-width screenshot. | Increase command width or label as `Comment`; keep comment bubble icon. | P1 |  |
| Text | Typographic T is readable. | Keep. | P3 |  |
| Symbols | Symbol icon is readable. | Keep. | P3 |  |
| Header & Footer | Hidden/less-visible insert command with fallback risk. | Use dedicated page-with-bands icon if shown. | P2 |  |
| Insert Slicer | Hidden/contextual; asset exists. | Ensure it maps to `filter.svg` or dedicated slicer icon instead of generic fallback. | P2 |  |
| Insert Timeline | Hidden/contextual; fallback risk. | Use date/timeline icon, not generic date only. | P2 |  |

### Draw

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Draw with Touch | Large gray command with simple line, weak disabled/readability state. | Add/alias a touch-draw icon; use standard 22 px or 32 px slot rather than a bare line. | P1 |  |
| Eraser | Simple eraser, adequate but plain. | Add `eraser.svg` or alias to `clear.svg` with eraser-specific geometry. | P2 |  |
| Lasso Select | Magnifier-like icon, semantically off. | Add `lasso-select.svg` with dotted lasso loop. | P1 |  |
| Pen | Bare diagonal line. | Use a pen-nib/stroke icon so it is distinct from Pencil/Add Pen/Line. | P1 |  |
| Pencil | Bare diagonal line, nearly same as Pen. | Add pencil icon with wood/point silhouette. | P1 |  |
| Highlighter | Better than Pen/Pencil due yellow accent. | Keep concept, but align geometry with revised pen family. | P2 |  |
| Add Pen | Bare diagonal line, almost identical to Pen. | Use Pen plus `+` overlay. | P1 |  |
| Ink to Shape | Current icon is small and mixed-style. | Use shape-conversion icon: ink stroke arrow to rectangle/circle. | P2 |  |
| Ink to Math | Current pi/sigma icon is recognizable. | Keep, but create small-specific asset if used at 22 px. | P3 |  |
| Shape Fill | Basic shape fill. | Use shared fill-color asset with shape outline. | P2 |  |
| Shape Outline | Blue outline icon is adequate. | Keep. | P3 |  |
| Shape Gradient | Blank rectangle reads as generic shape, not gradient. | Add gradient ramp icon. | P1 |  |
| Shape Effects | Blank rectangle reads as generic shape, not effects. | Add sparkle/shadow icon. | P1 |  |
| Crop Picture | Picture icon is readable. | Keep; optional use dedicated crop-corners overlay. | P3 |  |

### Page Layout

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Themes | Strong colored theme icon. | Keep. | P3 |  |
| Colors | Strong colored swatches. | Keep. | P3 |  |
| Theme Fonts | Currently too similar to Theme Effects in screenshot. | Use `fonts.svg` with a clear A/text cue. | P1 |  |
| Theme Effects | Currently too similar to Theme Fonts. | Use `effects.svg` with sparkle/shadow cue. | P1 |  |
| Margins | Page icon is readable. | Keep. | P3 |  |
| Orientation | Uses text-orientation style, which is wrong for Page Layout. | Replace with portrait/landscape page orientation icon. | P1 |  |
| Paper Size | Page size icon is readable. | Keep. | P3 |  |
| Print Area | Printer/grid icon is readable. | Keep. | P3 |  |
| Breaks | Page break icon is readable. | Keep. | P3 |  |
| Background | Image/page icon is readable. | Keep. | P3 |  |
| Print Titles | Stack/page icon is readable. | Keep. | P3 |  |
| Scale | Current icon is small and vague. | Use page with diagonal scale arrows. | P2 |  |
| View Gridlines | Checkbox command, no separate icon needed. | Keep. | P3 |  |
| View Headings | Checkbox command, no separate icon needed. | Keep. | P3 |  |
| Bring Forward | Good overlapping-shapes/arrow icon. | Keep. | P3 |  |
| Send Backward | Good paired icon. | Keep. | P3 |  |
| Selection Pane | Text command without strong icon. | Use `selection-pane.svg` when visible in compact/large state. | P2 |  |
| Rotate Object | Current rectangle/rotate affordance is minimal. | Use rotate arrow around shape. | P2 |  |
| Size | Corner handle icon is readable. | Keep. | P3 |  |

### Formulas

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Insert Function | Large `fx` is very readable. | Keep. | P3 |  |
| AutoSum | Large sigma is readable. | Keep. | P3 |  |
| Recently Used | Page/clock style is okay. | Keep. | P3 |  |
| Financial | Small category icon is somewhat dense. | Use dedicated small asset with currency/chart cue. | P2 |  |
| Logical Functions | Current icon reads as a tiny generic rounded rectangle. | Use TRUE/FALSE or logic gate cue. | P1 |  |
| Text Functions | Current `A` is too generic. | Use T/quotes or text-lines cue. | P2 |  |
| Date & Time | Calendar icon is readable. | Keep, but add clock overlay if not already clear at 22 px. | P3 |  |
| Lookup & Reference | Magnifier icon is clear. | Keep. | P3 |  |
| Math & Trig | Pi/sigma cue is clear. | Keep. | P3 |  |
| More Functions | Tiny `fx` box looks cramped. | Add small-specific `more-functions-small.svg`. | P2 |  |
| Name Manager | 32 px label/list is readable. | Keep. | P3 |  |
| Define Name | Current small icon is very thin. | Use tag-plus icon with stronger 22 px strokes. | P2 |  |
| Use in Formula | `fx`/tag cue is small. | Use tag inserted into formula icon. | P2 |  |
| Create from Selection | Current icon is very small. | Use grid-to-label icon with simplified 22 px version. | P2 |  |
| Trace Precedents | Current icon reads like a small chain, not direction. | Use incoming cell-arrow icon. | P1 |  |
| Trace Dependents | Current icon looks too similar to Trace Precedents. | Use outgoing cell-arrow icon. | P1 |  |
| Remove Arrows | Current icon is readable enough. | Add red X overlay if not visible at 22 px. | P2 |  |
| Show Formulas | Tiny formula text is marginal. | Use cell with `=A1` or simplified `=fx` small asset. | P2 |  |
| Error Checking | Warning triangle is strong. | Keep. | P3 |  |
| Evaluate Formula | Current `fx`/arrow cue is readable. | Keep, but verify at 22 px. | P3 |  |
| Add Watch | Text plus/minus icon is weak. | Use Watch Window base plus green `+` overlay. | P2 |  |
| Delete Watch | Text X icon is weak. | Use Watch Window base plus red `x` overlay. | P2 |  |
| Calculate Now | `fx` plus lightning is good. | Keep. | P3 |  |

### Data

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Get Data | 32 px database with arrow is readable. | Keep. | P3 |  |
| Refresh All | 32 px refresh icon is readable. | Keep. | P3 |  |
| Queries & Connections | Disabled/small database fallback, visually generic. | Use query/table-connection icon; avoid same cylinder as Stocks/Geography. | P1 |  |
| Stocks | Same generic database cue. | Use stock/radar/market icon. | P1 |  |
| Geography | Same generic database cue. | Use map/globe pin icon. | P1 |  |
| Sort A to Z | Current `A/Z` icon is serviceable but asset fallback was detected. | Add dedicated `sort-ascending.svg` mapping for this exact command. | P2 |  |
| Sort Z to A | Same as Sort A to Z. | Add dedicated `sort-descending.svg` mapping for this exact command. | P2 |  |
| Filter | Funnel is clear. | Keep. | P3 |  |
| Clear Filter | Clear/funnel cue is readable. | Keep. | P3 |  |
| Advanced Filter | Funnel plus marker is readable. | Keep. | P3 |  |
| Text to Columns | Good A/B column cue. | Keep. | P3 |  |
| Flash Fill | Yellow lightning cue is strong. | Keep. | P3 |  |
| Remove Duplicates | Icon is readable. | Keep. | P3 |  |
| Data Validation | Good, but yellow accent strip can look detached. | Contain accent inside 24 px slot, same fix family as Fill. | P2 |  |
| Consolidate | Green blocks are readable but small. | Keep, but consider stronger 22 px strokes. | P3 |  |
| What-If Analysis | Bullseye target is clear. | Keep. | P3 |  |
| Forecast Sheet | Chart icon is clear. | Keep. | P3 |  |
| Outline | Current grouped blocks are readable. | Keep. | P3 |  |
| Group | Contextual/outline command fallback risk. | Use `group.svg` exactly, not generic outline fallback. | P2 |  |
| Ungroup | Contextual/outline command fallback risk. | Use `ungroup.svg` exactly. | P2 |  |
| Show Detail | Contextual command. | Use expand icon with plus/chevron. | P2 |  |
| Hide Detail | Contextual command. | Use collapse icon with minus/chevron. | P2 |  |

### Review

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Spelling | `abc` check is readable. | Keep. | P3 |  |
| Workbook Statistics | Sigma/chart is good. | Keep. | P3 |  |
| Accessibility | Warning triangle is strong. | Keep. | P3 |  |
| Alt Text | Small image/text icon is thin. | Strengthen 22 px strokes or use dedicated `alt-text-small.svg`. | P2 |  |
| New Comment | Bubble icon is readable. | Keep. | P3 |  |
| New Note | Note icon is readable. | Keep. | P3 |  |
| Edit Note | Note/edit icon is readable. | Keep. | P3 |  |
| Delete Note | Note/delete icon is readable. | Keep. | P3 |  |
| Previous Note | Note/previous icon is readable. | Keep. | P3 |  |
| Next Note | Note/next icon is readable. | Keep. | P3 |  |
| Show Notes | Note icon is readable. | Keep. | P3 |  |
| Protect Sheet | Lock/sheet icon is strong. | Keep. | P3 |  |
| Protect Workbook | Lock/workbook icon is strong. | Keep. | P3 |  |
| Allow Edit Ranges | Current icon is readable. | Keep. | P3 |  |
| Share | Blue share-nodes icon is readable. | Keep. | P3 |  |

### View

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Normal | Grid icon is clear. | Keep. | P3 |  |
| Page Break Preview | Page/dotted icon is clear. | Keep. | P3 |  |
| Page Layout | Page icon is clear. | Keep. | P3 |  |
| Custom Views | Monitor/window icon is clear. | Keep. | P3 |  |
| Zoom | Magnifier plus green is clear. | Keep. | P3 |  |
| 100% | Currently mostly typographic `%`/`100%`, not a distinct icon. | Use `zoom-to-100.svg` or a 100-in-magnifier asset. | P2 |  |
| Zoom to Selection | Magnifier/grid is clear. | Keep. | P3 |  |
| New Window | Window icon is clear. | Keep. | P3 |  |
| Arrange All | Grid/window arrangement is clear. | Keep. | P3 |  |
| Freeze Panes | Grid icon is clear. | Keep. | P3 |  |
| Split | Split icon is clear. | Keep. | P3 |  |
| Hide | Same generic small rectangle family as Unhide. | Add eye-slash/window-hidden cue. | P2 |  |
| Unhide | Same generic small rectangle family as Hide. | Add eye/window-show cue. | P2 |  |
| View Side by Side | Two-pane icon is clear. | Keep. | P3 |  |
| Synchronous Scrolling | Two-pages icon is readable. | Keep. | P3 |  |
| Reset Window Position | Window reset icon is readable. | Keep. | P3 |  |
| Switch Windows | Window/switch icon is readable. | Keep. | P3 |  |
| Macros | Current database cylinder is semantically wrong. | Use macro/script/play icon. | P1 |  |

### Help, Backstage, Formula Bar, Panes

| Command | Current | Proposal | Priority | Decision |
|---|---|---|---|---|
| Help Online | Question mark icon is readable. | Keep. | P3 |  |
| Feedback | Comment bubble is readable. | Keep. | P3 |  |
| Copy Diagnostics | Info icon is readable. | Keep. | P3 |  |
| Check for Updates | Calendar-like icon reads weakly for update. | Use circular refresh/download update icon. | P2 |  |
| About FreeX | Info icon is readable. | Keep. | P3 |  |
| Show Training | Disabled book icon is readable. | Keep disabled treatment. | P3 |  |
| Contact Support | Disabled icon area appears nearly blank/strip-like. | Use `contact-support.svg` at disabled opacity. | P1 |  |
| What's New | Disabled icon area appears nearly blank/strip-like. | Use `what-s-new.svg` or info/starburst asset at disabled opacity. | P1 |  |
| Back to workbook | White back arrow on backstage rail. | Keep. | P3 |  |
| Backstage New | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Open | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Save | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Save As | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Print | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Export PDF/XPS | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Backstage Close | Text-only nav command. | Optional: add icons only if backstage rail is redesigned. | P3 |  |
| Formula bar Insert Function | 18 px `fx` text button. | Keep; it matches the formula bar scale. | P3 |  |
| Formula Bar Expand | 18 px text glyph. | Replace with chevron/up-down expander icon if formula bar gets broader polish. | P3 |  |
| Pivot field pane Close | Text `X`. | Use 18 px close icon only if pane chrome is redesigned. | P3 |  |
| Slicer/timeline pane Close | Text `X`. | Same as Pivot pane close. | P3 |  |

## Contextual and Hidden Command Families

The inventory contains many hidden/contextual commands that do not appear in the default screenshots. They should be fixed by family rather than one-off art.

| Family | Commands | Proposal | Priority | Decision |
|---|---|---|---|---|
| Chart type commands | Column, Stacked Column, 100% Stacked Column, Bar, Stacked Bar, 100% Bar, Line, 3D Line, Area, 3D Area, Stock, Pie, 3D Pie, Doughnut, Scatter, Bubble, Radar, Surface, Treemap, Sunburst, Histogram, Pareto, Box and Whisker, Waterfall, Funnel, Map, 3D Column, 3D Bar | Map every chart type to one of the existing chart family assets, then add missing family assets for visible chartEx families such as histogram, treemap, waterfall, and funnel; Map can keep fallback treatment while hidden/deferred. | P2 |  |
| Chart formatting commands | Axis bounds, labels, ticks, gridlines, legend, trendline, data labels, series, plot area, chart title, secondary axis | Reuse a small family of chart-format overlay icons rather than unique art for each option. | P2 |  |
| PivotTable Analyze commands | PivotTable Name, Options, Refresh, Change Data Source, Field Settings, Field List, Group Field, Select, Move PivotTable, Calculated Field/Item, PivotChart, Chart Options | Reuse PivotTable base plus overlay: gear, refresh, source arrow, field list, group, calculator, chart. | P2 |  |
| PivotTable Design commands | Grand Totals, Subtotals, Report Layout, Blank Rows, Banded Rows/Columns, Row/Column Headers, PivotTable Styles | Use table-layout base icons with row/column highlight overlays. | P2 |  |
| Menu-only paste commands | Paste, Values, Formulas, Formatting, Transpose, Paste Special | Existing menu seeding is acceptable; ensure all remain 18 px and share the same visual weight. | P3 |  |
| Border menu commands | All, Outside, Inside, None, Bottom, Top, Left, Right, thick/double variants, line color, line style, More Borders | Existing `BorderMenuIcon` is good at 18 px. Keep. | P3 |  |
| Sheet context menu commands | Rename, Insert Sheet, Duplicate, Delete Sheet, Hide, Unhide, Tab Color, Select All Sheets, Ungroup, Move Left/Right | Add icons only if context menus move to full iconized menus; current text-only menu is acceptable. | P3 |  |

## Proposed Implementation Order

1. **P1 semantic fixes:** Add or remap assets for Add-ins, Data Types, Draw tool family, Page Layout Orientation, Trace Precedents/Dependents, Macros, Contact Support, What's New, and Insert Comments width/truncation.
2. **P2 small readability:** Add small-specific assets for decimal places, formula category icons, Define Name/Use in Formula/Create from Selection, Hide/Unhide, Scale, 100%, Data Validation/Fill accent containment.
3. **P2 guardrails:** Add tests for visible command icon fallback allow-list and disabled icon nonblank rendering.
4. **P3 polish:** Optional iconization for backstage nav and pane close buttons.

## Acceptance Checklist

- [ ] Accept current 16 / 18 / 22 / 32 px size system.
- [ ] Accept P1 semantic fixes.
- [ ] Accept P2 small-specific SVG pass.
- [ ] Accept disabled-state rule.
- [ ] Decide whether backstage navigation should stay text-only.
- [ ] Decide whether context menus should remain text-only except seeded menu icons.

