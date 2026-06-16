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

### 3 — PROGRESS SUMMARY: 956 → **0** mismatches = **100% recalc parity**. Fixes (all on main, gated):
`fc4f8e7f5` array-criteria *IF(S); `63e95b27d` named formulas; `14072ada8` `tblShifts[]` whole-table ref;
`60666a3a6`+`198c9e55a` dynamic-array spill + on-open provisional-display; `eb757c99a` COUNTIF `"<>0"`
text-cell counting + **15-significant-digit comparison rounding** (Excel parity; `filters.applied` →
Calendar View 13→0); `a3a3ac9be` **`ANCHORARRAY`** (spill `#` operator) + a second spill-continuation
loader fix (Excel stores non-anchor spill cells as `<f ca="1"/>` empty-formula cells — these were
blocking the anchor's re-spill) → **Budget Summary 21→0, Data Entry (2) 13→0**.

### 3h. [x] Budget Summary (21→0) + Data Entry (2) (13→0) — FIXED (`a3a3ac9be`)
Budget Summary's SUMIFS depended on spill-continuation cells loaded as empty-formula cells; the
`<f ca="1"/>` loader fix resolved it (not a date-criteria bug after all). Data Entry fixed by ANCHORARRAY.

### 3 — FINAL: 956 → **1** mismatch (99.97% recalc parity). Last-14 fixes (`d16b1c832`,`cee7df9f1`):
- [x] **Empty-cell reference → 0** (Calc (2) 4): a bare `='pvt Depts'!G4` to an EMPTY cell now returns 0
  (Excel semantics) via `NormalizeTopLevelResult`; `ISBLANK`/`&""` still behave (empty).
- [x] **`SUBTOTAL(funcNum, OFFSET(ref,{array},…))`** (Happy Holidays 2): per-element OFFSET-array
  evaluation in `SubtotalAggregateFastPaths` (the visible-row-mask idiom).
- [x] **`SORT` blank-last + stable** (Calculations 2 + Todo List 2): blanks sort to the bottom regardless
  of order; ties keep original order (Excel SORT is stable). `SORT` sort_index was already correct.
- [x] **Error-in-both** (Calc N13/S13, Calendar AJ6): `Calc!N13` is `t="e"` cached `#VALUE!` IN THE FILE
  (Excel errors there too — no Plan dates ≥ TODAY); harness now counts error-vs-error as a match (parity).

### [x] LAST cell — FIXED (`fa233f888`): `Todo List!G7` SORT/FILTER tail order → **0 mismatches (100%)**
ROOT CAUSE: ClosedXML's `CellsUsed()` silently OMITS cells whose `t="s"` shared-string is the empty
string `""` (it reports them as empty/absent). So 10 Due-date cells holding `""` loaded as `BlankValue`
instead of `TextValue("")`. SORT then grouped the truly-blank "Ongoing" row with the `""` rows and ordered
them wrong vs Excel (which keeps `""` rows in source order and the truly-empty one last). FIX
(`XlsxFileAdapter` + the worksheet cell-layout readers, DOM + streaming paths): detect `t="s"` cells with
a `<v>` whose SST entry is `""` and load them as `TextValue("")`. More Excel-faithful generally (ISBLANK
of such a cell is now correctly FALSE). Result: **`Calculations!B3:C24` matches Excel exactly → harness 0.**

## 3 — RESULT: 956 → **0** recalc mismatches = **100% functional parity** on all 36 sheets. Full
DefaultTests gate green; on-open display verified intact.

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

## 5. Charts — MEASURED + first fix landed

The file actually contains **20 classic charts (`chart1..20.xml`) + 1 funnel `chartEx1.xml`** = 21
chart parts (the earlier "21 classic + 1 funnel" was approximate).

### 5.0 Measurement harness — `tools/FreeX.ExcelExamplesCharts`
New tool (NOT in FreeX.slnx — `dotnet build tools/FreeX.ExcelExamplesCharts -c Release` first). It:
(A) loads the file in FreeX, enumerates every chart, renders each to PNG (records type / renderable /
rendered / visibly-blank); (B) opens the SAME file in a single en-US Excel COM instance and exports
every chart PNG as ground truth, then diffs (mean per-pixel %) matched per-sheet by chart index;
(C) round-trips (FreeX save → reopen in Excel) and counts charts retained per sheet. Run:
`dotnet run --project tools/FreeX.ExcelExamplesCharts -c Release --no-build -- "E:\Users\anton\Downloads\ExcelExamples1.xlsx" <outDir>`
(append `--no-excel` to skip the COM passes). Output: `REPORT.md` + side-by-side `worst/` composites.

### 5.1 Measured baseline (per chart-bearing sheet)
FreeX loads **20/21** charts (all 20 classic; the chartEx funnel is NOT loaded as a ChartModel).
Charts live on 5 sheets: Budget v Actual (12), Budget Summary (3), Data Entry (2) (3),
Budget - 2013 or lower (1), todo (1).
- **Render**: 20/20 rendered to PNG; **1 visibly blank** (todo StackedBar).
- **Render diff vs Excel** (11 charts had a valid Excel ground-truth PNG; the other 9 are the tiny
  "Budget v Actual" mini-charts whose Excel `chart.Export` produced 0-byte PNGs — an Excel-COM export
  quirk, not a FreeX gap): mean **10.2% → 9.3%** after the clustered-column fix below; max ~20%.
- **Round-trip (IO): PERFECT.** After FreeX save→reopen, Excel sees the exact original chart count on
  every sheet (20/20). The `chartEx1.xml` part ALSO survives byte round-trip (pass-through preserved) —
  so the funnel is an on-screen render gap, NOT an IO data-loss.

### 5.2 [x] FIXED — clustered Column charts rendered overlapping/stacked (`905f647d1`)
ROOT CAUSE (renderer, not loader): the loader correctly typed `grouping="clustered"` + `barDir="col"`
as `ChartType.Column`, but `ChartRenderer` placed EVERY series' `RectangleBarItem` at the same x-window
`[i-half, i+half]` centred on the category index, so multiple series overdrew each other (the taller,
last-drawn series hid the rest — looked stacked). FIX (`ChartRenderer.cs` +
`ChartRenderer.SeriesFormatting.cs`): count the clustered (non-combo-line/scatter) column series and give
each a disjoint `1/N` sub-slot within the category bar width via `ClusteredBarOffsets(...)`, so the bars
sit side by side as Excel renders them. TDD test
`ClusteredColumnChart_PlacesSeriesSideBySideWithinCategorySlot` (asserts disjoint x-windows). Verified
visually on "Budget v Actual": Budget+Actual now cluster correctly (was overlapping). 144 ChartRenderer
tests green. NOTE: single-series Column/stacked/bar paths are unchanged (cluster count ≤ 1 ⇒ full slot).

### 5.3 Prioritized remaining chart gaps (out of scope this pass)
- [ ] **todo StackedBar renders blank (progress-bar idiom).** `chart20.xml` is a stacked bar built from
  **12 single-cell series** (`todo!$J$4 … $J$15`, each `ptCount=1`, NO `<c:cat>`). FreeX's chart model
  uses ONE rectangular `DataRange` (series = columns), so the 12 single-cell series collapse into one
  column J × 12 rows with **0 categories** → the stacked-bar builder skips every point (`i >= categories.Count`,
  count 0) → blank. Excel draws a single ~45% horizontal progress bar (J4=0.30 + J5=0.15). A correct fix
  needs per-series range awareness (each series = its own cell) which the single-`DataRange` model cannot
  express — ARCHITECTURAL, deferred (risk of regressing all bar/column charts). Bounded interim option:
  detect "N stacked series each a single cell in one column, no cat" and synthesize N series of 1 point.
- [ ] **Funnel `chartEx1.xml` not rendered.** Loaded as a pass-through part (survives round-trip) but not
  materialised into a `ChartModel`, so it shows nothing on screen. LOW impact here: this particular
  chartEx is a degenerate `layoutId="treemap"` funnel with **`ptCount="0"` (zero data points)** — even
  Excel renders it essentially empty. General chartEx rendering (funnel/treemap/sunburst from the
  `cx:` namespace) is the real feature; this file isn't a good driver for it.
- [ ] **Budget v Actual overlay deviation columns + emoji/percent annotations** (residual ~8–20% diff on
  the main "Budget vs. Actual Performance" chart): Excel overlays small green/blue deviation bars and
  thumbs-up/down emoji + "30%/5%/…" labels above each category. FreeX renders the clustered base bars
  faithfully but omits these decorations. Combo/overlay + emoji data-labels — separate, larger feature.
- [-] **Measurement caveat — chart index matching.** The harness matches FreeX charts to Excel charts by
  per-sheet ordinal; Excel's `ChartObjects` z-order ≠ FreeX load order on "Budget v Actual" (12 charts),
  so a couple of diff rows compare mismatched charts (e.g. a FreeX 2-series chart vs an Excel 4-series
  chart). Affects ranking only, not the fixes; a position/anchor-based matcher would tighten it.

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

### 6b. [x] GridView-backed visual harness + table-style rendering (color/CF parity)
- **`tools/FreeX.SheetGridImageCompare`** renders each sheet headlessly via the REAL `GridView` control
  (off-screen `RenderTargetBitmap` of a full-sheet `ViewportModel`), so cell fills, CF fills/data-bars, and
  table styling ARE included. Confirmed on the *highlight*/*Data* sheets (fills/CF/orange date cells show).
- **[x] FIXED — loaded table styles now render.** Excel keeps `TableStyleMediumN` (header + row-stripes)
  DYNAMIC; FreeX rendered loaded tables PLAIN. Added `StructuredTableStyleService.ApplyLoadedTableStyles`
  (mirrors the pivot-style materializer) + a shared `StructuredTableStyleBandingResolver`, called from
  `WorkbookOpenService` with patch-snapshot rebase. All 16 tables now show their blue/banded header +
  alternating row stripes, closely matching Excel.
- **[x] FIXED — latent save-fidelity bug** surfaced by the table work: `XlsxSourcePackage.Rebase` was
  NULLING the model fingerprint, so `Matches()` always returned false after ANY dynamic-style
  materialization → the byte-copy fast path was skipped → a full rebuild **leaked the materialized fills
  into the saved `styles.xml`** (affected pivots too, just untested). Fixed `Rebase` to recompute the
  fingerprint from the materialized workbook. Verified: real-file load→materialize→rebase→save is now
  **byte-for-byte identical to source** (`styles.xml` 145135==145135 bytes, no leak); full gate green.

### Tooling added this pass
- `tools/FreeX.SheetFidelity` — automated load/feature/formula-parity/round-trip report (any .xlsx).
- `tools/FreeX.SheetImageCompare` — per-sheet PNG render (content/layout, print path) + optional Excel diff.
- `tools/FreeX.SheetGridImageCompare` — per-sheet PNG via the real GridView (WITH fills/CF/table styling).
