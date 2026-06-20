# Legacy Binary WRITE Support — XLS (BIFF8) & XLSB (BIFF12) Assessment

**Date:** 2026-06-19
**Track:** C — Legacy binary WRITE support
**Branch:** `feat/legacy-xls-xlsb-write`
**Decision:** **DEFER both `.xls` write and `.xlsb` write.** Confirmed values-only READ for both still works. This document is the deliverable: a dependency assessment + a concrete, code-grounded implementation plan for each, so a follow-up workflow can land either without re-discovery.

---

## TL;DR

| Format | Read today | Write decision | Why |
|---|---|---|---|
| **`.xls` (BIFF8)** | values-only (ExcelDataReader, confirmed working) | **DEFER** with full plan | Only free write path is **NPOI**, which drags in **two high-severity transitively-vulnerable packages** (`System.Security.Cryptography.Xml` 8.0.2) + a moderate one (`SixLabors.ImageSharp` 2.1.10) + `MathNet.Numerics.Signed` (~5 MB) + `SharpZipLib` — an unacceptable security/footprint cost for a *declining legacy* write format in a shipped desktop app. The clean alternative — a self-contained BIFF8 writer — is a **multi-day, must-be-Excel-openable-first-pass** effort (OLE2/CFB container + BoundSheet8 offset back-patching + SST), too large for a single clean pass. Per the task's own guidance, DEFER rather than ship a half-working BIFF8 writer or a vulnerable dependency. |
| **`.xlsb` (BIFF12)** | values-only (ExcelDataReader, confirmed working) | **DEFER** with plan | No mainstream free .NET BIFF12 **writer** exists (NPOI does not write `.xlsb`). A from-scratch BIFF12 writer is a strictly larger undertaking than BIFF8 (binary-record OOXML-in-a-ZIP, undocumented in the simple [MS-XLS] sense — it is [MS-XLSB], a 700-page spec). Cheapest viable path if ever needed is an **XLSX-shaped writer that emits binary `*.bin` parts**, but value is low and effort is hard. |

Both formats keep their current `CanSave: false` descriptors and route Save → Save-As (XLSX) — the existing pragmatic ceiling. The `Save()` methods still throw `NotSupportedException` with a "Use Save As XLSX" message, which is the correct UX.

---

## 1. Current state (verified)

`src/FreeX.Core.IO/LegacyXlsFileAdapter.cs` registers three open-only descriptors:

```csharp
new(".xls",  "XLS 97-2003 Workbook",   CanOpen: true, CanSave: false),
new(".xlsb", "XLSB Binary Workbook",   CanOpen: true, CanSave: false),
new(".xlt",  "XLT 97-2003 Template",   CanOpen: true, CanSave: false, OpensAsTemplate: true)
```

