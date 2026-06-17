# Contextures corpus round-trip schema fidelity (2026-06-17)

Branch: `worktree-agent-ad1d155bc1271c52a`

Harness: `tools/FreeX.SheetFidelity`. Test files under
`test-corpus/public/contextures/`. Re-run with:

```
dotnet build tools/FreeX.SheetFidelity/FreeX.SheetFidelity.csproj -c Release
dotnet run --project tools/FreeX.SheetFidelity -c Release --no-build -- "<file>"
# schema-validate an input file directly (no FreeX round-trip):
dotnet run --project tools/FreeX.SheetFidelity -c Release --no-build -- "<file>" --validate-only
```

---

## Item 1 — pageSetup invalid DPI=0 on save (file 01) — FIXED

### Symptom
Round-tripping `01_pivot-tables_customer-products.xlsx` produced 2 OpenXML schema
errors at `/x:worksheet/x:pageSetup`:

```
Sem_AttributeValueDataTypeDetailed: attribute 'horizontalDpi' has invalid value '0'.
  The MinInclusive constraint failed. The value must be >= 1.
Sem_AttributeValueDataTypeDetailed: attribute 'verticalDpi'  ... (same)
```

### Root cause
The source worksheet (`sheet5.xml`) was written **by Excel itself** with
`<pageSetup orientation="portrait" horizontalDpi="0" verticalDpi="0" r:id="rId1"/>`.
Excel emits DPI=0 when the worksheet references a `printerSettings` part (the real
DPI lives in that binary part). The SpreadsheetML schema types these attributes as
`unsignedInt` with a **MinInclusive=1** facet, so `0` is schema-invalid; Excel
tolerates it on load but the strict `OpenXmlValidator(Microsoft365)` rejects it.

FreeX preserved the source worksheet bytes **verbatim** across all three save paths
(verbatim source-copy, cell patch-save, full ClosedXML save), carrying the invalid
attribute through. Confirmed via trace: the existing
`XlsxWorksheetPageLayoutNormalizer.NormalizePageSetup` runs only on load-sanitize and
the full-save schema pass; the harness's load→save-unchanged hits the fast
`CopyTo` / patch path, which bypasses `ApplyPackagePostProcessing` entirely.

### Fix
New `src/FreeX.Core.IO/XlsxWorksheetPageSetupDpiSanitizer.cs`, invoked once at load in
`XlsxFileAdapter.cs` against the source-package snapshot bytes **before** capture, so
every save path emits valid pageSetup. A cheap pre-scan keeps the common
(no-invalid-DPI) case buffer-reuse-eligible — the rezip cost is paid only for the rare
files Excel wrote with DPI=0. Stripping a non-positive DPI is lossless (Excel
re-derives it when absent; the `r:id` printerSettings reference is preserved).
`XlsxWorksheetPageLayoutNormalizer.NormalizePageSetup` was also hardened to drop DPI<1
on the full-save path (defense in depth).

Files changed: `XlsxWorksheetPageSetupDpiSanitizer.cs` (new), `XlsxFileAdapter.cs`,
`XlsxWorksheetPageLayoutNormalizer.cs`. Tests:
`XlsxWorksheetPageSetupDpiSanitizerTests.cs`, `XlsxWorksheetPageLayoutNormalizerDpiTests.cs`.

### Result
File 01 round-trip schema errors: **2 → 0**. Saved pageSetup becomes
`<pageSetup orientation="portrait" r:id="rId1" />`.

---

## Item 2 — chart extLst ext missing 'uri' (file 03) — NOT a FreeX defect (validator/source-data artifact)

### Symptom
Round-tripping `03_table-chart-slicers_task-tracker.xlsx` produced 2 schema errors at
`/c:chartSpace/c:chart/c:extLst/c:ext`:

```
Sch_UndeclaredAttribute: The 'uri' attribute is not declared.
Sch_InvalidElementContentExpectingComplex: invalid child 'c16r3:dataDisplayOptions16';
  expected 'c16r3:dispNaAsBlank'.
```

### Investigation
`xl/charts/chart1.xml` is **byte-identical** between the source file and the FreeX
round-trip (5666 bytes, verified). The `<c:ext>` already carries its correct
`uri="{56B9EC1D-385E-4148-901F-78D8002777C0}"` and namespace
`xmlns:c16r3="http://schemas.microsoft.com/office/drawing/2017/03/chart"`. FreeX's
chart XML writer does not emit any chart-level extLst; this part is preserved verbatim.

Decisive check — validating the **source file directly** (untouched by FreeX) with the
same validator reproduces the **exact same 2 errors**:

```
> dotnet run ... -- "03_...task-tracker.xlsx" --validate-only
[Sch_UndeclaredAttribute] ... uri ... :: /c:chartSpace[1]/c:chart[1]/c:extLst[1]/c:ext[1]
[Sch_InvalidElementContentExpectingComplex] ... dataDisplayOptions16 ... :: (same node)
TOTAL SCHEMA ERRORS: 2
```

