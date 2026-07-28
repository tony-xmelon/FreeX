# FreeP Function-First Audit - 2026-07-24

This audit deliberately excludes further pixel calibration. It checks whether the
current product has actionable command or host-function gaps before another visual
slice is selected.

## Current command surface

The generated inventory at `docs/parity/freep-command-parity-inventory.json` reports:

- 521 command IDs total.
- 521 shared across WPF and Avalonia.
- 0 actionable missing WPF commands.
- 0 actionable missing Avalonia commands.
- 0 intentional shell/profile variances.

The inventory is command-surface evidence, not a claim that every PowerPoint feature
is complete.

The generated inventory is the authoritative count. The apparent nested reading-order
gap is also closed: the shared planner enumerates group descendants with nesting depth,
and `EditingSession.MoveSelectedShapeInReadingOrder` reorders a selected child inside
its containing sibling list without moving it out of the group. WPF host coverage now
exercises the move, selection refresh, and undo path. The old deferred-message constant
was stale bookkeeping, not an active capability restriction.

The WPF Home ribbon now exposes Undo and Redo through the shared editor command bus,
matching the Avalonia profile and the existing WPF keyboard/routed-command behavior.
This closes the remaining ribbon-surface gap for those workflows; deeper functional
work remains in SmartArt regeneration, advanced chart authoring, presenter/review/
accessibility depth, and real application capture/export validation.

## Verified function paths

- Selection, marquee, move, resize, rotate, nudge, snapping, and source-then-target
  Format Painter are implemented in both hosts.
- Animation pane trigger, duration, delay, effect options, reorder, and playback
  mutations route through shared typed planners in both hosts.
- Animation pane emphasis Spin effect amounts (Quarter Spin, Half Spin, Full Spin,
  and Two Spins) now preserve the authored `presetSubtype` through the shared model,
  undo path, WPF/Avalonia pane options, and PPTX read/write.
- SmartArt text-pane editing has shared node mutations, outline rebuilding, and host
  pane routes. The modeled layout catalog and 14 native PowerPoint Quick Style entries
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
- The Accessibility Checker now gives missing-chart-title findings a real
  `Add Chart Title` action in both hosts. The action navigates to the chart and
  opens the existing Chart Display Options editor, so the user can supply a
  meaningful title through the normal undoable chart mutation path.
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

### 2026-07-28 transition audit checkpoint

### 2026-07-28 transition clone metadata preservation

Duplicating a slide already deep-cloned its transition, but omitted the authored split
orientation. A duplicated Split transition could therefore reopen or play with the wrong
horizontal/vertical axis even though the source slide remained correct. The shared clone now
retains `SplitOrientation`, with a duplicate-slide regression covering the command path.

### 2026-07-28 animation metadata preservation

Timing and trigger edits clone the selected animation through the shared command
planner. That clone now retains authored Wheel spoke counts, so changing duration,
delay, or trigger no longer silently turns a custom eight-spoke effect back into the
default. The regression is covered through the ribbon command path; the package and
playback model remain unchanged.

The WPF slideshow host dispatches every renderer-neutral
`SlideShowTransitionPlaybackActionKind` emitted by the shared planner. Legacy
PowerPoint transition names that do not have a dedicated renderer family are
intentionally normalized by `SlideShowTransitionPlanner` to an existing family
(for example Doors to Split and Comb to Blinds), so they remain executable
rather than silently falling through to a host-specific no-op. A source guard in
`WpfTransitionPlaybackParityTests` keeps this coverage aligned if the shared
action catalog grows.

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

### 2026-07-27 table-cell inset authoring

Table cells already carried authored `tcMar` values through the shared model, PPTX reader/writer,
and both renderers, but the hosts had no authoring route. WPF and Avalonia now expose a shared
Cell Insets palette with automatic or point-valued presets for all four sides. The operation is
one undoable `SetTableCellInsetCommand`; `Automatic` clears only the explicit cell value so
table-style inheritance remains authoritative. Focused shared, WPF, Avalonia, ribbon-definition,
and save/reopen tests cover the route. This is functional package/authoring parity, not a new
visual calibration claim.

