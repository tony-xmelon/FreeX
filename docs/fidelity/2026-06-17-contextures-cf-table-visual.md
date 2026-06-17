# Contextures CF / Table visual fidelity — GridView render (2026-06-17)

Domain: GridView rendering of **table styles**, **AutoFilter dropdown chrome**, and
**conditional-format fills**. Branch: `fidelity-contextures-cf-table-visual`.

Primary test file: `test-corpus/public/contextures/05_conditional-formatting_expiry-dates.xlsx`
(sheet *LicenceData*, table `tblLic` = `B2:G12`).

Harness: `tools/FreeX.SheetGridImageCompare` (renders the real WPF `GridView` off-screen to PNG).

## Ground truth (Excel)

`docs/fidelity/2026-06-17-excel_05_LicenceData_GROUNDTRUTH.png`

- Header row B2:G12 = **solid black** (0,0,0) fill, **white bold** text.
- Every header column carries a **filter-arrow dropdown button**; ExpiryDate also shows a sort glyph.
- Rows 1–7 highlighted **gold** (255,217,102); rows 8–10 white. (Gold = CF rule `$F3<=30` true.)

## Before (FreeX, stale)

`docs/fidelity/2026-06-17-freex_05_LicenceData_BEFORE.png`

- Header = generic **grey** (217,217,217), no dropdown buttons.
- Only **row 1** highlighted gold (FreeX rendered the file's *cached* `DaysToExpiry` values; only
  one cached value happened to be ≤ 30).

## Root causes

1. **AutoFilter dropdowns missing.** The autofilter for this file lives ONLY inside the table part
   (`xl/tables/table1.xml` → `<autoFilter ref="B2:G12"/>`); there is **no worksheet-level
   `<autoFilter>`**. `GridView.RenderAutoFilterButtons` is fully implemented but gated on
   `AutoFilterRange`, and `AutoFilterDropdownPlanner.TryGetAutoFilterRange` only read
   `sheet.AutoFilter` — so a table-scoped filter produced no range and no buttons (in the real app too).

2. **Header rendered grey, not black.** `tableStyleInfo name="TableStyleLight8"`. Excel's built-in
   *Light* styles **8–14** are the black-header variants (solid black header + white bold font +
   white body). `StructuredTableStyleBandingResolver` had no branch for them, so they fell through to
   the accent-palette fallback → `LightAccents[(8-1)%7] = LightAccents[0] = (217,217,217)` grey.
   (The black header is NOT from the cell style — header cells are `fillId=0`/`fontId=0` — nor from
   `headerRowDxfId="4"`, which is alignment-only. It is the dynamic table style.)

3. **CF highlighted the wrong rows.** Rule = `type="expression"`, `<formula>$F3&lt;=30</formula>`,
   `dxfId=0` (fill `bgColor theme=7 tint=0.4` = the gold). Column F `DaysToExpiry` = calculated column
   `=D3-TODAY()`. The harness rendered cached values without recalc, so the volatile TODAY-driven
   column was stale and CF matched only the one cached ≤30 row. **The CF engine itself was correct.**

## Fixes

- `src/FreeX.Core.Commands/StructuredTableStyleBandingResolver.cs` — intercept `TableStyleLight8`–
  `TableStyleLight14` and resolve to a black header (`HeaderFill=Black`, `HeaderFontColor=White`,
  white body), before the accent-palette fallback.
- `src/FreeX.App.Host/AutoFilterDropdownPlanner.cs` — `TryGetAutoFilterRange` now falls back to the
  first structured table with `HasAutoFilter` when there is no worksheet `<autoFilter>` (worksheet
  autofilter still takes precedence). This fixes the real app AND the harness.
- `tools/FreeX.SheetGridImageCompare/Program.cs` — (a) `RecalcEngine.RecalculateAllFormulas` after
  load so volatile/date cells + CF reflect *today* like the real open pipeline; (b) set
  `GridView.AutoFilterRange` via the planner so header dropdowns render.

## After (FreeX)

`docs/fidelity/2026-06-17-freex_05_LicenceData_AFTER.png`

- Header = **black**, white bold text — matches Excel.
- **Filter dropdown buttons** on every header column (B–G) — matches Excel.
- Rows **1–7 gold** (gold = 255,217,102, pixel-identical to Excel), rows 8–10 white. `DaysToExpiry`
  recalculated to (-363,-299,-248,-189,-156,-155,10,55,150,193) — identical to Excel's cached values.

**CF after recalc matches Excel: YES** (7 highlighted rows in both; same rows; same gold color).

## Cross-check

- `03_table-chart-slicers_task-tracker.xlsx` (table `Table1`, also TableStyleLight8): header now
  renders black (verified by pixel sample at the header band) with dropdown buttons on each column —
  confirms the fix generalizes and is not over-applied (only Light 8–14 go black).
- `01_pivot-tables_customer-products.xlsx`: renders without error.

## Verification

- `dotnet build FreeX.slnx -c Release` — succeeded, 0 warnings / 0 errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` — exit 0, all green.
  One pre-existing assertion (`TableStyleGalleryPlannerTests.GetOptions_…`) used an ambiguous
  `HeaderFill != default` check; black == `default(CellColor)`, so it was updated to assert
  contrast (header font ∈ {black,white}) and that the gallery now legitimately contains a
  black-header style — reflecting the corrected Light 8–14 behavior.

## New tests

- `tests/FreeX.Core.Model.Tests/StructuredTableStyleBandingResolverTests.cs` — Light 8/9/10/14 →
  black header, white font, white body.
- `tests/FreeX.App.Host.Logic.Tests/AutoFilterDropdownPlannerTests.TableAutoFilter.cs` — table
  `HasAutoFilter` fallback; worksheet autofilter precedence; table-without-filter ignored.