### Conclusion
This is **not** a FreeX save defect. The errors are inherent to the source file's use
of the Microsoft 2017/03 chart "data display options" extension. The
`OpenXmlValidator(Microsoft365)` profile's typed schema for that ext is narrower than
what modern Excel actually writes (it expects `dispNaAsBlank` as a direct child of the
ext, but real Excel nests it under `dataDisplayOptions16`; the SDK's own
`Office2019.Drawing.Chart.DataDisplayOptions16` DOM class agrees with Excel). The
`Sch_UndeclaredAttribute` on `uri` is a knock-on of that mismatched typed model.

FreeX faithfully round-trips Excel's exact bytes, including the valid `uri`. The
task's premise (FreeX emits a uri-less `<ext>`) does not match reality. Rewriting or
dropping this preserved ext to satisfy the strict validator would **lose Excel chart
data** (the `dispNaAsBlank` setting) and diverge from what Excel itself writes — so the
preservation is left intact by design. No change.

---

## Item 3 — SheetFidelity volatile / VBA-UDF false positives — FIXED

### Root cause
The formula-parity check flagged cells whose cached value **cannot** match a recalc by
design as "mismatches":

- **Volatile** — cells calling a non-deterministic builtin (`TODAY`, `NOW`, `RAND`,
  `RANDARRAY`, `RANDBETWEEN`): cached reflects authoring time. Critically, cells that
  depend *transitively* on such a cell (e.g. `COUNTIFS`/`IF` over a `D-TODAY()` column)
  also diverge legitimately.
- **VBA-UDF** — a formula calling a name that is neither a builtin nor a workbook
  defined-name is a VBA user-defined function FreeX cannot evaluate (macros
  unsupported); recalc errors while a cached value exists.

### Fix
`tools/FreeX.SheetFidelity/Program.cs`:

- Volatile taint is seeded from direct callers of the non-deterministic set, then
  propagated **transitively** through the dependency graph populated by the recalc
  (`DependencyGraph.GetDirectDependents`, which covers exact-cell and range refs).
- VBA-UDF cells are detected by a string-literal-aware call-token scan: any identifier
  immediately followed by `(` that is neither `BuiltInFunctions.Exists` nor a workbook
  defined-name. Qualified members (`a.b(`) take the leaf name.
- Both are reported in separate labeled buckets ("volatile (excluded)",
  "VBA-UDF (excluded)") plus a per-sheet breakdown; the headline **GENUINE** mismatch
  count now reflects only real divergences. Date-serial-vs-number normalization kept.
- Conservative by construction: excludes only on a clear volatile taint or a
  provably-unknown call token. The non-deterministic set is deliberately narrower than
  FreeX's full volatile set (it omits `INDIRECT`/`OFFSET`/`CELL`/`INFO`, which are
  reference-volatile but still deterministic given the same data).
- Added a `--validate-only` mode (schema-validate an input file directly).

### Result
- File 05 (`05_conditional-formatting_expiry-dates.xlsx`): 17 reported "mismatches"
  → **0 genuine, 17 volatile excluded** (10 direct `D-TODAY()` + 7 transitive
  `COUNTIFS`/`IF` dependents). FreeX is correct.
- File 06 (`06_dynamic-array-formulas_scenarios.xlsm`): **7 volatile + 19 VBA-UDF
  excluded** (`simplearray`, `splitter`, `query`, `ranking`, `comparelists`,
  `ANCHORARRAY`, …), leaving **2 genuine** dynamic-array calc gaps
  (`SORT(...,{1,2},{1,-1})`, `UNIQUE(CHOOSE(...))`) — not in this task's domain.

---

## Verification

- `dotnet build FreeX.slnx -c Release` → succeeded, 0 warnings, 0 errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` → all green except the
  single pre-existing, unrelated, environmental failure
  `WorksheetContextMenuPlannerTests.BuildCommands_SourceKeepsStateCacheOnHotPath`
  (`TestWorkspaceFileLocator` infra; documented as a non-gating known failure).
- New IO tests (6) pass.

### Schema-error before/after (FreeX round-trip)

| File | Before | After |
|------|-------:|------:|
| 01_pivot-tables_customer-products.xlsx | 2 | **0** |
| 03_table-chart-slicers_task-tracker.xlsx | 2 | 2 (source-data/validator artifact — see Item 2) |
| 04_charts_target-range.xlsx | 0 | 0 |
| 08_comments-notes_basics.xlsx | 0 | 0 |

(File 02 `.xlsm` fails to load on a pre-existing pivot/slicer parse issue —
`Invalid range notation: 'D6'` — outside this task's domain.)

### File 05 formula-parity before/after

| Bucket | Before | After |
|--------|-------:|------:|
| headline "mismatches" | 17 | **0 genuine** |
| volatile (excluded) | 0 | 17 |
| VBA-UDF (excluded) | 0 | 0 |
