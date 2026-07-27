# FreeP Function-First Audit - 2026-07-24

This audit deliberately excludes further pixel calibration. It checks whether the
current product has actionable command or host-function gaps before another visual
slice is selected.

## Current command surface

The generated inventory at `docs/parity/freep-command-parity-inventory.json` reports:

- 436 command IDs total.
- 434 shared across WPF and Avalonia.
- 0 actionable missing WPF commands.
- 0 actionable missing Avalonia commands.
- 2 intentional shell/profile variances: Undo and Redo are routed through WPF
  routed commands/keyboard bindings while Avalonia exposes generated ribbon entries.

The inventory is command-surface evidence, not a claim that every PowerPoint feature
is complete.

The generated inventory is the authoritative count. The apparent nested reading-order
gap is also closed: the shared planner enumerates group descendants with nesting depth,
and `EditingSession.MoveSelectedShapeInReadingOrder` reorders a selected child inside
its containing sibling list without moving it out of the group. WPF host coverage now
exercises the move, selection refresh, and undo path. The old deferred-message constant
was stale bookkeeping, not an active capability restriction.

## Verified function paths

- Selection, marquee, move, resize, rotate, nudge, snapping, and source-then-target
  Format Painter are implemented in both hosts.
- Animation pane trigger, duration, delay, effect options, reorder, and playback
  mutations route through shared typed planners in both hosts.
- Animation pane emphasis Spin effect amounts (Quarter Spin, Half Spin, Full Spin,
  and Two Spins) now preserve the authored `presetSubtype` through the shared model,
  undo path, WPF/Avalonia pane options, and PPTX read/write.
- SmartArt text-pane editing has shared node mutations, outline rebuilding, and host
  pane routes. The modeled layout catalog and eight native Quick Style presets
  (Simple, Moderate, Intense, Subtle, Soft Edge, Insert, Cartoon, and Powder) are
  reachable through both WPF and Avalonia contextual galleries, with native style-part
  round-trip and undo coverage. Full PowerPoint-authoritative SmartArt regeneration,
  deeper style authoring, and the long tail of layout families remain a separate scope.
- On Windows, WPF and Avalonia use `FreeP.App.Recording.Windows` and WinRT
  `MediaCapture` for local camera MP4 capture. The cross-platform recording project
  intentionally retains a no-Windows-runtime deferred fallback for tests and non-Windows
  targets; that fallback is not the Windows product path.
- Recent function slices cover hidden-slide state, notes export, media capture and
  insertion, accessibility/review panes, printing, and grouped DrawingML package
  round-trip behavior.
- Common Insert AutoShape presets now include Triangle, Diamond, Hexagon, Right Arrow, and
  5-Point Star in both generated host ribbons. They use the shared insertion planner and
  EditingSession path, so default geometry, rendering, undo, and PPTX round-trip stay aligned.
- Change Shape now exposes Rectangle, Ellipse, Triangle, Diamond, and Right Arrow as one
  undoable operation in both host ribbons. It preserves the selected AutoShape's text, frame,
  and style while replacing only preset guides/custom geometry; unsupported object kinds remain
  no-ops, and the command is covered by focused model and EditingSession tests.
- Insert Connector now adds a shared undoable straight-connector command. With two selected
  shapes it emits native start/end connection sites, so moving either shape can reroute the
  connector; with no two-shape selection it inserts a free centered connector. Both host ribbons
  use the same planner path and the existing PPTX connector reader/writer preserves attachments.
- Elbow Connector and Curved Connector now use that same insertion path. Elbow connectors retain
  the existing Manhattan reroute behavior when attached shapes move; all three variants share
  native attachment persistence and host registration.
- The print Backstage path now accepts a shared custom slide-range string such as
  `2,4-6` (including validation, hidden-slide filtering, and package disabled reasons)
  through both WPF and Avalonia host adapters. The hosts consume the shared parser;
  neither owns a divergent range grammar.
- WPF Backstage and both Avalonia print projections expose an Apply-range input. The
  selected range rebuilds the shared preview/package plan, and the native print handoff
  retains that same request instead of falling back to all slides.
- Chart insertion now exposes every modeled chart family through the shared insertion
  planner and both host ribbons, including stacked and 100% stacked variants, line
  markers, area, scatter, doughnut, radar, bubble, stock, surface, and 3-D surface.
