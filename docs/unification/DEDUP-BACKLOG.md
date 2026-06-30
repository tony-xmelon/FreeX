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
Each app has its own document-properties model + hand-rolled core/app/custom XML parsing:
`freew/FreeW.Core.Model/TextDocument.cs:1872` (`DocumentProperties`) + `DocxReader.ReadCoreProperties/ReadCustomProperties` (`:4467`,`:4494`) + `DocxWriter.BuildCoreProperties` (`:938`); `freep/FreeP.Core.Model/PresentationProperties.cs` + `PptxPackageReader.ReadCoreProperties:145`; `src/FreeX.Core.IO/XlsxDocumentPropertiesPreserver.cs`. Shared has only the **constants** (`OpcPackageProperties`) and the **UI planner** (`BackstageCorePropertiesPlanner`), not the model or read/write. **Destination:** shared `CoreDocumentProperties` record + reader/writer over `OpcPackageProperties`. **Unlock:** Core.IO + Core.Model settle. (This is the WS-C deferred item.)

### B3. Finish the Free.Shared.Drawing migration (delete FreeX originals)  ·  confidence: HIGH  ·  ~633 LOC live dup
`Free.Shared.Drawing` was created to host these, with "Ported from…" comments, but the FreeX originals were never deleted — both copies compile and coexist:
- `ShapeGeometryBuilder` (44-preset geometry math, ~430 LOC): `src/FreeX.App.Presentation/Shapes/ShapeGeometryBuilder.cs` vs `shared/Free.Shared.Drawing/ShapeGeometryBuilder.cs` (diff = 26 ns/comment lines).
- `ShapeGeometry`/`ShapeSegment`/`ShapeContour` (~66): `…/Shapes/ShapeGeometry.cs` vs shared.
- `DrawingShapeKind` enum (~50): `src/FreeX.Core.Model/DrawingShapeModel.cs` vs `shared/Free.Shared.Drawing/DrawingShapeKind.cs`.
- `DrawingShapeKindSupport` (~59): `src/FreeX.Core.Model/DrawingShapeKindSupport.cs` vs shared.
- `LayoutPoint`/`LayoutRect` (~28): `src/FreeX.App.Presentation/Charts/Geometry.cs` vs `shared/Free.Shared.Drawing/Geometry.cs`.

**Action:** delete FreeX originals, repoint consumers at `Free.Shared.Drawing` (keep FreeX-only `PlotRect`/`LayoutArc`, `DrawingShapeEffectPreset`/`GradientDirection` which weren't ported). **Unlock:** the **shapes session** (actively porting `Free.Shared.Drawing`, touched ~hours ago) finishes — likely doing exactly this. Coordinate; don't race it.

### B4. Cross-app color model + EMU units  ·  apps: FreeP + FreeX  ·  confidence: MEDIUM
- RGB value struct: `freep/FreeP.Core.Model/PresentationTheme.cs:7-20` (`SrgbColor`) ≈ `src/FreeX.Core.Model/CellStyle.cs:20-33` (`CellColor`). Theme-slot enum: `PresentationTheme.cs:26-40` (`ThemeColorSlot`) ≈ `WorkbookTheme.cs:454-469` (`WorkbookThemeColorSlot`, 12 ECMA-376 slots, name variants).
- EMU constants: FreeP IO inlines `/ 12700.0` / `* 12700` ~20 sites (`PptxPackageReader/Writer`, `PptxColorReader.cs:145`) instead of `Free.Shared.Opc.DrawingMlUnits`; `WorkbookTheme.cs:431` notes it can't take the shared-opc dep. **Destination:** shared color value-types in `Free.Shared.Drawing`; add `DrawingMlUnits` ref to FreeP IO. **Unlock:** FreeP + FreeX Core settle; needs a small interface for the name-variant divergence.

---

## C. Intra-app cleanups — flag to the owning session (not cross-app)

- **C1. FreeP HLS color math duplicated within FreeP** (~100 LOC): `freep/FreeP.Core.IO/PptxColorReader.cs:205-298` (`ApplyLumModOff`/`ApplyTint`/`ApplyShade`/`RgbToHls`/`HlsToRgb`) ≈ `freep/FreeP.App.Presentation/ThemeColorResolver.cs:36-137`. Same app — extract to one internal helper. **Owner:** FreeP session.
- **C2. FreeX IO `ApplyTint` repeated**: identical `ApplyTint(XElement,double,XNamespace)` in `XlsxChartXmlWriter.Format.cs:187-200`, `XlsxWorkbookThemeWriter.cs:343-356`, `XlsxWorksheetDrawingObjectWriter.cs:715-728` (~13 LOC ×3); plus `ApplyTint(byte,double)` in `XlsxColorReader.cs:171-177` ≈ `WorkbookTheme.cs:139-145`. **Owner:** FreeX session.
- **C3. FreeP inline EMU → `DrawingMlUnits`** (see B4 units half). **Owner:** FreeP session.
- **C4. SECURITY — FreeP XML reader not hardened**: `freep/FreeP.Core.IO/PptxPackageReader.cs` `LoadXml` calls `XDocument.Load(stream)` directly, bypassing `Free.Shared.Opc.SecureXmlReaderSettings` (DtdProcessing.Prohibit, 64 MB cap, no resolver) that FreeX (`XlsxPackageXmlEditor.cs:31`) and FreeW (`DocxReader.cs:1066`) both use. XXE/DTD-bomb exposure on untrusted .pptx. **Owner:** FreeP session — flagged separately.

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
| Shapes session finishes `Free.Shared.Drawing` | **B3** (delete FreeX geometry originals) — likely they do it |
| FreeP domain stabilizes | **C1, C3, C4**; FreeP half of **B1/B2/B4** |
| FreeX `Core.IO` quiets | **C2**; FreeX half of **B1/B2**; **B4** color |
| FreeW `Core.IO` quiets | FreeW half of **B1/B2** |
| Cold fidelity tools (>24h) | **D** — value helpers DONE (`1d34ffa79`); FreeX WPF pixel-diff helpers DONE; remaining compare helpers are owner/surface-specific |

When two+ of these clear together, the full cross-app extraction (B1/B2) lands in one pass. Highest strategic
value: **B1** (OPC substrate) and **B2** (core-properties) — the genuinely-shared document plumbing all three
apps need.
