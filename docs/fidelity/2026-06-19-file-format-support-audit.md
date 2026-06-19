I now have all the code-grounded details I need: `Cell.Value` (ScalarValue), `Cell.FormulaText`/`HasFormula`, `Cell.StyleId`, `Workbook.GetStyle(StyleId)` returning `CellStyle` with `NumberFormat`, `BorderTop/Right/Bottom/Left`, plus `Sheet.MergedRegions`, `DefaultColumnWidth/RowHeight`, `StyleOnly` runs, `ConditionalFormats`, `DataValidations`, `Charts`, `Workbook.NamedRanges`. This is enough to write a buildable design document.

---

# FreeX File-Format Support — Audit, Gap Plan, and Format-Fidelity Test Harness Design

**Repo:** `C:/Users/anton/OneDrive/Documents/FreeX/FreeX`
**Scope:** spreadsheet file-format adapters in `src/FreeX.App.Services/WorkbookFileAdapterCatalog.cs` + `src/FreeX.Core.IO/*FileAdapter.cs`, the PDF/XPS export pipeline, and a new round-trip fidelity harness `tools/FreeX.FormatFidelity`.
**Status legend:** round-trip fidelity is `lossless` / `lossy-expected` (format ceiling) / `lossy-bug` (FreeX drops what the format can hold) / `n/a` (read-only or export-only).

---

## 1. Current Support Matrix

Every format FreeX touches today, grouped by adapter. Resolution is purely extension-keyed, first-match-wins, in catalog order `[Xlsx, LegacyXls, Csv, DelimitedText(.txt/.tsv/.tab), SpreadsheetXml, NativeJson]` (`WorkbookFileAdapterCatalog.CreateDefaultAdapters()`), via `FileFormatResolver.FindOpenAdapter/FindSaveAdapter`. No content sniffing.