- Chart data editing now also supports PowerPoint's Switch Row/Column operation in both
  WPF and Avalonia. The shared planner transposes category labels, series names, and
  nullable value gaps before the existing single-step ReplaceChartData undo command.
- Chart data editing now also changes the selected chart type in both WPF and Avalonia.
  The same batch command preserves the type change in PPTX output, creates valid X/value
  payloads when moving to Scatter or Bubble, and restores those coordinates on undo.
- Chart data editing now exposes Scatter X/Y values and Bubble X/Y/size values in the
  shared grid on both WPF and Avalonia. Coordinate edits use the same single undo batch,
  regenerate the embedded workbook, and round-trip through the native chart payload.
- Chart data editing now also moves the active series up or down in both WPF and Avalonia.
  The shared planner moves series-owned values and scatter/bubble coordinates together, while
  the direct command preserves the existing series object and its authored formatting for
  undo and PPTX round-trip.
- Chart authoring now also exposes a shared Chart Options dialog in both hosts. Title,
  legend placement, value-label placement/visibility, and category/value major gridlines
  commit through one undoable command and round-trip through the existing chart package
  writer.
- Chart authoring now also exposes a shared Axis Options dialog in both hosts. Category and
  value axes can edit titles, automatic or explicit minimum/maximum scale, major/minor units,
  number formats, and major gridline visibility through one undoable command. The values
  round-trip through the existing chart axis reader/writer.
- Chart authoring now also exposes a shared Series Options dialog in both hosts. Each series
  can edit smooth-line state, secondary-axis assignment, line width, marker symbol, and marker
  size through one undoable command; the existing chart reader and writer preserve those values
  through PPTX round-trip.
- Chart authoring now also exposes a shared Point Options dialog in both hosts. A selected
  series/category point can edit fill, outline color/width, marker symbol, and marker size
  through one undoable command; existing point-style and point-color payloads round-trip through
  the PPTX reader and writer.
- Chart authoring now also exposes a shared Chart Layout Options dialog in both hosts. Plot-area
  and legend manual layouts can edit the layout target, factor/edge modes, and x/y/width/height
  through one undoable command; existing manual-layout values round-trip through the PPTX reader
  and writer.
- Chart authoring now also exposes a shared Data Table dialog in both hosts. It can show or hide
  the chart data table and edit horizontal, vertical, outline, and legend-key settings through one
  undoable command; existing `c:dTable` payloads and authored chart styling survive the update.
 - Chart display options now expose the full modeled chart-level data-label components in both
   hosts: values, percentages, category names, series names, legend keys, placement, number format,
   and separator. The same undoable command creates or updates the `c:dLbls` payload and preserves
   it through PPTX round-trip.
 - Chart display options now also expose chart-level data-label font family, size, color, bold, and
   italic styling in both hosts. The same command preserves nullable inherited bold/italic state
   through the existing chart text-properties payload and PPTX round-trip.
- Chart Series Options now exposes series-scoped data-label overrides in both hosts, including
  value, percentage, category, series-name, and legend-key components plus position, number
  format, separator, font family, size, color, bold, and italic. The shared undo command preserves
  the override through `c:dLbls` while disabling it restores chart-level label fallback; nullable
  bold/italic values retain inherited state.
- Chart Point Options now exposes selected-point data-label overrides in both hosts, including
  value, percentage, category, series-name, and legend-key components plus position, number
  format, separator, and the native delete token. The shared point-style command preserves each
  override as a `c:dLbl` entry and undo removes it without disturbing other point formatting.
- Point data-label authoring now also exposes the modeled font family, size, bold, italic, and
  color fields in both hosts, preserving nullable inherited bold/italic state through PPTX
  round-trip. PowerPoint-authoritative chart raster baselines remain a separate visual gate.
- Chart, Series, and Point Options now expose bubble-size data labels in both hosts. The shared
  model, `c:showBubbleSize` reader/writer, undo paths, and chart renderer preserve and format
  the corresponding bubble datum; PowerPoint-authoritative bubble-label raster baselines remain
  deferred.
- Chart display options now also expose bar/column gap width (0-500%) and overlap (-100% to 100%)
  in both hosts. Blank values preserve automatic chart behavior; explicit values share one undoable
  command and round-trip through `c:gapWidth` and `c:overlap`.
