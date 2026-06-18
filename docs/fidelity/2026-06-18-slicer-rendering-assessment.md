# Slicer rendering assessment

Date: 2026-06-18
Branch: `investigate/slicer-rendering` (base: `origin/fix/drawing-subcell-offsets`)
Scope: investigation only — can FreeX render Excel SLICER visuals (the filter-button boxes for tables/pivots)?

## TL;DR

FreeX already has **most of a slicer rendering pipeline**: it parses `xl/slicers/*` + `xl/slicerCaches/*` into a `SlicerModel`, preserves slicers verbatim on round-trip, and the **WPF `GridView` already draws a faithful native slicer box** (header + tile buttons) via `DrawNativeSlicerControl`. There is even a portable, framework-free `SlicerLayoutBuilder` with header/tile geometry.

Despite that, slicers render in **neither** the headless compare tool **nor**, in practice, the live app, for two independent reasons:

1. **The drawing-anchor reader never finds slicer anchors in real Excel files.** `XlsxSlicerTimelineMetadataReader.ReadDrawingMetadata` looks for a *slicer/timeline relationship type* inside `xl/drawings/_rels/drawingN.xml.rels`. Excel does **not** emit such a relationship — the slicer drawing lives in an `mc:AlternateContent` → `mc:Choice` → `graphicFrame` whose link to the slicer is **by name** (`<sle:slicer name="Category"/>`), with an empty/absent drawing rels. So `SlicerModel.DrawingAnchor` stays `null`.

2. **Even with an anchor, the visibility gate filters everything out.** `SlicerTimelinePlanner.GetNativeVisualSlicers` only surfaces a slicer when `slicer.DrawingAnchor != null` **and** `slicer.SourcePivotTableName` matches a pivot table **on the active sheet**. This excludes **all table slicers** (which have no `SourcePivotTableName`), and excludes pivot slicers whose pivot is on another sheet.

3. **The headless tool doesn't even wire the property.** `tools/FreeX.SheetGridImageCompare/Program.cs` sets `Charts/Pictures/DrawingShapes/TextBoxes/FormControls/...` on the `GridView` but never sets `NativeSlicers`/`NativeTimelines`. So the compare renders can never show a slicer regardless of the above.

Net: confirmed empirically — rendering file 03's "Tasks" sheet shows the table and AutoFilter arrows but **no slicer boxes** in the G:I anchor region.

## Evidence

### Driver files
- `test-corpus/public/contextures/03_table-chart-slicers_task-tracker.xlsx` — two **table slicers** ("Category", "Who") on sheet "Tasks" (sheet3). `slicerCache1/2.xml` carry `<x15:tableSlicerCache tableId="1" column="5|6"/>`, **no `selectedItem`**, **no item cache**. Drawing `drawing3.xml` has `mc:AlternateContent`/`mc:Choice Requires="sle15"` with two `graphicFrame`s anchored ~G1:I5; `xl/drawings/_rels/drawing3.xml.rels` is empty. The slicer is wired from `sheet3.xml`'s `<x14:slicerList><x14:slicer r:id=.../>` ext + `sheet3.xml.rels → slicers/slicer1.xml`.
- `test-corpus/public/contextures/02_pivots-slicers_region-sales.xlsm` — one **pivot slicer** ("Market"); `slicerCache` references `<pivotTable>`. Drawing uses `mc:AlternateContent`/`Requires="a14"` + `<sle:slicer>`; drawing rels has **no** slicer relationship.
- `test-corpus/public/contextures/07_advanced-filter_multi-sheet.xlsm` — **no slicer parts** (task note was off; only 02 and 03 have slicers).

### Render proof
Built `tools/FreeX.SheetGridImageCompare` and rendered file 03. Sheet "Tasks" PNG shows the task table + header AutoFilter dropdowns but **zero slicer visuals** in the slicer anchor area. (Generated under `%TEMP%/03tablechartslicerstasktracker-gridview/freex_03_Tasks.png`.)

## Current state of the code