### 2026-07-27 table-row height authoring

Table rows already carried authored `HeightEmu` values through the shared model,
PPTX reader/writer, and renderer paths, but neither host exposed a PowerPoint-style
row-height workflow. WPF and Avalonia now expose a shared Row Height palette with
Automatic and fixed inch presets. The active cell resolves its owning row and routes
one undoable `SetTableRowHeightCommand`; save/reopen tests verify the edited height
survives PPTX round-trip. This closes the authoring/function gap without changing
the established table renderer or claiming a new pixel-fidelity improvement.
### 2026-07-27 table-column width authoring

Table grid-column widths already existed in the FreeP model, PPTX reader/writer, and shared
compositor, but existing-table column resizing had no user action. WPF and Avalonia table context
menus now expose common PowerPoint-style width presets for the active column. Each choice routes
through one undoable `SetTableColumnWidthCommand`, updates the shared grid used by all rows, and
survives PPTX save/reopen. Focused shared command, WPF context-menu, and Avalonia context-menu
tests cover apply/undo and host reachability. This is functional package/authoring parity; it
does not claim a new visual-fidelity calibration.

### 2026-07-28 text autofit authoring

Text bodies already preserved PowerPoint's three distinct DrawingML autofit modes:
`a:noAutofit`, `a:normAutofit`, and `a:spAutoFit`. FreeP now exposes those choices in the
shared WPF/Avalonia font ribbon and routes them through one undoable
`SetShapeTextAutoFitCommand`. Command, profile, host-routing, and PPTX save/reopen tests cover
the exact three-state distinction. This closes a functional authoring gap without changing
the established text renderer or claiming a new pixel-fidelity calibration.

### 2026-07-28 Windows video export execution

FreeP's shared video workflow already produced a validated, duration-bearing PNG frame package,
but Windows advertised video encoding as deferred when ffmpeg was absent. The Windows recording
adapter now detects the built-in MediaComposition stack and encodes that package directly to MP4,
preserving per-frame durations and deleting partial output on cancellation or invalid output.
The native path also supports delayed multi-track narration WAV and captured camera MP4 artifacts
as bottom-right picture-in-picture overlays using the same slide start-time and duration plan. Focused
Windows recording plus WPF/Avalonia host coverage verifies capability detection, adapter selection,
and host routing; no visual-parity claim is attached to the encoded video.

The native path now also attaches captured camera PIP media and delayed multi-track narration WAV
artifacts to the Windows composition. Capability and status text distinguish the native path from
the ffmpeg fallback, while malformed or unsupported artifacts still fail explicitly. Focused
Windows recording, host routing, and live native compositor smoke coverage now exercise delayed
audio and camera tracks; PowerPoint-authoritative video baselines and real-device capture remain
separate open work.

### 2026-07-28 current function checkpoint

The current inventory is the source of truth for command reachability; the old 436-command figure
above was a historical checkpoint and is intentionally superseded by the 519-command inventory.
There are no actionable WPF or Avalonia command gaps. The next function-first queue should therefore
be selected from depth rather than ribbon discovery:

- SmartArt native data-part/style regeneration beyond the bounded live layout and outline routes;
- richer chart authoring and PowerPoint-specific chart-area semantics beyond the current dialogs;
- deeper presenter/review/accessibility workflows and real-device media capture;
- PowerPoint COM-backed workflow and output validation when that lane is available.

Chart series trendlines and error bars are already a completed function slice: the shared Series
Options planner and both host dialogs expose the modeled families, polynomial/average parameters,
equation/R-squared flags, error direction/type/value settings, and one undoable command. The
`ChartErrorBarsTests`, chart-data command tests, WPF dialog tests, and PPTX round-trip coverage
exercise that path. Do not reopen it as a visual-calibration task unless a new user workflow is
identified.

### 2026-07-29 secondary chart-axis authoring

The chart model, OOXML reader/writer, series options, and renderer already supported a right-hand
secondary value axis, but the Chart Axis dialog exposed only Category and primary Value. The shared
axis planner and undoable command now expose Secondary Value, including creation of a missing axis
and removal of that empty authored axis on undo. WPF and Avalonia present the same third target and
the focused planner, command, WPF source, and Avalonia headless tests cover the route. This is a
functional authoring slice; it does not claim new chart raster parity.