- SmartArt authoring now exposes the specialized layouts already supported by the live
  shared layout engine: alternating process, arrow ribbon, circle process, funnel process,
  vertical process, segmented process, chevron process, basic/closed-chevron process,
  bending process, descending block list, radial Venn, target list, stacked Venn, gear cycle,
  text cycle, block cycle, non-directional cycle, vertical bullet list, titled matrix,
  and hierarchy3.
  Each route updates the native diagram layout part and the live model, then remains
  undoable through the shared editing session in both hosts.
- SmartArt insertion now also exposes Picture Caption List in both hosts. The shared
  insertion plan accepts one or more image payloads, attaches them to the native diagram
  drawing/media parts, and reopens them as live node pictures; the WPF and Avalonia ribbon
  routes use the normal image picker and reuse one selected image for the default three nodes.
- Continuous Cycle is now admitted through the same shared cycle-family live layout path and
  exposed as an undoable authoring command in both hosts; other unmodeled SmartArt family
  variants and PowerPoint-specific style/effect regeneration remain deferred.
- Hierarchy authoring now also exposes Horizontal Hierarchy and Organization Chart, using
  the existing shared tree layout paths rather than leaving those PowerPoint layout choices
  as import-only behavior.
- WPF and Avalonia slideshow playback now surface parsed media caption cues from the active
  playback clock; the shared planner owns cue interval semantics and both host controllers
  retain their own native overlay lifecycle.
- Shape Edit Points now also exposes the native Triangle apex adjustment in both hosts. The
  authored `adj` guide is consumed by shared geometry, the live adorner, PPTX round-trip, and
  the existing undoable geometry-adjustment command; legacy triangles without a guide remain
  centered.
- Shape Edit Points now also exposes the native `star8` point-depth guide in both hosts. The
  shared geometry builder consumes the authored `adj` value, while legacy eight-point stars
  without a guide retain the existing fixed-depth outline.
- SmartArt authoring now also exposes the common Pyramid List layout in both hosts. The
  native `pyramidList` layout ID, List family, undo path, and shared live narrowing-segment
  regeneration are covered together; other unmodeled SmartArt families retain the cached
  fallback path.
- Shape Edit Points now also exposes native `rightArrow` `adj1`/`adj2` guides in both hosts.
  `adj1` edits shaft thickness and `adj2` edits head length through shared geometry, the live
  adorner, one undoable geometry-adjustment command, and PPTX round-trip; legacy arrows without
  authored guides retain the established FreeP outline.
- Shape Edit Points now also exposes native trapezoid and parallelogram `adj` guides in both
  hosts. The shared geometry builder consumes authored slant/depth values, the live adorner
  reduces pointer movement to one undoable adjustment command, and PPTX round-trip preserves
  the guide.
- Shape Edit Points now also exposes the single native `adj` bar-inset guide for `cross` and
  `plus` presets in both hosts. The shared geometry builder keeps the legacy 35% fallback when no
  guide is authored, while the live adorner, undo command, and PPTX round-trip preserve edited bar
  thickness.
- The same shared guide path now covers `leftArrow`, `upArrow`, and `downArrow`, with direction-
  aware handle positions and pointer reduction while preserving each legacy no-guide outline.
- Compound arrows now expose their native `adj1` shaft-thickness and `adj2` symmetric head-depth
  guides for `leftRightArrow` and `upDownArrow` in both hosts. Shared geometry, aspect-aware head
  limits, undoable Edit Points mutation, and PPTX round-trip preserve the authored guides while
  legacy no-guide outlines remain unchanged.
- `chevron` and `homePlate` now expose their native `adj` point-depth guide in both hosts. The
  aspect-ratio-aware guide maximum, shared geometry, undoable Edit Points mutation, and PPTX
  round-trip all agree, while legacy no-guide outlines remain unchanged.
- `star5` now exposes its native `adj` point-depth guide in both hosts. The shared geometry,
  interactive edit-point mutation, undo path, and PPTX round-trip preserve authored star depth;
  legacy stars without a guide retain the established outline.
- Connector attachment sites now follow the attached shape's authored rotation and horizontal or
  vertical flips, while retaining the existing per-shape site tables and fallback behavior.
