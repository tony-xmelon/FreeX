# Dedup Backlog — staged cross-app consolidation

Verified duplication candidates, ranked, each tagged with its **unlock condition** (which session must
settle before extraction is safe). Built 2026-06-25 from a read-only cross-app audit while the three
Microsoft-parity sessions (FreeX↔Excel, FreeW↔Word, FreeP↔PowerPoint) were active.

**Why staged, not done:** dedup means editing the app layers to point at a shared copy, and every app
source layer (`*.Core.IO`, `*.Core.Model`, `*.App.Presentation`) is hot with parity work right now.
Executing would collide with and slow the parity push. This backlog makes execution *fast* once a field
clears — the analysis is done, just re-verify line numbers (they drift) and extract.

All file:line references below were opened/grepped during the audit. Re-verify before acting — the parity
sessions move these files.

---

## A. Already shared — do NOT chase (confirmed)

The audit confirmed these are already consolidated in `Free.Shared.*`; remaining per-app code is genuine
per-shell glue, not duplication:

- **Recent files** — `Free.Shared.AppServices.RecentFilesStore` + `FileCommandWorkflow` + `Free.Shared.Shell.BackstageRecentFileListPlanner`; caps in `ApplicationOptionsSupport`. (Per-app `MaxRecentDocuments` 6 vs 8 is intentional UI.)
- **Autosave/recovery** — `Free.Shared.AppServices.AutosaveSnapshotStore` + `AutosaveSnapshotCoordinator` ("shared by FreeX and FreeW"). Per-app `AutosaveCoordinator`/`AutosaveAdapter`/`MainWindow.Autosave` are thin host bindings.
- **Status bar** — `Free.Shared.AppServices.StatusBarViewModel`/`StatusBarDisplayModelBuilder` + `Free.Shared.Ribbon.Wpf.SisterAppStatusBarChrome`.
- **User-message service** — `Free.Shared.AppServices.IUserMessageService` + `Free.Shared.Shell.Wpf.WpfUserMessageService`/`DialogMessageHelper`. FreeX, FreeW, and FreeP file-command hosts now accept the service through constructor injection; the remaining `HeadlessMessageBox.Handler` sites are WPF dialog/test helper seams, not file-command lifecycle duplication.
- **Ribbon command registry** — `Free.Shared.Ribbon.Commands.RibbonCommandRegistry` + WPF/Avalonia renderers. Per-app `BuildRegistry` is genuine command wiring.

---

## B. High-value gated targets (app code — wait for the owning session)

### B1. Shared OPC path / rels / content-type helpers  ·  apps: FreeP + FreeX + FreeW  ·  mostly done / audit adoption
The shared destination exists on `main`: `Free.Shared.Opc.OpcPathHelper`, `OpcMediaTypes`, `OpcRelationships`, and `OpcXml` now cover package path normalization, relationship-part paths, content-type maps, relationship document creation/loading, and secure XML loading.

**Current remaining work:** do not create a second helper layer. Re-audit app-local call sites and replace only proven residual clones with the existing shared APIs. Likely residuals are thin app compatibility wrappers such as `XlsxPackagePath` and any local content-type extension maps that still carry workbook-specific behavior. Keep app-specific package semantics local where they encode real XLSX/DOCX/PPTX differences.

### B2. CoreDocumentProperties model + core.xml/app.xml read-write  ·  apps: all three  ·  confidence: HIGH
Current audit: the core-properties destination is now mostly landed on `main`. `Free.Shared.Opc`
owns `DocumentProperties`, `CoreDocumentProperties`, and core-property read/write helpers; FreeW and
FreeP root models use the shared mutable model; FreeW/FreeP package readers and writers use the
shared reader/writer; and FreeX's `XlsxDocumentPropertiesPreserver` uses the shared stable-property
preservation helper for core/app package metadata.

Remaining B2 work is not a safe blind extraction: `docProps/app.xml` is preserved/stabilized in the
package layer but is not yet an app-neutral FreeW/FreeP model, and `docProps/custom.xml` carries
format-specific behavior such as FreeW watermark and Mark-as-Final properties. Treat the next slice
as an explicit `ExtendedDocumentProperties` ownership decision per app, with IO tests, rather than
recreating core-property helpers.

### B3. DONE 2026-06-30 - Free.Shared.Drawing migration (FreeX originals deleted)
Current `main` now consumes the shared drawing substrate:
- `ShapeGeometryBuilder`, `ShapeGeometry`, `ShapeSegment`, and `ShapeContour` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.App.Presentation/Shapes` no longer carries shape-geometry copies.
- `DrawingShapeKind` and `DrawingShapeKindSupport` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.Core.Model` keeps only FreeX-specific shape model/effect/text metadata.
- `LayoutPoint` and `LayoutRect` are owned by `shared/Free.Shared.Drawing`; `src/FreeX.App.Presentation/Charts/Geometry.cs` keeps only chart-specific `PlotRect` and `LayoutArc`.

Focused guards now cover the migration: `DrawingShapeSharedDrawingTests`, `ShapeGeometryBuilderTests.PresentationShapeGeometrySources_RemainNeutralized`, and `ChartGeometrySharedDrawingTests`.

### B4. Cross-app color model + EMU units  ·  apps: FreeP + FreeX  ·  confidence: MEDIUM
- RGB value struct: `freep/FreeP.Core.Model/PresentationTheme.cs:7-20` (`SrgbColor`) ≈ `src/FreeX.Core.Model/CellStyle.cs:20-33` (`CellColor`). Theme-slot enum: `PresentationTheme.cs:26-40` (`ThemeColorSlot`) ≈ `WorkbookTheme.cs:454-469` (`WorkbookThemeColorSlot`, 12 ECMA-376 slots, name variants).
- EMU constants: **DONE 2026-06-30 for the FreeP Core.IO/App.Presentation unit half**. FreeP package IO now routes point/inch defaults through `Free.Shared.Opc.DrawingMlUnits`, and FreeP presentation geometry/planner code routes inch and 96-DPI DIP constants through `Free.Shared.Drawing.DrawingMlCoordinateUnits`. The remaining B4 cross-app work is the RGB/theme-slot model decision; do not flatten that blindly because FreeP/FreeX still encode different slot names and ownership semantics.