### 2026-07-29 presenter recording media intents

The shared presenter planner already exposed Narration and Narration-and-Camera intents, and the
slideshow session already routed both through the recording capability state, but neither native
Presenter View exposed those actions. WPF and Avalonia now show matching toggle controls and forward
the selected media intent through `ApplyPresenterToolIntent`; deferred hardware remains reported by
the existing capture-capability status rather than being presented as a successful recording.
Focused WPF and Avalonia presenter source/behavior tests cover the controls and preservation of
timing and pointer state.

### 2026-07-29 SmartArt Bending Process layout

The exposed `bendingProcess` SmartArt preset no longer falls through to the generic horizontal
process row. The shared live layout now emits a bounded two-track zig-zag with ordered diagonal
connectors for both hosts, while malformed or oversized input continues to use the imported
cached drawing fallback. This is a functional layout-depth slice; it does not claim new Word or
PowerPoint raster calibration.

### 2026-07-29 SmartArt Bending Process node-count recovery

The shared two-track `bendingProcess` geometry already scaled its gap and connector widths from
the parsed node count, but an artificial twelve-node admission cutoff sent larger valid diagrams
to the cached drawing path. The cutoff is removed while the malformed-text guard remains. Planner
tests cover 13- and 20-node diagrams, and the WPF compositor test confirms all 13 boxes and 12
connectors remain live. Avalonia consumes the same renderer-neutral shape/connector plan. This is
functional SmartArt depth evidence only; exact PowerPoint turning geometry and raster parity remain
deferred.

### 2026-07-29 Selection Pane z-order controls

The Selection Pane already supported object selection, names, visibility, and grouped-child
addressing, but its existing undoable reading-order mutation was not reachable from the pane
itself. Both WPF and Avalonia now expose front/back move buttons for each item, disable them at
the correct sibling-list edges, preserve group containment, and refresh the projected pane after
each successful move or visibility toggle. The shared plan owns the edge state and the existing
`ReorderShapeCommand` owns undo/redo; this is a function-first authoring slice with no renderer
calibration claim.

### 2026-07-29 Horizontal Bullet List SmartArt

PowerPoint's common `horizontalBulletList` SmartArt layout was previously classified as a
list but rejected by the live-layout allow-list, so FreeP could display its cached drawing
but could not author or regenerate the layout through the shared editor path. The layout is
now admitted as a live list, exposed through WPF and Avalonia Change Layout and Insert
SmartArt routes, and rendered as a deterministic row-major node grid. Shared layout,
save/reopen, insertion, and host reachability tests cover the route. This is a functional
SmartArt authoring/depth slice; it makes no new pixel-fidelity claim for PowerPoint's native
bullet typography or spacing.

### 2026-07-29 SmartArt data-part preservation during edits

SmartArt node and text-pane edits already regenerated the logical point/connection lists, but the
rewrite rebuilt `dgm:dataModel` from a minimal document and could discard authored root metadata or
extension payloads that FreeP does not model. The rewrite now preserves the existing valid data-model
shell and replaces only `dgm:ptLst` and `dgm:cxnLst`; malformed source data still uses the canonical
generated form. A host package round-trip test verifies edited text plus authored metadata/extensions
survive write/reopen. This is a functional/package-compatibility fix with no renderer calibration claim.

### 2026-07-30 SmartArt diagonal connector cache transforms

The shared live SmartArt layouts already emitted diagonal connector lines with `FlipH`/`FlipV`, but
the native `dsp:drawing` cache writer omitted those transform attributes from each connector's
`a:xfrm`. Editing a bending-process diagram could therefore save the line with the right bounds but
the wrong direction after PowerPoint reopened the package. Cache regeneration now preserves both flip
flags, and a host write/reopen test verifies the two bending-process connector directions survive the
PPTX round trip. This is a functional cache/package fix with no renderer calibration claim.

### 2026-07-30 SmartArt drawing-cache shell preservation