- Connector attachment sites now use the visible outline for pentagon, hexagon, octagon, cross,
  and Star5 presets; callout, ribbon, and other irregular presets remain on the fallback path.
- SmartArt hierarchy authoring now exposes Add Assistant and Toggle Assistant actions in both
  hosts' text panes. The shared add edit inserts an assistant child before regular children,
  writes the new `dgm:pt type="asst"` semantic, regenerates the native data/cache parts, and
  remains one undoable edit; non-hierarchy data is rejected rather than silently changing
  layout semantics.
- SmartArt now exposes PowerPoint's Convert to Shapes workflow in both hosts. The shared session
  materializes the live layout (or cached fallback), replaces the graphic at its original z-order
  slot with ordinary shapes using collision-free IDs, and keeps the entire conversion undoable and
  redoable.

## Remaining function scope

The remaining gaps are depth and application compatibility, not missing ribbon IDs:

- the remaining long tail of SmartArt layout families and full PowerPoint-authoritative
  SmartArt regeneration/style editing beyond the now-expanded live preset catalog;
- advanced chart authoring/layout semantics beyond the current supported model, including
  richer chart data editing beyond the shared grid and PowerPoint-specific chart-area styling
  beyond manual layout geometry;
- deeper presenter/review/accessibility workflows and application-specific dialog
  behavior, including broader SmartArt hierarchy regeneration and style semantics beyond
  the now-covered add/toggle assistant operations;
- broader media/presenter integration and platform-specific capture/export behavior, including
  real-device capture and PowerPoint-authoritative media/caption baselines;
- PowerPoint COM-backed workflow validation on a machine where that comparison path is
  available.

### 2026-07-27 function-first checkpoint

The generated command inventory now reports 444 FreeP command ids: 442 shared by WPF and
Avalonia, with no actionable host-specific command gaps. The latest transition-sound slice
closed an authoring hole that was easy to mistake for a visual-only concern: both hosts now
open a native sound picker, attach the selected audio bytes/content type to the current slide
transition, create the default Fade transition when a sound is added to a slide without one,
clear the sound without disturbing other transition settings, and route the mutation through a
single undoable `SetSlideTransitionCommand`. The package/model path was already authoritative;
the missing piece was the user-facing command route and host picker adapter.

This checkpoint deliberately changes the next-work rule. Do not spend the next slice on a
small raster delta unless it also unblocks a user workflow. The active function queue is now:

- deepen presenter capture where a real microphone/camera or persisted media artifact can be
  exercised, while keeping unavailable hardware explicit rather than simulated;
- add the next bounded advanced chart or SmartArt authoring operation only when its model and
  package round-trip path already exists;
- continue accessibility/review and output-dialog depth where a user action is still deferred;
- use the PowerPoint COM-capable lane for visual claims, not as a reason to hold back functional
  package and authoring progress.

The command count is a reachability metric, not a claim that PowerPoint feature depth is
complete. Advanced SmartArt regeneration/style semantics, richer chart editing, real capture
backends, native output adapters, and PowerPoint-authoritative visual baselines remain open.

### 2026-07-27 table-cell fill authoring

Per-cell fills were already represented in the model, preserved by the PPTX reader/writer, and
painted by both renderers, but there was no shared authoring operation. The function slice adds
an undoable `SetTableCellFillCommand`, a `Table Cell Fill` palette to both host ribbons, and
active-cell routing through `EditingSession`. Clearing the selection removes only the explicit
cell fill so the table style can become authoritative again. Focused command, ribbon, and
save/reopen tests cover the new route; this is a functional parity change, not a new visual
calibration claim.

### 2026-07-27 table-cell vertical alignment authoring

Table-cell vertical alignment was already represented by `TableCell.Anchor`, preserved by the
PPTX reader/writer, and consumed by both renderers, but neither host exposed an authoring route.
The function slice adds an undoable `SetTableCellAnchorCommand`, an Automatic/Top/Middle/Bottom
palette to both ribbons, and active-cell routing through `EditingSession`. Focused command,
ribbon, and save/reopen tests cover the route; this is functional parity work, not a visual
calibration claim.

### 2026-07-27 table-cell border authoring