| Format (ext) | Read | Write | Round-trip fidelity | Key gaps | Robustness risks |
|---|---|---|---|---|---|
| **XLSX** `.xlsx` (`XlsxFileAdapter`, ClosedXML) | ✅ | ✅ | **lossless\*** (source-package preservation + patch-save); **lossy-bug** on full ClosedXML rebuild | VBA (`xl/vbaProject.bin`), dialog/macro sheets, CF rules ClosedXML can't model, chartEx parts: survive only via verbatim source-copy / patch path; **dropped on a full ClosedXML re-save**. Best-effort per-sheet feature loads downgrade to warnings. | All load+full-save serialized through process-wide `ClosedXmlGate` (ClosedXML not thread-safe) → concurrency bottleneck. Zip-bomb guard (`WorkbookOpenSizeGuard`). Patch-save XML-char failures fall back to full save. Load ~10s, memory-heavy (whole package buffered for snapshot). 1904 date system honored. |
| **XLSM** `.xlsm` | ✅ | ❌ (`CanSave:false`) | n/a (save routes to Save-As) | Open-only. Macros preserved byte-for-byte only on verbatim/patch save (`TryPreserveMacroEnabledWorkbookContentType`); a full ClosedXML rebuild drops the VBA project → body becomes effectively `.xlsx`. | Same `ClosedXmlGate`/zip-bomb. `XlsxPackageHealthValidator` cross-checks `vbaProject.bin` content-type wiring. |
| **XLTX** `.xltx` | ✅ | ❌ | n/a | `OpensAsTemplate:true`; opened as new untitled workbook, never written back as `.xltx`. | Standard `.xlsx` load pipeline. |
| **XLTM** `.xltm` | ✅ | ❌ | n/a | Open-as-template; macros + template-ness both unsaveable. | Same as `.xlsx` load. |
| **XLS** `.xls` (`LegacyXlsFileAdapter`, ExcelDataReader) | ✅ | ❌ | n/a | **Values only.** No formulas (cached value only), no styles/number-formats/fonts/fills/borders, no merges/widths/heights/panes/print, no charts/images/pivots/CF/DV/named-ranges/hyperlinks. Workbook named "Untitled" in `Load`. | **No try/catch** — corrupt BIFF propagates out of `Load()`. Whole-stream fully materialized, **no size cap** (wide/tall `.xls` = unbounded mem/CPU). `row` is `uint` with no bounds check. `CodePagesEncodingProvider` registered for legacy code pages. |
| **XLSB** `.xlsb` (`LegacyXlsFileAdapter`) | ✅ | ❌ | n/a | Same values-only path as `.xls` via ExcelDataReader; no XLSB-specific handling. No `.xlsb` fixture/test. | Same as `.xls` (no exception handling, full materialization). |
| **XLT** `.xlt` (`LegacyXlsFileAdapter`) | ✅ | ❌ | n/a | `OpensAsTemplate:true`, values-only. No fixture/test. | Same as `.xls`. |
| **CSV** `.csv` (`CsvFileAdapter` → `DelimitedTextWorkbookReader/Writer`, `,`) | ✅ | ✅ | **lossy-expected** | Multi-sheet → only `Sheets[0]` written; load creates one `Sheet1`, names not preserved. No styles/formats/widths/merges/comments/DV/CF/charts/images. Formulas written as **text** (`=A1*2`), not cached results (Excel writes values). Currency parsing **hard-coded en-US `$`**. Only fixed `#`-error list recognized. | Whole file → one in-memory string (no streaming; >2 GB throws on `checked((int))`). BOM detect (UTF-8/16/32); no-BOM falls back **Windows-1252** (mojibake risk). **Locale-nondeterministic read** (CurrentCulture then Invariant) vs Invariant-only write → save-on-one-locale/load-on-another shifts values. Formula-injection hardening (leading `'` for `=+-@`). Unterminated quote consumed to EOF silently. Row/col DoS caps (`MaxRow`/`MaxCol`). |
| **TXT / TSV / TAB** `.txt` `.tsv` `.tab` (3× `DelimitedTextFileAdapter`, all `\t`) | ✅ | ✅ | **lossy-expected** | Same single-sheet, values-only engine as CSV. Delimiter hard-wired TAB (no space/semicolon/pipe UI; only load-time `sep=` overrides). Write UTF-8 no-BOM, no encoding choice. | Same locale/encoding/coercion/DoS profile as CSV. Embedded mid-field quotes kept literally (diverges from RFC-4180). |
| **PRN** `.prn` | ❌ | ❌ | n/a | **Not implemented** — no adapter registered; engine is single-char-delimiter only, no fixed-width column parsing. Excel Save-As gap. | N/A (no code path). |
| **SpreadsheetML 2003** `.xml` (`SpreadsheetXmlFileAdapter`, LINQ-to-XML) | ✅ | ✅ | **lossy-bug** | Reads/writes values, formulas, **NumberFormat only**, merges, row/col sizing+hidden, freeze panes, gridlines, named ranges, hyperlinks, plain comments. **Drops fonts/fills/borders/alignment/rotation/wrap/protection.** R1C1 formulas **not converted to A1** (real Excel-saved formulas import as literal R1C1 → wrong). Array formulas ignored. Comment author hard-coded "FreeX". No charts/images/pivots/CF/DV/print/page-setup/doc-props. DateTime with tz offset silently → UTC. | Non-streaming `XDocument` DOM load; hard **64 MB char cap** (legit large files fail). `DtdProcessing.Prohibit` + `XmlResolver=null` (XXE-safe). Out-of-range date serial silently → `String` (type corruption). NaN/Inf → `String`. Sheet names sanitized/truncated to 31, de-duplicated. `LoadTransformed` runs caller-supplied XSLT (code-exec surface; output-byte-capped). |
| **FXL** `.fxl` (`NativeJsonAdapter`) | ✅ | ✅ | **lossless** | Passwords SHA-256 hashed on save (by-design, plaintext unrecoverable). NaN/Inf number → text. Schema gating: `SchemaVersion>1` / `MinimumReaderVersion>1` / format mismatch → `InvalidDataException` (no forward-compat read). Unparseable refs (print areas, merges, named ranges, scenarios, addresses) **silently dropped** via `catch(FormatException)` — no warning. Sheet cross-refs bound by **name** not stable id (rename/collision → wrong-sheet or dropped). | Whole-doc load in-memory (`Deserialize<WorkbookDto>`); save IS streaming. Structurally broken JSON throws (only per-element errors swallowed). All numbers Invariant/UTF-8 (locale-safe). Address parsing bounds-guarded. |
| **PDF** `.pdf` (export pipeline, NOT an adapter) | ❌ | ✅ | lossy-expected | Export-only, no import, not in catalog. Windows path (`PdfDocumentExporter`/PdfSharp) **rasterizes** each page + optional selectable-text overlay + links/bookmarks. Vector overlay handles only `SolidColorBrush` + simple padded `LinearGradientBrush`. PDF/A + tagged PDF rejected. Portable fallback (`PortablePdfDocumentExporter`) draws a simplified cell grid only. | Windows exporter needs STA/UI thread. Portable exporter is **WinAnsi/Helvetica only** — non-Latin/CJK/emoji throws (`PortablePdfWinAnsiTextCapability`). Whole doc in `MemoryStream`. |
| **XPS** `.xps` (export pipeline / PDF fallback) | ❌ | ✅ | lossy-expected | Export-only, not in catalog; chosen by `.xps` or used as automatic fallback when PDF render fails. PDF-specific options stripped. | Windows/WPF-only (`FixedDocument`); unavailable on non-Windows. UI-thread bound. |