SmartArt data edits regenerated `dsp:drawing` from a minimal document, which could discard
authored cache-root attributes, extension payloads, and non-shape group metadata even when the
new shape list was valid. Cache regeneration now preserves a valid authored drawing shell and
replaces only stale shape elements under `dsp:spTree`; malformed or missing drawing XML still uses
the canonical generated document. A host PPTX write/reopen test verifies authored cache metadata
and extensions survive alongside regenerated edited text. This is a functional package fix with
no renderer calibration claim.

### 2026-07-30 Chart manual-layout target semantics

Chart `c:manualLayout` already preserved its `layoutTarget` token, but the shared planner
resolved both `inner` and `outer` layouts against the containing chart frame. It now resolves
explicit `inner` plot and legend layouts inside their automatic axis/label-aware frame while
retaining the containing-frame fallback for `outer`, omitted, and unknown values. Shared planner
tests cover both plot and legend coordinate frames, and the existing host package test confirms
the authored token remains intact after write/reopen. This is a functional chart-layout semantics
fix with no renderer calibration claim.

### 2026-07-30 Chart clone authored metadata

`SlideCloner.CloneChart` omitted chart surface formatting, manual plot/legend layout, legend overlay,
automatic-title state, vary-colors, and bubble sizing flags. Duplicate/copy workflows could therefore
silently drop authored chart behavior. The clone now carries those fields and deep-copies mutable
`ChartManualLayout` objects. It also retains series smooth-line state, rich series fills, workbook
formula references, and point-level fill/data-label payloads. Host regression coverage verifies the
values and clone independence. The same clone boundary now retains point-label delete state and rich
marker fills as well, together with series trendlines and axis number-format/source-linked state.
This is a functional copy/paste parity fix with no renderer calibration claim.

### 2026-07-28 SmartArt node payload preservation

SmartArt data edits already preserved the data-model root shell, but rebuilding `dgm:pt` nodes
discarded authored point attributes and opaque child payloads such as `dgm:prSet`. Existing nodes
now retain that source payload while the edited `dgm:t` is regenerated from the shared model; new
nodes continue to use the canonical form. Host package coverage verifies the metadata survives
write/reopen alongside changed text. This is a functional SmartArt editing/package fix with no
renderer calibration claim.

### 2026-07-28 SmartArt connection payload preservation

SmartArt hierarchy edits rebuilt `dgm:cxn` elements from only the current parent/child graph,
discarding authored connection IDs and opaque connection metadata. Matched source connections now
retain their payload while the shared model remains authoritative for type, endpoints, and order;
new connections receive collision-free generated IDs. Host coverage verifies the connection payload
survives text edit and PPTX save/reopen. This is a functional SmartArt package/editing fix with no
renderer calibration claim.

### 2026-07-28 Chart extension payload preservation

Chart imports previously ignored `c:chartSpace/c:extLst`, so a save or duplicate operation could
drop compatibility or producer-specific chart extensions even when no modeled chart field changed.
The chart model now retains that extension list verbatim, the writer re-emits it after modeled chart
content, and slide cloning carries it forward. Host coverage verifies read/write/reopen and clone
retention. This is a functional chart package-compatibility fix with no renderer calibration claim.

### 2026-07-28 SmartArt cached-fallback conversion

Convert to Shapes already advertised a cached drawing fallback, but the editing session rejected
SmartArt when its live `dgm:data` part was unavailable. Legacy or preview-backed SmartArt can now
convert its retained fallback shapes through the same undoable replacement and selection route;
live layout remains preferred when available. Focused coverage verifies conversion, selection, and
undo/redo for the fallback-only case. This is a functional authoring fix with no renderer
calibration claim.

### 2026-07-28 SmartArt cached native style/color editing

SmartArt Quick Style and Change Colors edits were unnecessarily blocked when the live `dgm:data`
model was unavailable, even though the package still retained editable native style/color parts
and a cached drawing. Those two package-owned edits now commit through the shared undo path while
retaining the cached fallback; layout and node edits continue to require live data and fresh cache
regeneration. Focused coverage verifies Quick Style and Change Colors mutation, metadata/part
updates, and undo/redo in the cached-only case. This is a functional/package-authoring fix with no
renderer calibration claim.