---

## C. Intra-app cleanups — flag to the owning session (not cross-app)

- **C1. DONE 2026-06-30 - FreeP HLS color math**: current FreeP readers/resolvers both call `FreeP.Core.Model.ThemeColorTransform`, which adapts to `Free.Shared.Drawing.DrawingMlColorTransform`; `ThemeColorTransformTests` guards against local `RgbToHls`/`HlsToRgb`/private tint/shade copies returning.
- **C2. FreeX IO `ApplyTint` repeated**: identical `ApplyTint(XElement,double,XNamespace)` in `XlsxChartXmlWriter.Format.cs:187-200`, `XlsxWorkbookThemeWriter.cs:343-356`, `XlsxWorksheetDrawingObjectWriter.cs:715-728` (~13 LOC ×3); plus `ApplyTint(byte,double)` in `XlsxColorReader.cs:171-177` ≈ `WorkbookTheme.cs:139-145`. **Owner:** FreeX session.
- **C3. DONE 2026-06-30 - FreeP inline EMU units**: owned Core.IO/App.Presentation call sites now use `DrawingMlUnits`/`DrawingMlCoordinateUnits` with a focused source guard. Deferred by design: `SlideSizeDialogPlanner.EmuPerCm` remains local because the shared DrawingML helper has no centimeter API and the value is UI-unit conversion, not an OOXML primitive; `SlideCanvas`/`ChartRenderPlanner` renderer files were left untouched for the parallel chart-rendering lane.
- **C4. DONE 2026-06-30 - FreeP XML package loading hardened**: current `PptxPackageReader`/`PptxChartReader` product XML loads use `Free.Shared.Opc.OpcXml`, which flows through `SecureXmlReaderSettings`; `PptxPackageReaderSourceTests` covers package and SmartArt/DSP XML loading plus a DTD rejection scenario.

---

## D. Dev-tooling dedup — `tools/FreeX.*` fidelity/compare harnesses  ·  confidence: HIGH (real dup)
Large duplication across the FreeX fidelity tools. CAUTION: these are the parity sessions' measurement
instruments and live in `FreeX.slnx`, so only consolidate files that are COLD (>24h since last commit) and
keep every move **behavior-preserving / verbatim** (a changed tolerance silently corrupts parity numbers).

- ✅ **DONE 2026-06-26 (`1d34ffa79`)** — Value-equivalence helpers (`ValuesMatch`/`TryNumeric`/`NumbersMatch`/`ScalarStr`/`ColToLetter`/`DisplayString`) → new portable `tools/FreeX.ToolsShared/FidelityValueCompare.cs`. Repointed `FreeX.SheetFidelity`, `FreeX.FormatFidelity`; `FreeX.FormatCrossCheck` delegates the identical ones but **keeps its newline-normalizing `ValuesMatch`/`DisplayMatch` override** (genuine local divergence — not flattened). All three were 7d cold. Full `FreeX.slnx` build green.
- ✅ **DONE 2026-06-28** — FreeX WPF pixel-diff utils (`LoadBitmap`/`ResizeTo`/`CreateWhite`/`GetBgra32Pixels`/`ComputeMeanPixelDiff`) → `tools/FreeX.ToolsShared.Wpf/WpfImageDiff.cs`. Repointed `FreeX.SheetImageCompare` (800×600), `FreeX.ChartFileCompare` (600×400), and `FreeX.SheetGridImageCompare` (800×600; exact-pixel tolerance path kept local). `FreeX.ParityCompare.Core/ImageDiff.cs` and `FreeP.RenderCompare/ImageDiff.cs` remain separate owner/surface decisions.
- ⬜ `WriteSideBySide` composite PNG (~35 ×3); `SanitizeFileName` (~11 ×4); Excel COM bootstrap/retry (`GetOrCreateExcel`/`TrySet…`/RPC-HResult retry, ~50-80): `FreeX.FidelityCompare/ExcelInspector.cs`, `FreeX.ChartInteropCompare/…ExcelInterop.cs`, `FreeX.ExcelOpenSmoke/ExcelSmokeCom.cs` — several touched <24h; wait for cold.

**Destination:** `tools/FreeX.ToolsShared` (portable helpers landed; add a windows-targeted partner for WPF/COM). Leave `FreeP.RenderCompare`/`FreeW.RenderCompare` to their owners.

---

## Unlock matrix

| When this clears | These items become safe |
|---|---|
| Shapes session finishes `Free.Shared.Drawing` | **B3 is done**; keep the existing source guards green |
| FreeP domain stabilizes | **C1, C3, C4**; FreeP half of **B1/B2/B4** |
| FreeX `Core.IO` quiets | **C2**; FreeX half of **B1/B2**; **B4** color |
| FreeW `Core.IO` quiets | FreeW half of **B1/B2** |
| Cold fidelity tools (>24h) | **D** — value helpers DONE (`1d34ffa79`); FreeX WPF pixel-diff helpers DONE; remaining compare helpers are owner/surface-specific |

When two+ of these clear together, the full cross-app extraction (B1/B2) lands in one pass. Highest strategic
value: **B1** (OPC substrate) and **B2** (core-properties) — the genuinely-shared document plumbing all three
apps need.