Per-cell borders were already represented by `TableCell.Borders`, preserved by the PPTX
reader/writer, and consumed by both renderers, but there was no active-cell authoring route. The
function slice adds an undoable per-side border command and a shared ribbon palette for
Automatic, None, and common black solid pen widths on the left, right, top, and bottom sides.
Both hosts route the selection through `EditingSession`; command, host, and save/reopen tests
cover the new path. This is functional package/authoring parity, not a new visual calibration
claim.

## Process decision

### 2026-07-27 Picture Grid SmartArt route

PowerPoint's Picture Grid layout is now a distinct function path in both hosts. The shared
authoring and insertion planners emit the native `pictureGrid` DiagramML identity, require
source picture payloads, and keep the change undoable. The shared live engine places picture
nodes in a two-column grid with captions, while the reader rehydrates those node images from
the native drawing relationships so save/reopen does not silently fall back to cached artwork.
Focused layout, authoring, insertion, WPF, and Avalonia tests cover the route. This remains
renderer-neutral function coverage; exact PowerPoint sizing/effects are still a separate
visual-baseline question.

### 2026-07-27 Cross/Plus authoring routes

The shared geometry and Edit Points path already supported `Cross` and `PlusSign`, but the
normal Insert Shape and Change Shape menus did not expose either preset. The bounded function
slice adds both routes to the shared planner and both WPF/Avalonia command surfaces, with
localization, ribbon-definition, insertion, change-shape, and host round-trip coverage. This
keeps the function-first lane focused on reachable PowerPoint authoring rather than another
renderer calibration.

### 2026-07-26 series-scoped chart-label slice

PowerPoint permits a selected series to override chart-level data labels. FreeP already parsed
and wrote series `c:dLbls`, but the Series Options workflow could not author them. The bounded
function slice extends the shared planner, undo command, WPF dialog, and Avalonia dialog without
creating a second renderer or package path. Focused planner, command round-trip, and both-host
 dialog tests cover enable, edit, disable, and save/reopen behavior.

### 2026-07-26 chart-level data-label text slice

PowerPoint permits chart-level data-label text styling alongside the label components. FreeP
already parsed and wrote chart text properties, but the Chart Options workflow did not expose
them. The bounded function slice extends the shared chart display planner, undo command, WPF
dialog, and Avalonia dialog for font family, size, color, bold, and italic values. Focused planner,
command round-trip, and both-host dialog tests cover edit and save/reopen behavior while preserving
nullable inherited emphasis state.

### 2026-07-25 bounded rich-edit slice

WPF already maps the shared model's dedicated `Run.Text == "\n"` value to a native
`LineBreak`, and the PPTX reader/writer preserve that value. Avalonia previously sent
both `Enter` and `Shift+Enter` through plain-text replacement, which rebuilt every
newline as a new paragraph and made soft-line-break authoring impossible. The bounded
slice adds shared-buffer soft-break insertion and Avalonia `Shift+Enter` handling for
both shape and table-cell editors; ordinary `Enter` paragraph splitting is unchanged.
Focused shared, Avalonia headless, and existing WPF converter coverage assert that the
break remains one paragraph, survives the editor body, and retains the WPF contract.
While a shape is actively edited, both hosts suppress only that shape's base text beneath the rich overlay; table-cell ghosting remains separate.
This does not claim parity for broader IME, RTL, or list-continuity behavior.

Do not select another renderer-only calibration from stale comments such as
“viewer-only”, “Tab navigation is not implemented”, or “animation timing is stubbed”.
Choose the next slice from a reproducible function gap with a host workflow and
round-trip assertion, then add visual evidence only when the function path is proven.

### 2026-07-27 WPF table structure context route

Avalonia already exposed active-cell table row/column insertion, deletion, merge, and split
through its context menu, while WPF only exposed the shared table commands indirectly. WPF now
hit-tests the table and active cell on right-click and exposes the same guarded context actions,
routing every mutation through `EditingSession` so undo/redo and package behavior remain shared.
Focused WPF host coverage verifies menu parity, enabled states, merge, and split execution.

### 2026-07-27 auto-shape command expansion