### 2026-07-28 chart style authoring

Chart style IDs were already read, preserved in the model, and consumed by the renderer, but the
shared Chart Options workflow did not expose them and the chart writer omitted `c:style` on newly
written chart parts. FreeP now exposes the PowerPoint style-ID gallery (including preservation of
unknown imported IDs), applies the choice as one undoable display-options edit, and writes the
authoritative `c:style` token so save/reopen retains it. WPF and Avalonia use the same planner and
dialog route. This is a functional chart-design and package round-trip fix with no new raster
calibration claim.

### 2026-07-28 media playback loop semantics

`MediaPlaybackSource` already carried PowerPoint's loop intent for embedded and linked media, but
the LibVLC session dropped that flag when opening a source and raised `Ended` after the first pass.
The backend now retains the source loop state and restarts the native player at end-of-stream while
the session is alive; explicit stop/dispose clears the loop state so teardown cannot resurrect a
player. The loop decision is covered independently from native-library availability. This is a
functional playback fix; encoded media and device-specific LibVLC behavior remain separate.

### 2026-07-28 transition sound loop routing

The `TransitionSound.Loop` token was already retained by the PPTX reader/writer and model, but
host playback did not forward it: Avalonia created a non-looping media source, while WPF deleted
the temporary audio file after the first `MediaEnded` event. Both hosts now honor the source token;
Avalonia passes it through the shared LibVLC source factory, and WPF restarts the player at the
same file until the transition sound is replaced or the slideshow closes. Focused shared,
Avalonia, and WPF media/transition coverage passes. This is functional presentation playback
parity; it makes no encoded-audio or device-specific fidelity claim.

### 2026-07-28 SmartArt text-body payload preservation

SmartArt node edits already preserved diagram point and connection metadata, but rebuilding a
node's `dgm:t` replaced authored DrawingML text-body properties with a bare body/paragraph/run.
Text edits now retain the native `bodyPr`, `lstStyle`, paragraph properties, run properties, and
end-paragraph run properties while FreeP's shared node text remains authoritative. Focused host
SmartArt coverage passes 192/192 and presentation SmartArt coverage passes 280/280. This is a
functional SmartArt package-authoring fix with no renderer calibration claim.

### 2026-07-28 chart minor-gridline authoring

Chart Axis Options already carried minor-unit and minor-tick semantics, but the authored
`c:minorGridlines` token was dropped and neither host could create it. FreeP now preserves
the token through the chart model, PPTX reader/writer, clone path, and one undoable axis
edit; both WPF and Avalonia expose the toggle, and both renderers consume the shared minor
gridline plan. The default remains off, so existing charts retain their prior package and
raster behavior. Focused presentation, WPF, and Avalonia chart/dialog coverage passes.

### 2026-07-28 SmartArt Circle Accent Timeline authoring

PowerPoint's common `circleAccentTimeline` SmartArt layout was not in FreeP's live-layout
catalog, so insertion and regeneration could fall back to a cached drawing even though the
shared Process model and deterministic timeline layout path were available. FreeP now admits
the native layout URI as a live Process layout, exposes it through the existing WPF and Avalonia
SmartArt insertion gallery, and preserves it through the normal package round trip. The current
implementation intentionally reuses the shared timeline regeneration path; this closes the
authoring/package reachability gap without making a new native PowerPoint raster-fidelity claim.

### 2026-07-28 SmartArt Vertical Chevron List authoring

PowerPoint documents Vertical Chevron List as a common list layout for sequential steps and
progression. FreeP now preserves the native `verticalChevronList` layout identity, admits it to
the live list-family planner, exposes it through both host Change Layout and Insert SmartArt
routes, and regenerates ordered chevron nodes through the shared geometry path. Package reader,
layout, insertion, and host registration tests cover the route. This is a functional SmartArt
authoring and regeneration slice; it does not claim native PowerPoint typography or raster fidelity.

### 2026-07-28 SmartArt Phased Process authoring

