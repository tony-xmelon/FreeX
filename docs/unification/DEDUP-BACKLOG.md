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
- **User-message service** — `Free.Shared.AppServices.IUserMessageService` + `Free.Shared.Shell.Wpf.WpfUserMessageService`/`DialogMessageHelper`. (FreeW/FreeP static `FileCommandMessageBox` test seam is the separately-logged deferred item — see ROADMAP "Deferred alignment items".)
- **Ribbon command registry** — `Free.Shared.Ribbon.Commands.RibbonCommandRegistry` + WPF/Avalonia renderers. Per-app `BuildRegistry` is genuine command wiring.

---

## B. High-value gated targets (app code — wait for the owning session)

### B1. Shared OPC path / rels / content-type helpers  ·  apps: FreeP + FreeX + FreeW  ·  confidence: HIGH
All three hand-roll the same OPC plumbing in their IO layers:
- Zip-entry → `XDocument` loader: `freep/FreeP.Core.IO/PptxPackageReader.cs:1253-1287`, `src/FreeX.Core.IO/XlsxPackageXmlEditor.cs:23-33`, `freew/FreeW.Core.IO/DocxReader.cs:1060-1068`.
- Rels-path calc (`GetRelsPath`): `PptxPackageReader.cs:1300-1307` + `PptxPackageWriter.cs:1351-1358`, `XlsxPackagePath.cs:17-24`, `DocxWriter.cs:1352-1357` (inlined).
- Path normalizer (`ResolvePath`/`NormalizeZipPath`, dot-segment collapse): `PptxPackageReader.cs:1309-1322`, `XlsxPackagePath.cs:97-115` + `26-38`.
- `GetDirectory`: `PptxPackageReader.cs:1294-1297` + `PptxPackageWriter.cs:1362-1365`, `XlsxPackagePath.cs:34-36`, `DocxWriter.cs:1362-1365`.
- Content-type ↔ extension map: `PptxPackageReader.cs:1326-1340` + `PptxPackageWriter.cs:1404-1415`, `XlsxPackagePath.cs:134-162`, `OoxmlWordprocessing.cs:328-337`.
- Rels XDocument builder (`RelsDoc`): `PptxPackageWriter.cs:1446-1466` (FreeW inlines at 5+ sites).

**Destination:** `shared/Free.Shared.Opc` — `OpcPathHelper` (paths/rels/dir/normalize, ~35 LOC), `OpcMediaTypes` (content-type map, fixes FreeP's missing tiff/emf/wmf), `OpcRelationships` (rels read+write). Pure string/XML, no app types — clean extract. **Unlock:** Core.IO settles (all three IO layers hot).

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

## D. Dev-tooling dedup — `tools/FreeX.*` fidelity/compare harnesses  ·  confidence: HIGH (real dup), but NOT currently safe
Large duplication across the FreeX fidelity tools, BUT these are the **parity session's active measurement
instruments** (half touched 11-12h ago) — consolidating them risks colliding with or breaking the parity
workflow. Execute only when the parity tooling quiets.
- Value-equivalence helpers (`ValuesMatch`/`TryNumeric`/`NumbersMatch`/`ScalarStr`/`ColToLetter`, ~90 LOC): `FreeX.SheetFidelity/Program.cs`, `FreeX.FormatFidelity/FidelityCompare.cs`, `FreeX.FormatCrossCheck/FidelityCompare.cs` (the latter two say "lifted verbatim").
- WPF pixel-diff utils (`LoadBitmap`/`ResizeTo`/`CreateWhite`/`GetBgra32Pixels`/`ComputeMeanPixelDiff`, ~75 ×3): `FreeX.SheetImageCompare`, `FreeX.ChartFileCompare`, `FreeX.SheetGridImageCompare` (+ `FreeX.ParityCompare.Core/ImageDiff.cs`, `FreeP.RenderCompare/ImageDiff.cs`).
- `WriteSideBySide` composite PNG (~35 ×3); `SanitizeFileName` (~11 ×4); `ColToLetter` (~8 ×4); Excel COM bootstrap/retry (`GetOrCreateExcel`/`TrySet…`/RPC-HResult retry, ~50-80): `FreeX.FidelityCompare/ExcelInspector.cs`, `FreeX.ChartInteropCompare/…ExcelInterop.cs`, `FreeX.ExcelOpenSmoke/ExcelSmokeCom.cs`.

**Destination:** a `tools/FreeX.ToolsShared` assembly (split portable value helpers from windows-targeted WPF/COM). **Unlock:** parity tooling quiets (these tools are in `FreeX.slnx`, so changes hit the parity build/test surface). Leave `FreeP.RenderCompare`/`FreeW.RenderCompare` to their owners.

---

## Unlock matrix

| When this clears | These items become safe |
|---|---|
| Shapes session finishes `Free.Shared.Drawing` | **B3** (delete FreeX geometry originals) — likely they do it |
| FreeP domain stabilizes | **C1, C3, C4**; FreeP half of **B1/B2/B4** |
| FreeX `Core.IO` quiets | **C2**; FreeX half of **B1/B2**; **B4** color |
| FreeW `Core.IO` quiets | FreeW half of **B1/B2** |
| Parity tooling quiets | **D** (tools/FreeX.ToolsShared) |

When two+ of these clear together, the full cross-app extraction (B1/B2) lands in one pass. Highest strategic
value: **B1** (OPC substrate) and **B2** (core-properties) — the genuinely-shared document plumbing all three
apps need.
