# Dedup Backlog - closed historical inventory

**Historical inventory, closed 2026-08-09.** Every practical item in this inventory and the later whole-codebase audits has either
been extracted, adopted, or recorded as an intentional renderer/domain boundary. Current evidence is generated
in `dedup-residual-metrics.md`; the latest classification and verification record is
`DEDUP-CERTIFICATION-2026-08-23.md`. This file is retained to explain the provenance of the earlier candidates.

Verified duplication candidates, ranked, each tagged with its **unlock condition** (which session must
settle before extraction is safe). Built 2026-06-25 from a read-only cross-app audit while the three
Microsoft-parity sessions (FreeX↔Excel, FreeW↔Word, FreeP↔PowerPoint) were active.

The inventory was originally staged because parity work made its source areas hot. Those ownership gates later
cleared and the campaigns executed the candidates. Dates and file references below are historical and should
not be interpreted as current open work.

All file:line references below were opened/grepped during the audit. Re-verify before acting — the parity
sessions move these files.

---

## A. Already shared — do NOT chase (confirmed)

The audit confirmed these are already consolidated in `Free.Shared.*`; remaining per-app code is genuine
per-shell glue, not duplication:

- **Recent files** — `Free.Shared.AppServices.RecentFilesStore` + `FileCommandWorkflow` + `Free.Shared.Shell.BackstageRecentFileListPlanner`; caps in `ApplicationOptionsSupport`. (Per-app `MaxRecentDocuments` 6 vs 8 is intentional UI.)
- **Autosave snapshot substrate** — `Free.Shared.AppServices.AutosaveSnapshotStore` +
  `AutosaveSnapshotCoordinator` remain shared. The later FreeP/FreeW session and recovery layers accumulated a
  second copy and are reopened in `DEDUP-CERTIFICATION-2026-08-22.md`; native scheduling and editor projection
  remain host bindings.
- **Status bar** — `Free.Shared.AppServices.StatusBarViewModel`/`StatusBarDisplayModelBuilder` + `Free.Shared.Ribbon.Wpf.SisterAppStatusBarChrome`.
- **User-message service** — `Free.Shared.AppServices.IUserMessageService` + `Free.Shared.Shell.Wpf.WpfUserMessageService`/`DialogMessageHelper`. FreeX, FreeW, and FreeP file-command hosts now accept the service through constructor injection; the remaining `HeadlessMessageBox.Handler` sites are WPF dialog/test helper seams, not file-command lifecycle duplication.
- **Ribbon command registry** — `Free.Shared.Ribbon.Commands.RibbonCommandRegistry` + WPF/Avalonia renderers. Per-app `BuildRegistry` is genuine command wiring.

---

## B. High-value gated targets (app code)

### B1. DONE / monitor - Shared OPC path / rels / content-type helpers  ·  apps: FreeP + FreeX + FreeW
The shared destination exists on `main`: `Free.Shared.Opc.OpcPathHelper`, `OpcMediaTypes`, `OpcRelationships`, and `OpcXml` now cover package path normalization, relationship-part paths, content-type maps, relationship document creation/loading, and secure XML loading.

2026-07-01 audit: do not create a second helper layer. Current app-local call sites are either already routed through the shared APIs or are thin compatibility wrappers / package-specific semantics. Keep XLSX/DOCX/PPTX differences local where they encode real package behavior.

### B2. DONE / preservation-only decision - CoreDocumentProperties model + core.xml/app.xml read-write  ·  apps: all three
Current audit: the core-properties destination is now mostly landed on `main`. `Free.Shared.Opc`
owns `DocumentProperties`, `CoreDocumentProperties`, and core-property read/write helpers; FreeW and
FreeP root models use the shared mutable model; FreeW/FreeP package readers and writers use the
shared reader/writer; and FreeX's `XlsxDocumentPropertiesPreserver` uses the shared stable-property
preservation helper for core/app package metadata.

2026-07-01 decision: `docProps/app.xml` remains preservation-only for now. `docProps/custom.xml`
is intentionally format-specific where it carries FreeW watermark / Mark-as-Final data or other
app-owned metadata. Do not recreate core-property helpers or force an app-neutral extended-properties
model without a concrete product requirement and IO tests.