What already exists (and works):
- **Model**: `FreeX.Core.Model/SlicerModel.cs` — `Name`, `Caption`, `CacheName`, `SourcePivotTableName`, `SourceFieldName`, `StyleName`, `SelectedItems`, `PackagePart`, `DrawingAnchor` (`DrawingAnchorRange`), `DrawingShapeName`.
- **Load**: `XlsxFileAdapter.cs:118` calls `XlsxSlicerTimelineMetadataReader.Load`; `:254-255` pushes results into `Workbook.Slicers`. Reader parses `xl/slicers/*` (name/caption/cache/style) and `xl/slicerCaches/*` (`name`, `sourceName`, `pivotTable`, `selectedItem`s).
- **Round-trip**: slicer parts are preserved verbatim via the source-package snapshot (`XlsxFileAdapter.SourcePackageSnapshot.cs`, `XlsxFileAdapter.SavePostProcessing.cs`, `XlsxPackageMetadataMerger.cs`). Slicers survive open→save even though they don't render.
- **Layout (portable)**: `FreeX.App.Presentation/SlicerTimeline/SlicerLayoutModel.cs` — `SlicerLayoutBuilder.Build/HitTest/Toggle` produces header band (≤22px), tile grid (26px top inset, 14–22px tiles, 4-tile preview cap), selected/unselected flags. Framework-free; ready for any renderer.
- **WPF render**: `FreeX.App.UI/GridView.DrawingObjects.cs` — `RenderNativeSlicerTimelineControls` + `DrawNativeSlicerControl` already draw a faithful slicer box (blue header, body, tiles, selected-tile highlight) keyed off `NativeSlicers`. There's even a placeholder path in `RenderObjectPlaceholders`.
- **Live wiring**: `FreeX.App.Host/MainWindow.Viewport.cs:438-442` sets `SheetGrid.NativeSlicers = SlicerTimelinePlanner.GetNativeVisualFilters(...).Slicers`.

Where the chain breaks (the gap):
- **Gap A — anchor parsing.** `XlsxSlicerTimelineMetadataReader.ReadDrawingMetadata` (lines ~178-222) only picks up anchors when a `drawingN.xml.rels` declares a relationship whose `Type` contains "slicer"/"timeline". Real Excel files don't carry that; the slicer lives in `mc:AlternateContent` and the anchor↔slicer association is by `<xdr:cNvPr name>` / `<a:graphicData>` `sle:slicer name`. Result: `DrawingAnchor == null` for every real-world slicer here.
- **Gap B — visibility gate too narrow.** `SlicerTimelinePlanner.GetNativeVisualSlicers` requires a pivot-table match on the active sheet, excluding table slicers entirely and cross-sheet pivot slicers.
- **Gap C — headless tool unwired.** `SheetGridImageCompare/Program.cs` never assigns `NativeSlicers`/`NativeTimelines` to the `GridView`.
- **Gap D — no available-items source for table slicers.** Table slicers carry **no item cache** in `slicerCache.xml`; the item list (and thus tile captions) must come from the **referenced table column** (`tableSlicerCache tableId/column`). `DrawNativeSlicerControl` currently previews `SelectedItems` only, or a single "All" tile when nothing is selected — for an unfiltered table slicer that yields a single "field name" tile, not the real item buttons Excel shows.

## Scoped implementation plan (basic faithful slicer box)

Goal: a slicer box matching Excel's default style — caption header + a vertical list of item buttons, each shown selected (highlighted) or unselected, anchored at the slicer's drawing position. Compare-tool and live-app parity.

Parts to parse (extend `XlsxSlicerTimelineMetadataReader`):
1. **AlternateContent-aware anchor resolution.** In `ReadDrawingMetadata`, when no slicer relationship exists, scan each drawing's `twoCellAnchor`s for an `mc:AlternateContent` whose `mc:Choice`/`graphicFrame` contains an `sle:slicer` (or `sle15:slicer`) element, and key the anchor by the slicer **name** (`graphicFrame`'s `cNvPr name` == slicer `name`). Match those names back to `SlicerModel.Name` instead of by package-part index. (This also fixes the existing index-order fragility.)
2. **Table-slicer item source.** Read `<x15:tableSlicerCache tableId column>` from the slicer cache. Resolve `tableId` → the structured table → that 1-based `column` → the distinct cell values in the table body, to produce the available-items list. (FreeX already models structured tables; this is a lookup, not new parsing of table data.)
3. **Pivot-slicer item source.** For pivot slicers, the cached items live in the slicer cache's `olap`/`tabular` `<items>` (or are derivable from the pivot cache field). Reuse existing pivot-cache field values where available; otherwise fall back to `SelectedItems`.

Model additions:
- Add `IReadOnlyList<string> AvailableItems` (or a resolver) and table-link fields (`TableId`, `ColumnIndex`) to `SlicerModel`, OR compute available items at viewport-build time (preferred — keeps the model lean and mirrors how `FormControlListResolver`/`SparklineValuePlanner` resolve live values just before render).