PowerPoint's common `phasedProcess` layout was missing from FreeP's live SmartArt authoring
catalog, so insertion and Change Layout could not reach it even though the shared Process model
and live regeneration route were available. FreeP now exposes the native layout URI through both
host command registries and the Change Layout ribbon, admits it as a live Process layout, and
preserves it through the normal package round trip. The current implementation deliberately
reuses the existing bounded process-family geometry; this closes the functional/package
reachability gap without making a new native PowerPoint raster-fidelity claim.

### 2026-07-28 PowerPoint COM corpus validation

The local machine now resolves `PowerPoint.Application`, and `FreeP.RenderCompare`
has a repeatable `--powerpoint-corpus-validate` mode that opens each selected deck,
exports every slide through PowerPoint, and optionally compares the resulting PNG
hashes with the stored reference set. The three historical repair-dialog decks
(`10-motionpath`, `14-smartart-live`, and `21-comments-notes`) all passed: 3/3
decks opened and exported, 7/7 slides matched their references, and the command
returned exit code 0. PDF/print/handout/notes/video baselines and full WPF/Avalonia
visual comparison remain separate open evidence surfaces.

### 2026-07-28 ordinary-shape outer-shadow authoring

Shape effects were already preserved in the PPTX model and consumed by both renderers, but
ordinary shape authoring had no shared command route for creating or removing an outer shadow.
FreeP now exposes None, Subtle, and Offset shadow presets through the shared undoable command bus,
with WPF and Avalonia registrations and ribbon labels. The command changes only outer-shadow
fields, preserving other effect layers such as glow and soft edge. Focused shared command/planner
coverage passes 3/3, the WPF ribbon route passes 1/1, and the Avalonia Release host build is clean.
This closes a functional authoring gap; the preset values are intentionally not a new
PowerPoint-raster calibration claim.

### 2026-07-28 imported hierarchy3 SmartArt cache dispatch

Imported `hierarchy3` SmartArt was being admitted to the bounded live layout planner even
when the package carried PowerPoint's native `dsp:drawing` cache. On the four-slide
`14-smartart-live` COM corpus, that made the hierarchy slide structurally wrong and produced
an approximately 11.7% slide delta in both renderers. The reader now keeps the native cache
authoritative for imported hierarchy3 while retaining the parsed data for editing; authoring
paths can re-enable live layout after regenerating the cache. Fresh 1280x720 PowerPoint
comparison improved WPF from 3.6979% to 1.0508% average and Avalonia from 3.7058% to
1.0729%; the affected slide is 1.1567% WPF and 1.2094% Avalonia. Focused SmartArt/package
coverage passes 291/291, with the consuming RenderCompare Release build clean.

### 2026-07-29 accessibility video-caption command contract

The accessibility checker already opened the shared media-caption authoring pane in both
hosts, but its `Video captions missing` finding exposed no command ID and was therefore not
addressable by automation or other workflow clients. The finding now publishes the shared
`freep.media-captions.open` command, while WPF and Avalonia retain the existing pane route.
Focused planner and host tests cover the command contract and caption-pane behavior.

### 2026-07-28 native presenter ink slide replay

PowerPoint-native presenter ink now opens and round-trips as a standard Ink Content Part, but
the regular slide compositor previously treated `SlideShapeKind.Ink` as an opaque preserved-object
fallback. FreeP now parses the preserved InkML trace/brush payload into renderer-neutral stroke
operations for both FreeP-generated absolute slide coordinates and native frame-local coordinates
with common physical units. The original InkML and OPC relationships remain untouched for save/reopen;
malformed or unsupported payloads retain the existing fallback behavior. Focused presentation tests
cover generated replay, native unit conversion, and compositor emission. This is a functional
presentation-rendering slice; a device-captured PowerPoint raster baseline remains separate.

### 2026-07-28 independent chart axis-title formatting

PowerPoint permits category, value, and secondary-value axis titles to carry their own font
family, size, bold/italic state, and color independently of chart-wide text defaults. FreeP now
preserves that title formatting through the chart model and PPTX reader/writer, exposes it through
the shared WPF and Avalonia axis-options workflow, restores it through undo, and feeds it into the
renderer-neutral plan consumed by both hosts. Unspecified axis-title styles retain the existing
renderer defaults. This closes a functional chart-authoring/package gap; no new visual-fidelity
claim is made for raster matching.