### B3. DONE 2026-06-30 - Free.Shared.Drawing migration (FreeX originals deleted)
Current `main` now consumes the shared drawing substrate:
- `ShapeGeometryBuilder`, `ShapeGeometry`, `ShapeSegment`, and `ShapeContour` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.App.Presentation/Shapes` no longer carries shape-geometry copies.
- `DrawingShapeKind` and `DrawingShapeKindSupport` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.Core.Model` keeps only FreeX-specific shape model/effect/text metadata.
- `LayoutPoint` and `LayoutRect` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.App.Presentation/Charts/Geometry.cs` keeps only chart-specific `PlotRect` and `LayoutArc`.

Focused guards now cover the migration: `DrawingShapeSharedDrawingTests`, `ShapeGeometryBuilderTests.PresentationShapeGeometrySources_RemainNeutralized`, and `ChartGeometrySharedDrawingTests`.

### B4. DONE / semantic boundary - Cross-app color model + EMU units  ·  apps: FreeP + FreeX + FreeW
- EMU constants: **DONE 2026-06-30 for the FreeP Core.IO/App.Presentation unit half**. FreeP package IO routes point/inch defaults through `Free.Shared.Opc.DrawingMlUnits`, and FreeP presentation geometry/planner code routes inch and 96-DPI DIP constants through `Free.Shared.Drawing.DrawingMlCoordinateUnits`.
- DrawingML RGB/theme helpers: **DONE 2026-07-01**. `Free.Shared.Drawing.DrawingMlRgbColor`, `DrawingMlColorTransform`, and `DrawingMlThemeColorSlotMapper` are consumed by FreeX and FreeP for strict DrawingML `srgbClr` / theme-slot paths; `XlsxDrawingColorTintSourceGuardTests` and FreeP theme-color tests guard against local tint/RGB mapper drift.
- Preset geometry map: **DONE 2026-07-01**. `Free.Shared.Drawing.DrawingMlPresetGeometryMap` now owns canonical preset names and aliases for FreeX/FreeP readers and writers.
- FreeW color/hex normalization: **CLOSED 2026-07-01 as app/format-specific**. DOCX WordprocessingML has `auto`, named highlight tokens, watermark UI shorthand/alpha text, accessibility fallback, and theme palette contracts that are not strict DrawingML RGB parsing. `ColorHexNormalizationBoundaryTests`, `DocxColorHexNormalizationBoundaryTests`, and `ColorHexDialogBoundaryTests` guard that boundary.

---

## C. Intra-app cleanups — flag to the owning session (not cross-app)

- **C1. DONE 2026-06-30 - FreeP HLS color math**: current FreeP readers/resolvers both call `FreeP.Core.Model.ThemeColorTransform`, which adapts to `Free.Shared.Drawing.DrawingMlColorTransform`; `ThemeColorTransformTests` guards against local `RgbToHls`/`HlsToRgb`/private tint/shade copies returning.
- **C2. DONE 2026-07-01 - FreeX IO `ApplyTint` repeated**: current FreeX theme and DrawingML color paths route through `Free.Shared.Drawing.DrawingMlColorTransform`; `XlsxDrawingColorTintSourceGuardTests` rejects local `ApplyTint` helpers returning to chart/theme/drawing writers.
- **C3. DONE 2026-06-30 - FreeP inline EMU units**: owned Core.IO/App.Presentation call sites now use `DrawingMlUnits`/`DrawingMlCoordinateUnits` with a focused source guard. Deferred by design: `SlideSizeDialogPlanner.EmuPerCm` remains local because the shared DrawingML helper has no centimeter API and the value is UI-unit conversion, not an OOXML primitive; `SlideCanvas`/`ChartRenderPlanner` renderer files were left untouched for the parallel chart-rendering lane.
- **C4. DONE 2026-06-30 - FreeP XML package loading hardened**: current `PptxPackageReader`/`PptxChartReader` product XML loads use `Free.Shared.Opc.OpcXml`, which flows through `SecureXmlReaderSettings`; `PptxPackageReaderSourceTests` covers package and SmartArt/DSP XML loading plus a DTD rejection scenario.
- **C5. DONE 2026-07-01 - FreeX drawing/textbox interaction tail**: `TextBoxInlineEditPlanner` now owns inline text-box key, commit, and lost-focus policy; `SelectionPanePlanner.PlanKeyboardAction` owns selection-pane keyboard policy. WPF remains a renderer/event adapter. Guarded by `TextBoxInlineEditPlannerTests`, `SelectionPanePlannerTests`, and drawing source hygiene tests.

---

## D. Dev-tooling dedup — `tools/FreeX.*` fidelity/compare harnesses  ·  confidence: HIGH (real dup)
Large duplication across the FreeX fidelity tools. CAUTION: these are the parity sessions' measurement
instruments and live in `FreeX.slnx`, so only consolidate files that are COLD (>24h since last commit) and
keep every move **behavior-preserving / verbatim** (a changed tolerance silently corrupts parity numbers).

- ✅ **DONE 2026-06-26 (`1d34ffa79`)** — Value-equivalence helpers (`ValuesMatch`/`TryNumeric`/`NumbersMatch`/`ScalarStr`/`ColToLetter`/`DisplayString`) → new portable `tools/FreeX.ToolsShared/FidelityValueCompare.cs`. Repointed `FreeX.SheetFidelity`, `FreeX.FormatFidelity`; `FreeX.FormatCrossCheck` delegates the identical ones but **keeps its newline-normalizing `ValuesMatch`/`DisplayMatch` override** (genuine local divergence — not flattened). All three were 7d cold. Full `FreeX.slnx` build green.
- ✅ **DONE 2026-06-28** — FreeX WPF pixel-diff utils (`LoadBitmap`/`ResizeTo`/`CreateWhite`/`GetBgra32Pixels`/`ComputeMeanPixelDiff`) → `tools/FreeX.ToolsShared.Wpf/WpfImageDiff.cs`. Repointed `FreeX.SheetImageCompare` (800×600), `FreeX.ChartFileCompare` (600×400), and `FreeX.SheetGridImageCompare` (800×600; exact-pixel tolerance path kept local). `FreeX.ParityCompare.Core/ImageDiff.cs` and `FreeP.RenderCompare/ImageDiff.cs` remain separate owner/surface decisions.
- ✅ **DONE 2026-07-01 (`5dcbe733c`, `aae52ea95`)** - Remaining FreeX tooling harness helpers. `FreeX.ExcelExamplesCharts` now uses `WpfImageDiff`, `WpfSideBySidePng.WriteHeaderOnly`, `ExcelComAutomation.CreateExcelApplicationWithRetry`, `GetNewExcelProcessIds`, `KillExcelProcesses`, and `ToolFileNameSanitizer`. `FreeX.FormatFidelity` and `FreeX.FormatCrossCheck` use the shared sanitizer. `FreeX.FidelityCompare`, `FreeX.ForegroundCapture`, `FreeX.ChartInteropCompare`, and `FreeX.NumberFormatParity` now use shared Excel COM creation/process/release helpers where their behavior is mechanical, while keeping scenario-specific workbook and chart behavior local. `ToolHarnessDedupSourceTests` guards the helper adoption.
- **Left local by design:** `freew/tools/FreeW.RibbonShot` still has a tiny `SanitizeFileName`. Do not consume `tools/FreeX.ToolsShared` from FreeW for this: that package currently has a FreeX model dependency via `FidelityValueCompare`, and pulling it into a FreeW-only tool would create product coupling for a filename helper. A future neutral `Free.ToolsShared` package could absorb this if more cross-suite tool helpers appear.

**Destination:** `tools/FreeX.ToolsShared` for portable helpers and `tools/FreeX.ToolsShared.Wpf` for WPF/COM helpers. Leave `FreeP.RenderCompare`/`FreeW.RenderCompare` to their owners unless a future neutral tool package is created.

---

## Unlock matrix

| When this clears | These items become safe |
|---|---|
| Shapes session finishes `Free.Shared.Drawing` | Cleared: **B3**, shared DrawingML preset geometry, and FreeX drawing/textbox interaction tail are done; keep guards green. |
| FreeP domain stabilizes | Cleared for current dedup scope: FreeP HLS/color, EMU, XML loading, RGB/theme-slot adapters, and preset geometry are done. |
| FreeX `Core.IO` quiets | Cleared for current dedup scope: `ApplyTint`, DrawingML RGB/preset helpers, OPC/core property helper adoption, and tooling helper tails are done. |
| FreeW `Core.IO` quiets | Cleared for current dedup scope: OPC/doc-property guard adoption is done; color/hex normalization is explicitly app/format-specific. |
| Cold fidelity tools (>24h) | Cleared for FreeX tools: value helpers, WPF pixel diff, side-by-side PNG, Excel COM helpers, and sanitizer adoption are done. |

Current dedup follow-up is validation/documentation only: keep the guards green, run the standard repo gates,
and retain FreeX visual evidence against the pre-dedup/current baseline. New extraction should start from a
fresh audit, not this now-closed backlog.