Visibility / wiring:
- Relax `GetNativeVisualSlicers` to surface **table slicers** (anchor present, source table on the active sheet) in addition to pivot slicers. Keep the cross-sheet exclusion sane (a slicer renders on the sheet that hosts its drawing anchor, which is already implied by the per-sheet drawing).
- Set `NativeSlicers`/`NativeTimelines` on the `GridView` in `SheetGridImageCompare/Program.cs` (mirror `MainWindow.Viewport.cs`), and resolve available items the same way the live app would.

Rendering:
- `DrawNativeSlicerControl` already does the box; extend it to draw item tiles from the resolved **available items** (selected → green/highlight tile, unselected → muted), not just `SelectedItems`. Honor `columnCount` from `slicer1.xml` (file 03's "Category" slicer is `columnCount="2"`) for multi-column tile layout — `SlicerLayoutBuilder` would need a multi-column variant (currently single-column). Default Excel slicer style is close to the existing colors; exact `SlicerStyleLight*` theming can be deferred.

Hook points (compare with charts/form-controls):
- Charts render via `RenderCharts` keyed off `GridView.Charts`; form controls via `GridView.FormControls` with `FormControlListResolver.PopulateSelectedText` resolving live state at viewport build. Slicers should follow the **form-control pattern**: resolve available/selected items just before render, set `NativeSlicers`, and let `RenderNativeSlicerTimelineControls` draw.

## Effort estimate

**Medium.** The renderer and layout math already exist; the work is concentrated in (a) AlternateContent anchor parsing, (b) resolving the available-items list (table-column lookup + pivot-cache items), (c) relaxing the visibility gate, (d) wiring the headless tool, and (e) multi-column tile layout. No new rendering subsystem is needed. Rough split: anchor parsing ~S, item resolution ~M (table + pivot paths), gate/wiring ~S, multi-column layout + tile-from-available-items render ~S–M, tests ~M.

A "tiny PoC" was **not** done here because the smallest honest slice still touches the metadata reader (AlternateContent) + the visibility gate + the headless tool wiring + item resolution — i.e. essentially Gaps A–D together. Doing only one leaves slicers still invisible, so a PoC would be misleading. This stays assessment-only by design.

## Risks / gotchas

- **mc:AlternateContent fallback.** Must read the `mc:Choice` (the real slicer), not the `mc:Fallback` (which in file 03 is literally the text *"This shape represents a table slicer. Table slicers are not supported in this version of Excel."*). Rendering the fallback shape would be a visible regression.
- **x14 vs x15 vs sle/sle15 namespaces.** Slicer markup spans `.../2009/9/main` (slicer defs), `x14`/`x15` (worksheet `slicerList`, `tableSlicerCache`), and `sle`/`sle15` (`.../drawing/2010/slicer`, `.../drawing/2012/slicer`) in the drawing. Parsing must be namespace-tolerant (the current reader is mostly local-name based, which helps).
- **Table vs pivot slicers diverge at the item-source.** Table slicers → items from the table column (no cache). Pivot slicers → items from the slicer/pivot cache. Two code paths.
- **Multi-column layout.** `columnCount > 1` (file 03's "Category") needs a grid, not a single column. `SlicerLayoutBuilder` is single-column today; a faithful render needs the column split or it will look wrong.
- **Anchor↔slicer association by name.** Multiple slicers per sheet (file 03 has two) means the by-index anchor mapping is wrong; must match by `cNvPr name`/`sle:slicer name`.
- **Selection/`All` semantics.** Empty `SelectedItems` means "no filter / all selected" in Excel; the render should show all tiles as selected, not a single "All" tile. The live preview cap (4 tiles) is fine for a thumbnail but not for a faithful full-box render.
- **Style fidelity (`SlicerStyleLight6` etc.).** Deferring exact theme styling is reasonable for a "basic faithful" box; default colors get most of the way.

## Recommendation

**Worth building — but as a deliberate Medium task, not a quick win.** The expensive parts (model, round-trip, layout math, WPF box renderer, live wiring) are already in place and currently dead-ended by Gaps A–D. The remaining work is well-scoped and high-value for fidelity (slicers are common in real workbooks and currently render as blank space). Suggested sequencing if/when picked up:

1. Fix anchor parsing (AlternateContent + name match) — unblocks `DrawingAnchor`.
2. Wire `NativeSlicers` in the headless compare tool — makes results observable.
3. Relax the visibility gate to include table slicers + resolve available items (table-column lookup first, pivot-cache second).
4. Extend the tile render to draw available-items with selected/unselected state; add multi-column layout.
5. Defer exact `SlicerStyle*` theming.

If parity bandwidth is tight right now, **defer** is defensible — slicers degrade gracefully (blank region, no crash, round-trip preserved) — but the groundwork already paid for makes this a comparatively cheap fidelity win.
