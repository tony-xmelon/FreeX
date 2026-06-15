# Fidelity findings — ExcelExamples1.xlsx (2026-06-15)

Source: `E:\Users\anton\Downloads\ExcelExamples1.xlsx` (36 visible sheets, real-world template
collection: calendars, planners, Gantt charts, budgets, invoices, todo lists, funnel charts).
Discovery harness: `tools/FreeX.SheetFidelity` (load + unsupported-features + structural inventory +
formula-parity recalc-vs-cached + round-trip schema validation). Run with:
`dotnet run --project tools/FreeX.SheetFidelity -c Release -- "E:\Users\anton\Downloads\ExcelExamples1.xlsx"`

## Status legend
- [ ] open  [~] in progress  [x] fixed/verified  [-] out of scope / won't-fix (documented)

## 1. Load — CLEAN
FreeX loads the file with **zero warnings/exceptions**. On open, displayed (cached) values match Excel.
All divergences below are either (a) **recalc-time** (manifest when the user edits) or (b) **visual /
feature** gaps.

## 2. Unsupported features (silently dropped on load) — 37 flags, 4 kinds
- [ ] **FormControls** (dominant): checkboxes/option-buttons/spinners on sheets *Shift Calendar*,
  *Shift Data*, *Inputs*, *pvt Depts* (+ vmlDrawing4-7, 18 ctrlProps). Visible gap (missing controls).
- [-] **PowerQuery** (`xl/connections.xml`, workbook query connections) — large feature, out of scope.
- [-] **LinkedDataTypes** (`xl/richData/*`) — rich/linked data types, out of scope.
- [-] **DataModel** (`xl/model/item.data`) — Power Pivot data model, out of scope.

## 3. Formula recalc parity — 956 / 3575 mismatches (26.7%)
FreeX recalc (RecalcEngine.RecalculateAllFormulas) vs Excel cached `<v>`. Load values are correct;
these are **edit-time** divergences. Multiple distinct root causes (this is a long road):

### 3a. [~] Array-criteria conditional aggregates (CONFIRMED root cause, fix dispatched)
`Budget!G4 = IFERROR(SUMPRODUCT(G7:G26, SUMIFS(freqs[Multiplication factor],freqs[Frequency],H7:H26))/12,0)`
→ cached 951, recalc **0**. The SUMIFS criteria arg `H7:H26` is a 20-cell **range**, so Excel returns a
20-element array (consumed by SUMPRODUCT). FreeX apparently treats it as scalar / errors → `IFERROR→0`,
which then **cascades** to every cross-sheet cell that reads it (`Settings!I6 = 'Budget...'!G4`, etc.).
Affects sheets *Budget* (15/15), *Budget - 2013 or lower* (15/15), *Settings* (18/32). Structured refs
themselves resolve fine (resolver gets the workbook); the gap is array/vector criteria in `*IFS`.

### 3b. [ ] Date-function cluster (WORKDAY 119, WEEKNUM 55, NETWORKDAYS) + cascades
Worst sheets: *Quick Gantt* (238/260), *Inputs* (250/400), *Calendar* (99/159), *Shift Calendar*
(84/85), *Any Month* (53/92), *Calendar View* (18/134). Symptoms include `#REF!`/`#DIV/0!` appearing
on recalc where Excel has a clean date/number (e.g. `'Calc (2)'!C73` → `"6#DIV/0! people"` vs `"6 people"`;
`Calendar View!E6 → #REF!`). Functions are all implemented — likely bad inputs cascading and/or specific
date-serial / array edge cases. Needs per-cluster root-cause once 3a lands (some may resolve as cascades).

### 3c. [ ] COUNTIF/COUNTIFS cluster (156 + 100) — likely array-criteria + cascade, same family as 3a.

### 3d. [ ] LEFT (91), TEXT (19), IF (52), LET (16), INDEX (6) — mostly **cascade victims** (their inputs
came from 3a/3b roots, e.g. `LEFT` wrapping a value that became `#DIV/0!`). Re-measure after roots fixed.

## 4. Round-trip
- [ ] **Reload exception**: after FreeX save, reloading the saved file throws
  `NotImplementedException: Array formulas not implemented` (ClosedXML `SignatureAdapter.ToText`).
  FreeX writes a formula form ClosedXML re-evaluates as an array formula and chokes. Investigate the save
  of array/spill formulas. (The file itself opens; it's FreeX's own reload that fails.)
- [-] **1 schema error**: `connections.xml/connection[2] type='102'` exceeds schema MaxInclusive=8. This is
  a pass-through of the source file's PowerQuery connection (Excel itself wrote type=102). Non-blocking for
  real Excel; tied to the out-of-scope PowerQuery feature.

## 5. Charts — TBD (21 classic + 1 funnel chartEx). Run ChartFileCompare on this file.

## 6. Visual per-sheet — TBD (needs app capture; no headless WYSIWYG renderer).