### 2026-07-28 SmartArt duplicate payload isolation

SmartArt was described as a deep-cloned editable payload, but duplicate/undo snapshots still
shared node image objects and raw diagram/relationship byte arrays with the source slide. A
subsequent edit could therefore mutate the source package state through an alias. SmartArt
cloning now copies node image bytes and diagram-part/relationship payloads, with a regression
that mutates the clone and proves the source remains unchanged. Presentation SmartArt,
WPF-host SmartArt, and Avalonia SmartArt coverage remain green; this is a functional
duplicate/undo/package-isolation fix with no new renderer calibration claim.

### 2026-07-28 OLE and preserved-object duplicate payload isolation

OLE and preserved modern-object shapes had the same duplicate/undo aliasing risk: their
embedded, Ink/3D/zoom, and relationship byte arrays were copied into a new carrier but still
pointed at the source arrays. Cloning now copies those package payloads before a duplicate or
undo snapshot is exposed, and a regression mutates cloned OLE, preserved-part, and part-rels
bytes while proving the source remains unchanged. This is a functional package/editing fix;
no new renderer calibration claim is made.

### 2026-07-28 Name and Title Organization Chart

PowerPoint's common `nameAndTitleOrgChart` SmartArt layout was classified as a hierarchy by
the reader but was missing from the live-layout allow-list, authoring preset, and both host
Change Layout command registries. FreeP now preserves the native layout identity, admits it
through the existing organization-chart tree plan, exposes it in WPF and Avalonia, and covers
reader/live support, package round-trip, host reachability, and renderer-neutral tree output.
This reuses the existing hierarchy geometry and makes no new native PowerPoint raster claim.

### 2026-07-28 chart-area fill transparency

PowerPoint chart and plot areas can retain a solid fill while applying independent fill
transparency. FreeP already preserved the corresponding DrawingML alpha in `ThemeAwareColor`,
but the shared Chart Area workflow exposed only color, no-fill, outline color, and outline width.
The planner and both WPF/Avalonia dialogs now expose a 0-100% fill-transparency value, convert it
to the existing alpha field, and keep the change inside the existing undoable chart-area command.
Focused planner, WPF, Avalonia, and package round-trip coverage verifies color/alpha retention.
This is a functional chart-authoring/package slice; it makes no new PowerPoint raster-fidelity claim.

### 2026-07-29 SmartArt Continuous Picture List authoring

PowerPoint's common `continuousPictureList` SmartArt layout was missing from FreeP's live
layout allow-list, so imported diagrams fell back to their cached drawing and neither host
could reach the layout through Change Layout or Insert SmartArt. FreeP now preserves the
native layout identity, requires the same one-picture-per-node payload contract as the other
picture layouts, dispatches the shared horizontal picture/caption planner, and exposes the
operation in both WPF and Avalonia. Reader, package round-trip, live layout, insertion, and
host registration tests cover the route. The implementation intentionally reuses the existing
picture-lineup geometry; this closes the functional/package reachability gap without making a
new native PowerPoint raster-fidelity claim.

### 2026-07-30 SmartArt picture removal

The SmartArt text pane could replace a node picture but could not remove it and restore the
authored picture placeholder. FreeP now exposes a shared clear-picture edit through WPF and
Avalonia, records it through the existing undo bus, rewrites the diagram data, regenerates the
drawing cache, and prunes obsolete image relationships/media when the final picture is removed.
Focused package, host undo/reopen, and Avalonia text-pane coverage verify one-picture and
last-picture removal paths. This is a functional SmartArt editing/package fix with no new
PowerPoint raster-fidelity claim.

### 2026-07-30 SmartArt target-list node-count recovery

