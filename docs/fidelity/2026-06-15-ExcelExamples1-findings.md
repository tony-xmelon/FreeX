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

## 3. Formula recalc parity — 956 → **327** mismatches (after fixes below)
FreeX recalc (RecalcEngine.RecalculateAllFormulas) vs Excel cached `<v>`. Load values are correct;
these are **edit-time** divergences. NOTE: ~277 of the original "646" were date-serial-vs-number
representation false positives (a date and its serial number display identically); the harness now
normalizes these, so the **true** progression is 956 → **327**. Progress:

- [x] **3a array-criteria conditional aggregates** — fixed (`fc4f8e7f5`), −310. (Budget/Settings → 0.)
- [x] **named formulas (scalar)** — `DateOfFirst=DATE(...)`, `FirstWeekDay=WEEKDAY(...)` now evaluate
  (`63e95b27d`), −42 (Shift Calendar 84→42). Array-valued names still partial (see 3e).

Remaining 327, by root cause:

### 3e. [x] Dynamic-array SPILL engine on `Calc` — FIXED (`a30cbe27c` + `198c9e55a`), −214
ROOT CAUSE: the XLSX loader loaded Excel's cached spill values (plain `<v>` cells under a `t="array"`
anchor) as ordinary data cells; on recalc `IsSpillBlocked` saw them → anchor `#SPILL!` → whole spill blank
→ Calendar/Any Month (which read those cells) blank. Plus a topo-order gap (readers of spill *targets*
had no edge to the spill anchor). FIX: load cached spill values as **provisional spill cells** owned by
their anchor (so they DISPLAY on open — important because this file has no `fullCalcOnLoad`, so the app
doesn't recalc on open) while letting the anchor re-spill over them on recalc (`IsSpillBlocked` skips an
anchor's own provisional cells; `SetSpillRange`/`ClearSpillRange` clear them); plus a second eval pass for
spill-target readers. Result: **Calendar 96→1, Any Month 52→0, Calc 64→2; harness total 288→74.**
Verified on-open display: the Calc calendar grid renders all Mon–Sun columns (was blank Tue–Sun).

### 3e-orig (historical note — the cluster, now fixed above)
*Calendar* (96) and *Any Month* (52) only reference `Calc!AA/R…`; *Calc* itself (64) is the engine.
Those cells are spill targets of loaded `<f t="array" ref="D13:J18">` formulas using
`LET/SEQUENCE/FILTER/MAP/LAMBDA/XLOOKUP/TEXTJOIN` over **array-valued named formulas**
(`monthly.calendar`, `month.nums`, `cal.year`, `week.start`) and structured table columns. On recalc the
spill targets go blank. Sub-gaps: (1) **`ANCHORARRAY` is NOT implemented** (the spilled-range `#` operator
— used by `MAP(ANCHORARRAY(Z13),LAMBDA(...))`, `ANCHORARRAY(Z6)-ANCHORARRAY(X6)`); (2) loaded `t="array"`
formulas may not re-spill in full recalc (spill engine keys on `ArrayMode==Implicit`); (3) array-returning
**named formulas** as FILTER operands. This is the frontier of modern dynamic arrays; the path to ~100%.

### 3 — PROGRESS SUMMARY: 956 → **14** mismatches (98.5% reduction). Fixes (all on main, gated):
`fc4f8e7f5` array-criteria *IF(S); `63e95b27d` named formulas; `14072ada8` `tblShifts[]` whole-table ref;
`60666a3a6`+`198c9e55a` dynamic-array spill + on-open provisional-display; `eb757c99a` COUNTIF `"<>0"`
text-cell counting + **15-significant-digit comparison rounding** (Excel parity; `filters.applied` →
Calendar View 13→0); `a3a3ac9be` **`ANCHORARRAY`** (spill `#` operator) + a second spill-continuation
loader fix (Excel stores non-anchor spill cells as `<f ca="1"/>` empty-formula cells — these were
blocking the anchor's re-spill) → **Budget Summary 21→0, Data Entry (2) 13→0**.

### 3h. [x] Budget Summary (21→0) + Data Entry (2) (13→0) — FIXED (`a3a3ac9be`)
Budget Summary's SUMIFS depended on spill-continuation cells loaded as empty-formula cells; the
`<f ca="1"/>` loader fix resolved it (not a date-criteria bug after all). Data Entry fixed by ANCHORARRAY.

### Remaining **14** (hard / edge — documented):
- [-] **Pivot-cell cross-refs** (`Calc (2)` 4): `'pvt Depts'!G4` → blank vs 0. Pivot OUTPUT cells aren't
  recomputed by the formula engine (separate pivot subsystem). Minor blank-vs-0; needs pivot-recalc wiring.
- [ ] **Calc 2 / Calendar 1**: a residual `FILTER/XLOOKUP/MAP` array edge on the right side of the Calc
  engine (the `#VALUE!` Activity/Type column) — deep dynamic-array composition.
- [ ] **Happy Holidays 2, Todo List 3, Calculations 2**: small isolated array/INDEX/implicit-intersection
  edges (e.g. `Todo List!C7 = Calculations!F3:F14` array-into-scalar).

### 3f. [x] Whole-table structured ref `tblShifts[]` — FIXED (`14072ada8`), Shift Calendar 42→0
(empty-selector `[]` now resolves to the full data body; parser also no longer rejects it.)

### 3f-old. [-] (superseded) Whole-table structured ref `tblShifts[]` + VLOOKUP-array-in-IFERROR (Shift Calendar 42)
`VLOOKUP(B5,tblShifts[],3)*(MONTH(B5)=$C$12)` — empty-selector whole-table ref `tblShifts[]` returns
`#VALUE!`, and the `*RangeValue` isn't caught by the surrounding `IFERROR`. Bounded.

### 3g. [ ] `filters.applied` named cell + pivot-cell cross-refs (Calc (2) 19, Calendar View 13)
`'pvt Depts'!G4` (a PIVOT output cell) → blank on recalc (pivots aren't recomputed by the formula engine;
minor blank-vs-0). And `filters.applied = 'Calc (2)'!$C$6` evaluates TRUE in FreeX vs FALSE in Excel →
adds spurious "(6)" to text (e.g. "6 (6) people" vs "6 people"). Investigate `$C$6`'s formula.

### 3b. [~] Date-function cluster — RE-MEASURED: WORKDAY's 119 were ALL date/number false positives
(now 0). WEEKNUM (55) residual is mostly cascade from 3e (bad input dates). DATE/EDATE/EOMONTH small.

### 3a-orig. [x] Array-criteria conditional aggregates (CONFIRMED root cause, FIXED `fc4f8e7f5`)
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

## 6. Visual per-sheet — harness built (`tools/FreeX.SheetImageCompare`)
Renders each sheet via `PrintRenderer.RenderWorksheet` → FixedDocument → PNG (36 sheets). Excel ground
truth captured via COM `Range.CopyPicture` (32/36; 4 CopyPicture failures).
- **Content + layout: FAITHFUL.** All cell values, text, table structure, side panels render correctly
  and in the right places (verified Calendar, Budget, Invoice, highlight).
- **Harness limitation — fills/colors/CF/table-banding NOT shown.** `PrintRenderer` renders text + grid
  lines only; it omits cell fills, the dark header fill, table row-banding, and conditional-format fills
  (e.g. *highlight* sheet: Excel has a blue title banner, dark header, blue row banding, orange date
  cells — the FreeX **print** render is all white/black). This is a PRINT-renderer trait, NOT proof the
  app's on-screen GridView lacks them (FreeX loads CF (77 rules) + tables (16) + fills correctly per the
  inventory, and prior Partner-Dashboard work made the GridView render CF/tables/fills). **Color/CF visual
  fidelity must be verified via the GridView app or a GridView-backed render harness**, not PrintRenderer.
- Charts/images are not in the print render path (separate ChartRenderer) — see §5.

### Tooling added this pass
- `tools/FreeX.SheetFidelity` — automated load/feature/formula-parity/round-trip report (any .xlsx).
- `tools/FreeX.SheetImageCompare` — per-sheet PNG render (content/layout) + optional Excel diff.
