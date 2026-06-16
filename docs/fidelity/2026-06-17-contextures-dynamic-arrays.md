# Contextures dynamic-array fidelity — 2026-06-17

Test file: `test-corpus/public/contextures/06_dynamic-array-formulas_scenarios.xlsm`
(52+ array/spill formulas, 36 named ranges, data validation, VBA).

Harness: `tools/FreeX.SheetFidelity` (not in `FreeX.slnx`) —
`dotnet run --project tools/FreeX.SheetFidelity -c Release -- "<file>"`.

Branch: `worktree-agent-a7af45171ce1f6ace`.

## Defect 1 (HIGH) — round-trip reload crash

### Symptom
After FreeX saves this file (save succeeds, OpenXML schema validates 0 errors),
FreeX's own reload throws:
`System.ArgumentOutOfRangeException ... (Parameter 'index')` with top frame
`System.Linq.ThrowHelper...`.

### Root cause
Full stack showed the throw inside **ClosedXML** `XLWorkbook.LoadStyle` →
`Enumerable.ElementAt(index)`: a worksheet row referenced a cellXfs style index
that does not exist in the saved `styles.xml`.

- Original `styles.xml` has **90** `cellXfs` entries (valid 0..89).
- FreeX's full-save path rebuilds `styles.xml` via ClosedXML, which renumbers and
  shrinks `cellXfs` to **70** entries (valid 0..69).
- The worksheet metadata-preservation merge `MergeWorksheetRowAttributes`
  (`XlsxWorksheetMetadataPreserver.CellMetadata.cs`) copied each source row's
  `customFormat="1"` + `s="<idx>"` verbatim onto the rebuilt rows. The "Spill
  Formulae" sheet's row 1 carried `s="73"`, which is valid against the original
  90-entry stylesheet but **out of range** against the rebuilt 70-entry one →
  ClosedXML `ElementAt(73)` throws on reload.

The row `s`/`customFormat` indices reference the *source* stylesheet index space,
which the rebuild renumbers independently — so preserving them verbatim is wrong
for *every* such row, not just the one that happened to overflow.

### Fix
Exclude `s` and `customFormat` from the row-attribute merge
(`IsStylesheetIndexRowAttribute` in `XlsxWorksheetMetadataPreserver.MergeHelpers.cs`).
Style-independent row attributes (`ht`, `hidden`, `outlineLevel`, `collapsed`,
`customHeight`, `dyDescent`, `spans`, `thickTop`, `thickBot`, `ph`) still
round-trip; the row's default cell style is left to the rebuilt stylesheet.

Result: reload of the saved file now succeeds; schema validation stays at 0 errors.

## Defect 2 (MEDIUM) — 4 genuine native dynamic-array calc bugs

All four fixed.

### C53 `SORT(C5:E11,{1,2},{1,-1})` → was ErrorValue, cached 10
`SORT` forced `sort_index`/`sort_order` through `TryGetScalarControlArgument`,
which rejects any non-1×1 array. Excel allows a 1-D vector for each, defining a
multi-key sort. Now reads both controls as flat numeric vectors and compares keys
in priority order (single `sort_order` broadcasts across keys; default ascending;
stable for ties). `BuiltInFunctions.DynamicArrays.FilterSort.cs`.

### H29 `UNIQUE(CHOOSE({1,2},C5:C11,E5:E11))` → was ErrorValue, cached 10
`EvaluateChooseIndexRange` forced each selected branch to match the index range's
own shape and returned `#VALUE!` otherwise. Excel broadcasts an array `index_num`
against the selected branches — a 1×N index over M-row column vectors yields an
M×N matrix (the "stack columns" idiom). Now computes the result shape as the
broadcast of the index dims with every selected branch's dims and indexes both
with per-axis broadcasting. `FormulaEvaluator.ControlFlow.cs`.

### C190 `SORT(ANCHORARRAY(C184))` → was #REF!, cached 11
`C184 = C6:E8` is a dynamic-array formula whose body is a bare range reference.
FreeX's top-level `EvaluateRange` collapsed it to its top-left cell via implicit
intersection, so C184 never established a spill range; `ANCHORARRAY(C184)` then
found no spill extent → `#REF!`. Added `FormulaEvaluator.EvaluateSpilling`, which
routes a top-level reference-like node through the array-operand path (full
`RangeValue`) so it spills; `RecalcEngine` uses it for `FormulaArrayMode.Dynamic`
cells. Legacy/Implicit cells keep implicit-intersection; single-cell refs (`=A1`)
unaffected. `FormulaEvaluator.cs`, `RecalcEngine.cs`.

### D197 `SUMIFS(E5:E11,C5:C11,ANCHORARRAY(C197),D5:D11,ANCHORARRAY(D196))` → was RangeValue (wrong shape), cached 20.4
`C197` spills a column vector (4×1) and `D196` spills a row vector (1×6). The
array-criteria expansion recursed on the *first* array only; the recursive call
expanded the second array as a fresh "first array", producing a RangeValue whose
elements were themselves RangeValues (nested, wrong shape). After spill the anchor
held a nested RangeValue. Now collects every array-criteria slot up front and
broadcasts them together into one matrix
(`ExpandConditionalArrayCriteriaMulti`). `BuiltInFunctions.ConditionalAggregation.cs`.

## Out of scope (correctly remaining as mismatches)
- VBA UDFs (FreeX doesn't run VBA): QUERY, COMPARELISTS, JOIN, SPLITTER,
  REGEXLIST, SIMPLEARRAY, RANKING, CROSSCHECK, FORMULACOUNT.
- Volatile (non-deterministic): RANDARRAY, SORTBY(...RANDARRAY...),
  SEQUENCE(...,TODAY()), TEXT over a TODAY result.

## Verification
- `dotnet build FreeX.slnx -c Release` — 0 warnings, 0 errors.
- Formula suite: 2944 passed / 7 skipped. Calc suite: 783 passed / 24 skipped.
- Harness on file 06: reload SUCCESS (was crashing); recalc completes without
  exception; OpenXML schema 0 errors; all four target cells now match cached;
  only the VBA/volatile mismatches remain.