The shared `targetList` geometry path previously rejected diagrams with more than five
parsed nodes, so a valid larger target list silently reverted to its cached drawing even
though the reader, insertion route, and both host command surfaces already supported the
layout identity. The planner now emits one renderer-neutral concentric ellipse per parsed
node without that artificial cutoff. Presentation and shared compositor regressions cover
six- and twelve-node diagrams; exact PowerPoint ring clipping, label offsets, effects, and
authoritative raster baselines remain separate visual work.

### 2026-07-29 SmartArt radial-list node-count recovery

The dedicated `radialList` authoring path previously rejected diagrams with more
than eight items, causing valid larger lists to fall back to their cached drawing
despite the existing reader admission and shared WPF/Avalonia command routes. The
planner now emits one live rounded item box and one center spoke per parsed node;
nine- and sixteen-item planner coverage plus a nine-item shared compositor fixture
guard the behavior. Exact PowerPoint dense-list sizing, curved routing, effects,
and authoritative raster baselines remain separate visual work.

### 2026-07-29 SmartArt titled-matrix node-count recovery

The shared `titledMatrix` planner already derives its body rows from the parsed node
count, but an explicit nine-node guard caused larger valid matrices to fall back to
their cached drawing. The guard is removed and ten- and sixteen-node planner coverage
plus a ten-node shared compositor fixture prove that the title band and every body
cell remain live in both hosts. Exact PowerPoint title-band metrics and richer matrix
styling remain separate visual/depth work.

### 2026-07-30 SmartArt layout recovery without a native layout part

PowerPoint can expose Change Layout for a valid SmartArt package whose data and drawing cache
survive but whose `diagramLayout` part is absent. FreeP previously rejected that operation with
"no native layout definition," leaving the package editable only through the cached view. The
shared authoring planner now synthesizes a standards-shaped `diagramLayout` part when a non-empty
native data part exists, adds the `lo` diagram relationship, and then applies the selected layout
identity. Packages without native data still fail explicitly; existing layout parts remain
authoritative. Planner, package-write, undo/redo, WPF host, and Avalonia host coverage passed;
this is a functional/package recovery slice with no new PowerPoint raster-fidelity claim.

### 2026-07-30 SmartArt picture-layout placeholders

PowerPoint allows an existing SmartArt graphic to switch to a picture layout before every node
has an image assigned. FreeP's shared layout engine already emitted the authored "Add picture"
placeholder for missing node media, but the authoring planner rejected the change unless every
node already carried image bytes. Existing SmartArt layout changes now require only a non-empty
data model; mixed real images and placeholders flow through normal cache regeneration and undo.
New picture-SmartArt insertion now creates the same placeholder-only data/cache state when no
image is supplied; a payload remains supported for callers that already have media. Planner,
package/cache refresh, undo/redo, WPF host, and Avalonia host coverage verify both routes; this
is a functional/package editing slice with no new PowerPoint raster-fidelity claim.

### 2026-07-30 Empty picture-SmartArt insertion

PowerPoint can insert a picture SmartArt layout before any source image is selected, leaving
editable "Add picture" slots in the graphic. FreeP previously made every picture-layout
insertion command stop for a file picker, so the normal empty authoring state was unreachable.
The shared insertion planner now accepts a missing picture payload, seeds the native drawing
cache with the shared placeholder geometry, and keeps the existing image-payload path intact.
Both WPF and Avalonia galleries use the common undoable insertion command; replacement of an
individual placeholder continues through the SmartArt text pane. Presentation package/cache,
undo/redo, WPF host, and Avalonia host tests cover the behavior, with no new raster-fidelity
claim.

### 2026-07-30 SmartArt drawing-cache recovery without a native drawing part

PowerPoint can retain a valid SmartArt data/layout package while its `diagramDrawing` cache is
missing or stale. FreeP's edit path previously treated the missing cache as a hard failure, and
picture-cache synchronization assumed that an image relationship already existed. The shared
SmartArt editing planner now creates the sibling drawing part plus the data-part drawing
relationship, initializes its package relationship document, and allocates fresh media
relationships when picture nodes have no prior cache relationships. The recovered cache survives
undo/redo and PPTX write/reopen; focused planner and WPF package tests cover plain and
picture-backed recovery. This is a functional/package recovery slice with no new
PowerPoint raster-fidelity claim.