The shared geometry and DrawingML mapping already supported Pentagon, Octagon, LeftRightArrow,
UpDownArrow, Star8, Chevron, and HomePlate, but neither host exposed those shapes in its complete
Insert and Change Shape command surfaces. The shared insertion and change planners now publish the
seven commands; Avalonia routes the Change Shape commands, WPF supplies matching ribbon icons, and
focused planner, ribbon, and headless host tests verify creation, conversion, and command reachability.

### 2026-07-27 emphasis-animation command expansion

The animation model, OOXML mapping, and slideshow playback already supported Teeter, Blink,
Color Pulse, Change Color, Grow With Color, Wave, Shimmer, Bold, and Underline emphasis effects,
but the editor ribbon only exposed Pulse, Spin, and Grow/Shrink. The shared animation planner and
both host ribbon surfaces now expose the nine existing presets as reachable Add Effect commands,
with localization, icon, planner, and WPF definition coverage. This is a function/authoring slice;
it does not alter the established playback or renderer paths.

### 2026-07-27 auto-shape catalog expansion

The shared geometry, DrawingML preset map, and editing commands already supported
right triangles, mathematical symbols, waves, and callout shapes, but the normal
Insert Shape and Change Shape surfaces stopped at the earlier 22-shape catalog.
This slice exposes Right Triangle, Minus, Multiply, Divide, Equal, Not Equal, Wave,
Rectangular Callout, Rounded Rectangular Callout, and Oval Callout through both host
ribbons and Avalonia routes. Localization, icons, planner insertion/conversion,
and WPF/Avalonia reachability tests cover the new commands; no renderer behavior changed.

### 2026-07-27 flowchart and special AutoShape catalog expansion

The shared geometry builder and DrawingML preset map already supported the remaining
flowchart process/decision/data/predefined/document/terminator shapes plus Explosion,
Ribbon, Line Callout, Cylinder, and Chord, but they were not reachable from Insert Shape
or Change Shape. Both host command surfaces now expose these eleven native kinds through
the shared insertion/editing session path, with localized labels, meaningful ribbon icons,
and WPF/Avalonia planner and reachability coverage. The slice adds no renderer-specific
calibration and preserves the existing native preset geometry on save/reopen.

### 2026-07-27 Interlocking Rings SmartArt route

PowerPoint's relationship-family SmartArt catalog includes Interlocking Rings, but FreeP
previously admitted only the older relationship layouts and fell back to cached DrawingML for
this native layout ID. The shared planner now preserves the `interlockingRings` DiagramML identity,
generates bounded overlapping translucent ellipse geometry for two-to-five nodes, and exposes the
layout through insertion and change-layout commands in WPF and Avalonia. Reader admission, native
layout persistence, shared composition, undo-capable authoring routes, and host command reachability
are covered by focused tests. This is a functional layout-family slice; it does not claim exact
PowerPoint style regeneration for arbitrary Interlocking Rings packages.

### 2026-07-27 chart data selected-entry removal

PowerPoint removes the selected chart series or category, while FreeP's chart-data dialogs
previously removed only the final entry. The shared chart grid and presentation planner now
support indexed removal, including aligned scatter X values and bubble-size rows. WPF derives
the series from the selected grid column and the category from the selected row; Avalonia tracks
the focused series/category cell and routes the same shared mutation. Focused planner, WPF, and
Avalonia dialog coverage verifies non-tail removal and save-ready matrix alignment across hosts.

### 2026-07-27 presenter view record timings

The shared slideshow session already tracked per-slide elapsed time and persisted
`SlideTransition.AdvanceAfterMs`, but neither native presenter dashboard exposed the
PowerPoint-style Record Timings action. WPF and Avalonia now expose the same toggle,
preserving the current media and pointer settings while routing through
`SlideShowSessionController`; the button reflects the shared intent and can stop
recording without introducing a UI-local timer. Focused presenter source and view-plan
tests cover the cross-host route. Hardware capture and COM validation remain outside
this slice.

### 2026-07-27 presenter view rehearse timings

The shared timing recorder already distinguished rehearsal from recording and intentionally
avoided persisting rehearsal durations, but the native presenter dashboards exposed only
Record Timings. WPF and Avalonia now expose a separate Rehearse Timings toggle, with the
active mode reflected from the shared presenter plan and both transitions routed through
the same session controller. Focused view-plan and host source tests cover the distinction;
rehearsal remains a local timing workflow and does not claim hardware or COM capture parity.