\* "lossless" for XLSX is conditional: true while the original package is preserved (source-copy / patch-save). A change that forces a full ClosedXML rebuild is **lossy-bug** for the verbatim-preserved feature set (VBA, chartEx, unmodelled CF). This is the single most important nuance the fidelity harness must encode (see §3d).

---

## 2. Gap & Expansion Plan

Every Excel format FreeX is **missing** or **partial**, sorted by value-to-effort (ROI). Effort uses the inventory's `feasibility` (easy/medium/hard); value uses `valueRank` (1–5).

### Tier A — BUILD NOW (high ROI, mostly easy wins on existing infra)

| Format | Status | Effort | Value | Recommendation | One-line rationale |
|---|---|---|---|---|---|
| **XLTX save** `.xltx` | partial | easy | 3 | **BUILD NOW** | Add a `CanSave:true` descriptor that flips the workbook content-type to `template.main+xml` on the existing XLSX writer — pure content-type/extension switch, no new engine. |
| **CSV UTF-8 (BOM)** | partial | easy | 4 | **BUILD NOW** | Excel exposes it as a distinct Save-As type; FreeX already writes CSV — add a BOM/encoding option to `DelimitedTextWorkbookWriter`. Closes a real interop annoyance (Excel's default modern CSV). |
| **Unicode Text (UTF-16 TXT)** | partial | easy | 2 | **BUILD NOW** | Same writer, UTF-16LE+BOM variant; tiny. Bundle with the CSV-UTF-8 encoding work. |
| **ODS** `.ods` | missing | medium | 4 | **BUILD NOW** (after harness) | **Highest net-new ROI.** Zipped ODF XML structurally similar to xlsx; map cells/styles/formulas/sheets to ODF namespaces. The one format that meaningfully expands interop (LibreOffice/Google) for moderate effort. Gate behind the FormatFidelity harness. |
| **SLK** `.slk` | missing | easy | 1 | **BUILD NOW** | Line-based ID/B/C/F records; only fiddly bit is R1C1 formulas. Cheap, and FreeX already needs R1C1↔A1 for the SpreadsheetML bug fix — share that code. |
| **DIF** `.dif` | missing | easy | 1 | **BUILD NOW** | Tiny well-specified line-oriented interchange; near-free once the SLK line-reader scaffolding exists. |

### Tier B — BUILD LATER (real value, but medium/hard or lower priority)

| Format | Status | Effort | Value | Recommendation | One-line rationale |
|---|---|---|---|---|---|
| **DBF** `.dbf` (read) | missing | medium | 2 | **BUILD LATER** | Read-only matches Excel; header + typed fixed-record parsing is bounded. Useful for legacy data import but niche. |
| **HTML/HTM** `.html` (read+write) | missing | medium | 3 | **BUILD LATER** | Import `<table>`/styles → grid (medium); export styled tables (medium). Decent value but two non-trivial directions; sequence after ODS. |
| **PRN** `.prn` (write) | missing | easy | 1 | **BUILD LATER** | Fixed-width writer over delimited infra is easy, but it's Excel-save-only and rare; low payoff. |
| **XLS write fidelity** `.xls` | partial (read) | medium | 4 | **BUILD LATER** | High value but BIFF8 **write** is the medium-hard part (NPOI-class effort) and the current read is values-only — needs a richer read first. Big undertaking; not a quick win. |
| **XLSB** `.xlsb` (full) | missing (values-only today) | hard | 3 | **BUILD LATER** | No mainstream free .NET writer; full read+write fidelity is a large undertaking. Current values-only read is the cheap 80%. |

### Tier C — SKIP (low value and/or hard; out of scope)

| Format | Status | Recommendation | One-line rationale |
|---|---|---|---|
| **XLSM/XLTM save** | partial | **SKIP** (until VBA strategy exists) | The container is easy; **preserving/authoring the VBA project intact is the hard part** and FreeX doesn't model macros. Today's verbatim-passthrough on patch-save is the pragmatic ceiling. |
| **XLT** `.xlt` (97-2003 template) | missing | **SKIP** | Legacy BIFF8 template, rare today; only worth it if `.xls` write lands first (shares engine). |
| **MHT/MHTML** | missing | **SKIP** | MIME-multipart + HTML layer is hard for value-1 payoff. |
| **XLAM / XLA** (add-ins) | missing | **SKIP** | Code containers, not user documents; same VBA hard-part. Out of scope. |
| **OTS** (ODS template) | missing | **SKIP** (piggyback ODS) | Trivial once ODS exists; otherwise not worth standalone effort. |
| **FODS** (flat-XML ODF) | missing | **SKIP** | Not a native Excel Save-As/Open type; reuse ODS mapping if ever needed. |

**Highest-ROI additions, flagged:** **ODS** (value 4 / medium — the single best net-new format), then **CSV-UTF-8 + Unicode-Text** (value 4+2 / easy — almost free), then **SLK + DIF** (value 1 each / easy — cheap completeness), then **XLTX-save** (value 3 / easy). **XLSB and HTML are deliberately deferred to Tier B**: XLSB has no free write path (hard), HTML is two medium directions; both are worthwhile but should not block the easy wins. **XLS-write** is high value but medium-hard and gated on a richer read.

---

## 3. Format-Fidelity Test-Suite Design (key deliverable)

A new console tool **`tools/FreeX.FormatFidelity`** that mirrors `tools/FreeX.SheetFidelity` (same shape: en-US culture pin, temp-dir `REPORT.txt`, `Console.WriteLine` + buffer, exit code), but instead of recalc-vs-cached it **round-trips a source workbook through conversion chains across formats** and asserts **no information loss beyond each format's documented capability ceiling**.

The core idea: for a chain like `xlsx → ods → xlsx`, the **expected-lossless content** is the *intersection* of every hop's capabilities. Anything in that intersection that changes is a **BUG**; anything outside it that's lost is **expected loss**. The harness's job is to compute that intersection precisely and diff against it.

### 3a. Per-format CAPABILITY PROFILE

A declarative table — one row per format, one column per fidelity **dimension** — encoded as `CapabilityProfile` records. `Full` = the format can carry it faithfully; `Lossy` = can carry an approximation (compared with tolerance, never as an exact-match BUG); `None` = cannot represent it (always expected loss).

```csharp
enum Cap { None, Lossy, Full }

sealed record CapabilityProfile(
    string Ext,
    Cap CellValues,        // scalar value + type (number/text/bool/date/error/blank)
    Cap Formulas,          // formula text (A1), recoverable on reload
    Cap NumberFormats,     // number-format string
    Cap Fonts,             // name/size/bold/italic/color
    Cap Fills,             // interior/background color
    Cap Borders,           // per-edge style+color
    Cap Alignment,         // h/v align, wrap, rotation
    Cap MultiSheet,        // >1 worksheet
    Cap SheetNames,        // sheet name preservation
    Cap MergedCells,
    Cap ColumnWidths,
    Cap RowHeights,
    Cap FreezePanes,
    Cap Hyperlinks,
    Cap Comments,
    Cap DefinedNames,
    Cap DataValidation,
    Cap ConditionalFormat,
    Cap Charts,
    Cap Images,
    Cap Vba);
```

Profiles, grounded in §1 behavior:

| Dimension → | xlsx | fxl | xml (SpreadsheetML) | csv/txt/tsv/tab | ods (planned) | slk/dif (planned) |
|---|---|---|---|---|---|---|
| CellValues | Full | Full | Full | Lossy¹ | Full | Full |
| Formulas | Full | Full | **Lossy²** | Lossy³ | Full | Lossy⁴ |
| NumberFormats | Full | Full | Full | None | Full | Lossy |
| Fonts | Full | Full | **None** | None | Full | None |
| Fills | Full | Full | **None** | None | Full | None |
| Borders | Full | Full | **None** | None | Full | None |
| Alignment | Full | Full | **None** | None | Full | None |
| MultiSheet | Full | Full | Full | **None** | Full | None |
| SheetNames | Full | Full | Full (≤31, sanitized) | None | Full | None |
| MergedCells | Full | Full | Full | None | Full | None |
| ColumnWidths | Full | Full | Full | None | Full | None |
| RowHeights | Full | Full | Full | None | Full | None |
| FreezePanes | Full | Full | Full | None | Full | None |
| Hyperlinks | Full | Full | Lossy | None | Full | None |
| Comments | Full | Full | **Lossy⁵** | None | Full | None |
| DefinedNames | Full | Full | Lossy⁶ | None | Full | None |
| DataValidation | Full | Full | None | None | Lossy | None |
| ConditionalFormat | Lossy⁷ | Full | None | None | Lossy | None |
| Charts | Lossy⁷ | Full | None | None | Lossy | None |
| Images | Lossy⁷ | Full | None | None | Lossy | None |
| Vba | Lossy⁸ | None | None | None | None | None |

Footnotes encode the **known FreeX behaviors** so the harness scores correctly:
1. CSV coerces text→typed heuristically (en-US `$`, dates, errors) → values are `Lossy` (compared by display, not exact type).
2. SpreadsheetML stores formulas verbatim incl. R1C1 → currently `Lossy`; **promote to `Full` once R1C1↔A1 conversion lands** (this flip is itself a regression gate).
3. CSV/TXT write formula **text** not cached result → `Lossy` (assert formula text survives, not the value).
4. SLK/DIF formulas are R1C1 → `Lossy`.
5. SpreadsheetML drops rich-text + author (hard-codes "FreeX") → `Lossy`.
6. Named ranges: single `Sheet!A1[:B2]` only; multi-area/constant/workbook-scope skipped → `Lossy`.
7. xlsx CF/charts/images: `Full` while source-package preserved, `Lossy`→effectively `None` after a full ClosedXML rebuild — see §3d.
8. VBA only on verbatim/patch path.

### 3b. Computing EXPECTED-LOSSLESS content for a chain

For a chain `F₀ → F₁ → … → Fₙ` (the source is loaded once, then re-saved/reloaded through each format in turn), the surviving capability per dimension is the **minimum (`Cap.Min`) over every hop's profile**, where `None < Lossy < Full`:

```csharp
static Cap ChainCap(IReadOnlyList<CapabilityProfile> hops, Func<CapabilityProfile, Cap> dim)
    => hops.Skip(1)                       // F0 is the in-memory source; every WRITE→READ hop is a ceiling
           .Select(dim)
           .Aggregate(Cap.Full, (acc, c) => (Cap)Math.Min((int)acc, (int)c));
```

- Dimension is **`Full`** for the chain ⇒ assert **exact equality** (a diff is a BUG).
- Dimension is **`Lossy`** ⇒ assert **tolerant equality** (display-normalized / approximate; a diff beyond tolerance is a BUG, within tolerance is fine).
- Dimension is **`None`** ⇒ **not asserted** (expected loss; recorded as "dropped — format ceiling", never a BUG).

Example — `xlsx → ods → xlsx`: Fills/Borders/Fonts/Merges/Charts are `Full∧Full = Full` ⇒ must survive exactly (these are the bug-catchers for a new ODS adapter). `xlsx → csv → xlsx`: everything except CellValues/Formulas collapses to `None` ⇒ only values (Lossy) + formula-text (Lossy) are asserted. `xlsx → xml → xlsx`: Fonts/Fills/Borders are `None` (expected loss — SpreadsheetML can't hold them), but Merges/Widths/FreezePanes/NumberFormats are `Full` ⇒ **must survive** — that's how we catch the SpreadsheetML R1C1/comment bugs without false-flagging the dropped styling.

### 3c. COMPARISON METHOD per dimension (with tolerances)

Reference snapshot is taken from the **in-memory source workbook (F₀)**; the final reloaded workbook (Fₙ) is compared against it, dimension by dimension, **gated by `ChainCap`**.

| Dimension | Extraction (model APIs, grounded) | Comparison & tolerance |
|---|---|---|
| **Cell values / types** | `Sheet.GetOccupiedCellMap()` → `Cell.Value` (`ScalarValue`: `NumberValue/TextValue/BoolValue/DateTimeValue/ErrorValue/BlankValue`) | `Full`: exact type+value. `Lossy`: numeric within `abs<1e-9` **or** `rel<1e-6` (reuse `NumbersMatch` from SheetFidelity); date-serial≡number (reuse `TryNumeric`); any-error≡any-error; text Ordinal. CSV-coercion compares **display string** not raw type. |
| **Formulas** | `Cell.HasFormula`/`Cell.FormulaText` | `Full`: normalized A1 string equality (strip leading `=`, uppercase function names, collapse `$`-insensitively only where the format documents it). `Lossy` (csv/xml-R1C1): assert formula-text *present*, compare best-effort. |
| **Number-format strings** | `Workbook.GetStyle(Cell.StyleId).NumberFormat` | `Full`: exact string after canonicalizing `"General"`. |
| **Style attributes** (fonts/fills/borders/alignment) | `Workbook.GetStyle(Cell.StyleId)` → `CellStyle` (`BorderTop/Right/Bottom/Left` = `CellBorder(Style,Color)`, fill/font fields); plus `Sheet.GetStyleOnlyEntries()` for style-only cells | Per-attribute equality. Colors compared as normalized ARGB (theme-resolved); tolerance = exact for explicit colors, **skip** when chain cap is `None`. |
| **Sheet structure** | `Workbook.Sheets` (count, `Sheet.Name`), `Sheet.MergedRegions`, `Sheet.DefaultColumnWidth/RowHeight` + per-col/row overrides, freeze-pane fields | `Full`: sheet count + ordered names exact (xml: compare after ≤31 sanitization); merged-region set equality; widths/heights within `1e-3` (float). |
| **Defined names** | `Workbook.NamedRanges` | `Full`: name→refers-to set equality. `Lossy` (xml): only single-area names asserted. |
| **DV / CF / charts / images** | `Sheet.DataValidations`, `Sheet.ConditionalFormats`, `Sheet.Charts`, drawings | `Full`: count + key-attribute equality. `None`: skipped. xlsx CF/charts gated by source-package state (§3d). |

All extraction/normalization helpers (`NumbersMatch`, `TryNumeric`, `ValuesMatch`, `ColToLetter`) are **lifted directly from `tools/FreeX.SheetFidelity/Program.cs`** into a shared `FidelityCompare` static class so the two tools agree on value-equivalence semantics.

### 3d. Distinguishing EXPECTED LOSS from a BUG (the core assertion)

This is the whole point. For each dimension `d` and chain `C`:

```
cap = ChainCap(C, d)
ref = extract(d, sourceWorkbook)        // F0
got = extract(d, reloadedWorkbook)      // Fn

if cap == None:
    if ref != got:  record EXPECTED-LOSS(d)         // format ceiling — informational, NOT a failure
    else:           record PRESERVED-ANYWAY(d)      // bonus
elif cap == Lossy:
    if !TolerantEqual(d, ref, got):  record BUG(d, "lossy-tolerance exceeded")
else: // Full
    if ref != got:  record BUG(d, "format can hold this but FreeX changed/dropped it")
```

A **BUG** is *only ever* raised when the chain's capability for that dimension is `Full` (or `Lossy`-beyond-tolerance). Loss in a `None` dimension is reported as **expected** and never fails the run. Concretely:

- `xlsx → csv → xlsx` dropping fills ⇒ **expected** (`Fills=None` in chain). Not a bug.
- `xlsx → ods → xlsx` dropping fills ⇒ **BUG** (`Fills=Full∧Full`). The ODS adapter lost something it could hold.
- `xlsx → xml → xlsx` turning a formula into R1C1 garbage ⇒ **BUG** *today* (`Formulas=Lossy` but text must remain recoverable; an unparseable R1C1 string that reloads as a literal value fails the lossy check) — and becomes a hard `Full` assertion the moment we flip footnote-2.

**XLSX source-package special-case (the §1 nuance):** the harness runs every xlsx hop **twice** — once on the **patch/source-copy path** (no content change → `Full` for VBA/chartEx/CF), and once forcing a **full ClosedXML rebuild** (mutate one cell so patch-save can't apply). The capability profile carries two xlsx columns (`xlsx-preserved`, `xlsx-rebuilt`); the rebuilt column downgrades VBA/chartEx/unmodelled-CF to `None`, so a rebuild dropping VBA is **expected**, while the preserved path dropping it is a **BUG**. This is the only way to correctly score the lossy-bug fidelity rating from §1.

### 3e. Conversion matrix / chain list

```
# Single-hop round-trips (catch per-adapter write/read bugs)
xlsx  -> fxl  -> xlsx          # native lossless baseline — should be near-perfect
xlsx  -> xlsx (patch)          # source-package preservation (VBA/chartEx must survive)
xlsx  -> xlsx (rebuilt)        # full ClosedXML re-save (VBA/chartEx expected-loss)
xlsx  -> xml  -> xlsx          # SpreadsheetML: merges/widths/numfmt Full; styles None; R1C1 bug
xlsx  -> csv  -> xlsx          # values/formula-text only
xlsx  -> txt  -> xlsx          # tab-delimited, same ceiling as csv
fxl   -> fxl                   # native idempotence (must be exactly lossless)

# New-format gates (added with each adapter; fail the merge if Full-cap dims drift)
xlsx  -> ods  -> xlsx          # ODS adapter regression gate (styles/merges/charts Full)
xlsx  -> slk  -> xlsx          # SLK values + R1C1 formulas
xlsx  -> dif  -> xlsx          # DIF values

# Multi-hop chains (intersection narrows; catch order-dependent + cumulative loss)
xlsx  -> ods  -> xlsx -> csv -> xlsx
xlsx  -> xml  -> xlsx -> ods  -> xlsx
xlsx  -> ods  -> xlsx -> xml  -> xlsx
fxl   -> xlsx -> ods  -> xlsx -> fxl     # native -> interchange -> native
```

Idempotence chains (`fxl→fxl`, `xlsx→xlsx(patch)`) are the strictest: **every** dimension is `Full`, so any diff is a bug. Multi-hop chains validate that the intersection logic composes (e.g. once `csv` collapses styling to `None`, a later `ods` hop can't "resurrect" it — the chain cap stays `None`, so no false BUG).

### 3f. Where it plugs in

New tool **`tools/FreeX.FormatFidelity/`** (`FreeX.FormatFidelity.csproj` + `Program.cs`), modeled file-for-file on `tools/FreeX.SheetFidelity`:

- References the same projects (`FreeX.Core.Model`, `FreeX.Core.IO`, `FreeX.App.Services`, `FreeX.Core.Calc`, `FreeX.Core.Formula`) and pins en-US culture identically (lines 26–30 of SheetFidelity).
- Obtains adapters **only** through `WorkbookFileAdapterCatalog.CreateDefaultAdapters()` + `FileFormatResolver.FindOpenAdapter/FindSaveAdapter` — never instantiates adapters directly — so the harness automatically picks up any new adapter the moment it's added to the catalog (one-line registration). A chain hop is: `FindSaveAdapter(ext).Save(wb, stream)` → temp file → `FindOpenAdapter(ext).Load(stream)`.
- `CapabilityProfile` table + `FidelityCompare` helpers live in the tool (helpers shared with SheetFidelity via a small `tools/FreeX.FidelityShared` or copied, matching repo convention).
- Inputs: a source-workbook path (default to the existing corpora, see §4) and an optional chain filter. Output: temp-dir `REPORT.txt` + console, exit `0` clean / `1` on any BUG.

### 3g. Clean run vs flagged run, and reporting

The report mirrors SheetFidelity's banner/section style. Per chain:

```
CHAIN: xlsx -> ods -> xlsx   (source: ExcelExamples1.xlsx)
  hops OK: save/load succeeded at every stage
  Dimension        ChainCap   Result
  CellValues       Full       OK     (4211/4211 match)
  Formulas         Full       OK     (337/337 match)
  NumberFormats    Full       OK
  Fonts            Full       BUG    12 cells lost bold/color   <-- ODS adapter
  Fills            Full       OK
  Merges           Full       OK
  Charts           Lossy      OK     (3/3 within tolerance)
  Vba              None       EXPECTED-LOSS (dropped, format ceiling)
  --> 1 BUG, 0 lossy-exceeded, 1 expected-loss
```

- **Clean run:** every `Full`/`Lossy` dimension across every chain is `OK`; only `None`-dimension `EXPECTED-LOSS` lines appear. Exit `0`. Headline: `BUGS: 0`.
- **Flagged run:** ≥1 `BUG` line. Each names the chain, dimension, count, sample addresses (`{sheet}!{ColToLetter(col)}{row}`), and the offending hop (the first format in the chain whose cap for that dimension is `Full` yet the value changed across its write→read). Exit `1`. Findings reported as a per-chain × per-dimension grid + a BUG cluster summary (grouped by `(format, dimension)`) so a single broken adapter shows as one cluster, exactly like SheetFidelity's mismatch clusters.

This makes the harness a **merge gate**: any format change that drops a `Full`-cap dimension fails CI before it lands.

---

## 4. Recommended Implementation Sequence

Phases for follow-up workflows. **Build the harness first** so every subsequent format change is gated by it.

**Phase 0 — Build `tools/FreeX.FormatFidelity` (gate first).**
- Scaffold the project against `WorkbookFileAdapterCatalog` (§3f), lift `FidelityCompare` helpers out of `tools/FreeX.SheetFidelity/Program.cs`, encode the `CapabilityProfile` table (§3a) and `ChainCap`/expected-loss logic (§3b/§3d).
- Implement existing-format chains only: `fxl→fxl`, `xlsx→xlsx (patch + rebuilt)`, `xlsx→xml→xlsx`, `xlsx→csv→xlsx`, `xlsx→txt→xlsx`.
- **Reuse corpora:** `ExcelExamples1.xlsx` (SheetFidelity default), the `tools/FreeX.SheetFidelity`/`FidelityCompare`/`SheetImageCompare` fixtures, and the FreeW/FreeX fidelity corpora referenced in memory. Run en-US, single-threaded (respect `ClosedXmlGate`).
- **Exit criteria:** establish the current baseline — `fxl→fxl` and `xlsx→xlsx(patch)` should be `BUGS: 0`; the `xml` chain is *expected* to surface the R1C1 + comment-author bugs as BUGs (footnotes 2/5). Lock that baseline into CI.

**Phase 1 — Harden lossy-bug adapters (gated by Phase 0).** Fix the `lossy-bug` ratings from §1 so their `Full`-cap dimensions actually round-trip:
- **SpreadsheetML (`.xml`):** implement R1C1↔A1 conversion (flip footnote-2 `Lossy→Full`), preserve comment author + rich text, fix tz-offset→UTC silent shift, fix out-of-range-date→String type corruption. Each fix flips a harness dimension to `Full` and must keep the run green.
- **XLSX full-rebuild:** where feasible, widen verbatim preservation so a rebuild drops fewer parts (or surface a loud warning) — at minimum ensure the `xlsx-rebuilt` profile in §3d accurately reflects reality so the gate is honest.
- Add a **load-warning surface** to `NativeJsonAdapter` (§1: silently-dropped unparseable refs) so `.fxl` corruption is observable.

**Phase 2 — Easy net-new formats (value-to-effort order).** Each new adapter ships with its chain added to the harness in the same PR, so it's gated from day one:
1. **CSV-UTF-8 (BOM) + Unicode-Text (UTF-16)** — encoding options on `DelimitedTextWorkbookWriter`; add `csv(utf8)`/`txt(unicode)` round-trip chains.
2. **XLTX save** — content-type switch on the XLSX writer; add `xltx→xltx` chain.
3. **SLK + DIF** — line-based reader/writer; reuse the R1C1 code from Phase 1; add `xlsx→slk→xlsx`, `xlsx→dif→xlsx`.

**Phase 3 — ODS (highest net-new ROI, medium).** Build `OdsFileAdapter` (zipped `content.xml`/`styles.xml`), map cells/styles/formulas/sheets to ODF namespaces. Add `xlsx→ods→xlsx` (the regression gate: styles/merges/charts are `Full`) plus the multi-hop ODS chains from §3e. **Dependency:** Phase 0 harness must exist — ODS is precisely the case where the `Full`-cap style/merge assertions catch adapter bugs early.

**Phase 4 — Tier-B heavy lifts (later, optional).** DBF read, HTML read+write, then XLS-write / XLSB if justified by demand — each gated by the harness, each adding its own chain.

**Dependencies & reuse summary:** Phase 0 strictly precedes everything (it's the gate). Phase 1's R1C1 work is a prerequisite for Phase 2's SLK/DIF (shared code). ODS (Phase 3) needs only Phase 0. Reuse: `FidelityCompare` helpers + value-equivalence from `tools/FreeX.SheetFidelity`; existing `.xlsx` corpora (`ExcelExamples1.xlsx`) and the FreeX fidelity corpora; `WorkbookFileAdapterCatalog`/`FileFormatResolver` for all adapter access; OpenXmlValidator round-trip check (already in SheetFidelity §5) for the xlsx hops.

---

**Key files referenced (all absolute):**
- `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/src/FreeX.App.Services/WorkbookFileAdapterCatalog.cs` — adapter registry (one-line add for new formats)
- `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/src/FreeX.Core.IO/IFileAdapter.cs` — `Load(Stream)`/`Save(Workbook,Stream)` + `FileFormatDescriptor` (`CanOpen`/`CanSave`/`OpensAsTemplate`)
- `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/src/FreeX.Core.IO/FileFormatResolver.cs` — `FindOpenAdapter`/`FindSaveAdapter` (extension resolution)
- `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/src/FreeX.Core.Model/Cell.cs`, `CellStyle.cs`, `Sheet.cs`, `Workbook.cs` — comparison extraction APIs (`GetOccupiedCellMap`, `Value`, `FormulaText`, `StyleId`, `GetStyle().NumberFormat`/borders, `MergedRegions`, `NamedRanges`, `GetStyleOnlyEntries`)
- `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/tools/FreeX.SheetFidelity/Program.cs` — harness template + reusable `NumbersMatch`/`TryNumeric`/`ValuesMatch`/`ColToLetter` helpers
- **New:** `C:/Users/anton/OneDrive/Documents/FreeX/FreeX/tools/FreeX.FormatFidelity/{FreeX.FormatFidelity.csproj,Program.cs}` — the proposed harness