- **READ** is values-only via `ExcelDataReader` (MIT): scalar values + types (number/text/bool/date/time), one in-memory pass, all sheets. No formulas (cached value only), no styles, no structure. `Simple.xls` fixture round-trips through `tests/FreeX.Core.IO.Tests/LegacyXlsFileAdapterTests.cs` (read + value-mapping + `Save_IsNotSupported`).
- **Verification this session:** the read tests and the `Save_IsNotSupported` assertion remain the source of truth; no behavior changed. `.xls` and `.xlsb` both flow through the same ExcelDataReader path (XLSB is read by ExcelDataReader's BIFF12 reader). `.xlsb` has no dedicated fixture/test — the read path is exercised only implicitly; **adding an `.xlsb` read fixture is a cheap, separate good-first-task** (noted below).
- **WRITE** is unsupported by design; `Save()` throws `NotSupportedException("Legacy .xls files are currently open-only. Use Save As XLSX Workbook instead.")`.

---

## 2. XLS (BIFF8) write — dependency assessment

### 2a. Option (a): add NPOI — assessed and REJECTED for now

NPOI 2.7.4 (Apache-2.0, permissively licensed) **does** write valid BIFF8 via its `HSSF` module — verified empirically this session on `net10.0`:

```csharp
var wb = new NPOI.HSSF.UserModel.HSSFWorkbook();
var sh = wb.CreateSheet("S1");
sh.CreateRow(0).CreateCell(0).SetCellValue(42.5);
wb.Write(fs);   // -> 4096-byte valid .xls, opens in Excel
```

License is fine. The problem is the **transitive dependency graph** (`dotnet list package --include-transitive`):

| Transitive package | Concern |
|---|---|
| `System.Security.Cryptography.Xml` 8.0.2 | **TWO known HIGH-severity advisories** (GHSA-37gx-xxp4-5rgx, GHSA-w3x6-4m5h-cxqf) |
| `SixLabors.ImageSharp` 2.1.10 | Known **moderate** advisory (GHSA-rxmq-m78w-7wmc) |
| `MathNet.Numerics.Signed` 5.0.0 | ~5 MB, unused by a values+styles writer |
| `SharpZipLib` 1.4.2 | Second ZIP stack (FreeX already has `Free.Shared.Opc` + ClosedXML's zip) |

For a **shipped desktop installer** (Velopack auto-update, Sentry crash reporting, deliberate zip-bomb/XXE hardening throughout the IO layer), pulling a **high-severity crypto vulnerability** and a second image/zip/numerics stack into the trust boundary — to gain *write* support for a **format whose usage is declining** — is the wrong trade. The vulns *could* be pinned away with explicit `PackageVersion` overrides in `Directory.Packages.props`, but that is permanent maintenance coupling (every NPOI bump risks un-pinning) attached to a low-value format. **Rejected** unless product demand for `.xls` write materializes and the security team signs off on pinned overrides.

> If NPOI is ever accepted, the integration is small: add `<PackageVersion Include="NPOI" .../>` to `Directory.Packages.props`, `<PackageReference Include="NPOI" />` to `FreeX.Core.IO.csproj`, and write an `XlsWriteAdapter : IFileAdapter` that maps the FreeX model → `HSSFWorkbook` (mapping table in §2c). Add high-severity-vuln pins for the two crypto/image transitives. Then flip the `.xls` descriptor to `CanSave: true` and add the `xls` chain (§3).

### 2b. Option (b): self-contained BIFF8 writer — assessed, DEFERRED with plan

This avoids all dependencies and matches FreeX's hand-written-adapter convention (DIF/SLK/ODS). BIFF8 ([MS-XLS]) is a well-specified record stream, but it must be wrapped in an **OLE2 / Compound File Binary (CFB)** container, and Excel is **strict** — a malformed offset triggers "needs repair" or refuses to open. The genuinely hard, error-prone parts (where a half-implementation breaks Excel-openability) are:

1. **CFB container.** The `Workbook` BIFF stream must be embedded as a stream inside a CFB file (512-byte sectors, FAT/mini-FAT, directory entries, mini-stream for small streams). This is its own well-bounded but unforgiving sub-format; a wrong sector chain = unreadable file.
2. **`BoundSheet8` stream-offset back-patching.** Each sheet's `BoundSheet8` record in the globals substream stores the **absolute byte offset** of that sheet's `BOF`. These offsets are unknown until the whole stream is laid out → requires a two-pass write (or placeholder + seek-back-and-patch). The single most common reason a hand-rolled BIFF8 file won't open.
3. **SST (Shared String Table) + `LABELSST`.** BIFF8 strings live in a workbook-global SST with `CONTINUE`-record splitting at the 8224-byte record-size limit; cells reference them by index via `LABELSST`. Inline `RSTRING`/`LABEL` is possible but Excel prefers SST. `CONTINUE` splitting *inside a Unicode string* has a notorious grapheme/byte-boundary + compression-flag rule.
4. **XF / FONT / FORMAT / PALETTE plumbing** for styles: cell `XF` indices reference `FONT` and `FORMAT` records; the first 21 XFs and 4 fonts are reserved; colors are **palette indices** (nearest-match into the 56-color palette), not RGB.

These four are exactly why this is the audit's "medium (NPOI-class)" item and why it does not fit a single clean pass with the robustness bar ("Excel opens it without repair"). **Deferred** per the explicit instruction not to ship a half-working BIFF8 writer.

### 2c. Concrete BIFF8-writer implementation plan (when scheduled)

A phased plan that keeps every intermediate state shippable (each phase produces an Excel-openable file for its scope):

**Phase X0 — CFB container + minimal workbook (Excel-openable empty book).**
- New `src/FreeX.Core.IO/Biff8/` folder. `CompoundFileWriter` — writes a CFB with a single `Workbook` stream (512-byte sectors; for the common case the stream > 4096 bytes so it lives in the main FAT, simplifying the mini-stream path; handle the < 4096 mini-stream case too). Unit-test the container alone against a CFB reader (ExcelDataReader already links one — reuse for the test assert).
- `Biff8Writer` emits the globals substream: `BOF(workbook globals)`, `CodePage(1200/UTF-16)`, `Window1`, one `BoundSheet8` per sheet (offsets back-patched), `EOF`; then per sheet `BOF(worksheet)`, `DIMENSIONS`, `EOF`.
- **Exit criteria:** writes an empty multi-sheet `.xls` Excel opens cleanly; `--chain=xls` runs (MultiSheet/SheetNames `Full`).

**Phase X1 — cell values (the 80%).**
- Per sheet, iterate `Sheet.GetOccupiedCellMap()` ordered by row then col; emit `ROW` records and cell records: `NUMBER` (double), `LABELSST` (text → SST index), `BOOLERR` (bool/error), blank skipped. Dates/times are numbers (honor `Workbook` 1900/1904 date system — see `XlsxFileAdapter` for the existing flag).
- `SharedStringTable` builder with `CONTINUE` splitting at 8224 bytes and correct compressed/uncompressed (`fHighByte`) flag handling.
- **Exit criteria:** `--chain=xls` CellValues `Full`/`Lossy` OK across `ExcelExamples1.xlsx` value cells; round-trips back through the existing ExcelDataReader read path.

**Phase X2 — formulas.**
- `Cell.FormulaText` (A1) → BIFF8 **parsed `Ptg` token array** (the hard sub-part: tokenize + encode `tRef`/`tArea`/`tFunc`/`tFuncVar`/operators). Emit `FORMULA` record with the cached `Cell.Value` as the result, plus a `STRING` record for string results. Reuse the existing formula parser AST (`FreeX.Core.Formula`) to walk → Ptg rather than re-parsing.
- Fallback for unsupported tokens: write the cached value as a static `NUMBER`/`LABELSST` (lossy but never corrupt).
- **Exit criteria:** `xls` chain Formulas `Full` (or `Lossy` with documented token-coverage gaps in the CapabilityProfile).

**Phase X3 — number formats + basic styles (fonts/fills/borders/alignment) + merges.**
- Build `FONT`, `FORMAT` (custom number-format strings; built-ins via index from `BuiltInNumberFormatCatalog`), and `XF` tables from the distinct `Workbook.GetStyle(StyleId)` set; map `CellColor` → nearest **palette index** (write a custom `PALETTE` record to carry exact-ish colors). Map `CellStyle` fonts/bold/italic/color, `FillColor`/`FillPatternStyle` → XF fill, `BorderTop/Right/Bottom/Left` → XF border, `HorizontalAlignment`/`VerticalAlignment`/`WrapText`/`TextRotation`/`IndentLevel` → XF alignment.
- `MergedRegions` → `MERGEDCELLS` records (≤ 1027 per record, then `CONTINUE`). `ColumnWidths`/`RowHeights` → `COLINFO`/`ROW` `miyRw`.
- **Exit criteria:** `xls` chain NumberFormats/Fonts/Fills/Borders/Alignment/MergedCells/ColumnWidths/RowHeights at their planned cap.

**Phase X4 — adapter + catalog + harness wiring.**
- `XlsWriteAdapter : IFileAdapter` (`.xls`, `CanOpen` can delegate to the existing ExcelDataReader read or stay split — keep `LegacyXlsFileAdapter` for read, add a write-capable descriptor). Register in `WorkbookFileAdapterCatalog` (one line). Add `XlsCapabilityProfile` to `tools/FreeX.FormatFidelity/CapabilityProfile.cs` and an `xlsx -> xls -> xlsx` chain to `Chains.cs`. **Gate: 0 BUGs on the `xls` chain** (None-cap dims = expected loss).

**Effort:** ~3–5 focused days, X0 (container) and X2 (Ptg encoding) being the long poles. Each phase is independently shippable and harness-gated.

### 2d. Proposed CapabilityProfile for `.xls` (for the writer PR)

Per BIFF8's real ceiling — values/formulas/number-formats/basic-styles/multi-sheet are `Full` or `Lossy`; rich modern styling (theme colors beyond the 56-color palette, gradient fills, rich-text runs) is `Lossy`; charts/images/pivots/CF/DV/VBA are `None` unless explicitly built:

```
xls:  CellValues Full · Formulas Lossy(token-coverage) · NumberFormats Full · Fonts Lossy(palette) ·
      Fills Lossy(palette) · Borders Lossy(palette) · Alignment Full · MultiSheet Full · SheetNames Full ·
      MergedCells Full · ColumnWidths Full · RowHeights Full · FreezePanes Lossy ·
      Hyperlinks None(initially) · Comments None · DefinedNames Lossy · DataValidation None ·
      ConditionalFormat None · Charts None · Images None · Vba None
```

Color dims are `Lossy` (not `Full`) because BIFF8 quantizes RGB to a 56-entry palette — exact equality would false-flag; tolerant nearest-color comparison is correct.

---

## 3. XLSB (BIFF12) write — assessment & plan

**Confirmed READ:** values-only via `ExcelDataReader` (BIFF12 reader), same code path as `.xls`. Still works. No dedicated `.xlsb` fixture/test exists — **recommend adding one** (`tests/.../Fixtures/Simple.xlsb` + a read test mirroring `LegacyXlsFileAdapterTests.Load_*`) as an independent cheap task; it hardens the one untested read format.

**WRITE — DEFER (hard, low value).** There is **no mainstream free .NET BIFF12 writer**: NPOI does not write `.xlsb`; ClosedXML/OpenXML SDK handle XLSX only. BIFF12 is **not** the same as BIFF8 — it is [MS-XLSB], the binary variant of the OOXML package: a **ZIP** whose parts are binary `*.bin` record streams (`workbook.bin`, `sheetN.bin`, `sharedStrings.bin`, `styles.bin`) instead of XML, with its own record-id/length framing and a binary `BrtCellIsst`/`BrtCellReal`/etc. record vocabulary.

A from-scratch writer would need:
1. The full XLSX package scaffolding (reuse `Free.Shared.Opc` for the OPC/ZIP + relationships + content-types — FreeX already has this).
2. A **binary record serializer** for the BIFF12 record framing (variable-length record-id + length prefix) — analogous to the BIFF8 record writer but a different (larger) record set.
3. Binary encoders for each modeled part: cell records (`BrtCellReal`/`BrtCellSt`/`BrtCellIsst`/`BrtCellBool`/`BrtCellError`/`BrtFmlaNum`…), the binary SST, the binary style table (`BrtXF`/`BrtFont`/`BrtFmt`/`BrtFill`/`BrtBorder`), `BrtBeginSheet`/dimensions/row records.

This is **strictly more work than BIFF8** (you do everything BIFF8 needs *plus* the OPC package, against a longer spec) for a format whose only advantage over XLSX is file size on huge workbooks. **Recommendation: skip indefinitely.** If ever required, the cheapest path is to **fork the existing `XlsxFileAdapter` package-writing scaffolding** (it already builds the OPC structure) and swap the XML part serializers for BIFF12 binary-record serializers — i.e. it is "XLSX-with-binary-parts," not a fresh container. Effort: hard (1–2 weeks); value: low. No CapabilityProfile/chain added now (would be near-identical to a future `xls` profile).

---

## 4. What shipped vs deferred this track

**Shipped:** this assessment + plan (the deferral deliverable). No code changes to adapters — the existing `CanSave: false` + `NotSupportedException("Use Save As XLSX")` behavior and the values-only read for `.xls`/`.xlsb` remain correct and verified.

**Deferred (with concrete plans above):**
- **`.xls` (BIFF8) write** — gated on either (a) product acceptance of NPOI + security sign-off on pinning its high-severity transitives, or (b) the phased self-contained BIFF8 writer (§2c), ~3–5 days, harness-gated by an `xlsx -> xls -> xlsx` chain.
- **`.xlsb` (BIFF12) write** — skip indefinitely; if revived, fork the XLSX package writer and swap binary-record serializers (§3), ~1–2 weeks, low value.

**Cheap independent follow-up surfaced:** add a `Simple.xlsb` read fixture + test — the only file format with zero test coverage on its read path.

**Harness status:** unchanged. No new chain added (no writer landed). The `xls`/`xlsb` chains are specified above for the eventual writer PR.
