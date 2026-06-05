# Implicit intersection (legacy array-in-scalar formulas) — design

**Date:** 2026-06-06
**Status:** Approved design, ready for implementation plan

## Problem

A legacy formula that uses a range in a scalar context — e.g. `=A7:J7*B15` typed into a single cell in
pre-dynamic-array Excel — resolves the range to the single intersecting cell (the implicit `@` operator) and
produces a **scalar**. FreeX instead treats every array-producing formula as a dynamic array, broadcasts the
range, and **spills**; when the spill collides with occupied neighbours it yields `#SPILL!`, which then
cascades wrong values into dependents.

The on-demand FreeX↔Excel compute-fidelity sweep surfaced this on POI's `FormulaEvalTestData` /
`MatrixFormulaEvalTestData` fixtures (e.g. `J59 =A7:J7*B15` → Excel `-4`, FreeX `#SPILL!`; `H83 =-G11:I11`;
`N104 =ACOS(K8:N8)`). It affects real older workbooks that did array math without Ctrl-Shift-Enter.

## Root cause

The same formula text means different things depending on the formula's *mode*:

- **Implicit / legacy** (plain `<f>`): a range used in scalar context is implicitly intersected → scalar.
- **Dynamic array** (`<f t="array">` + dynamic metadata): the range broadcasts and spills.

FreeX has **no way to distinguish them**: `Cell` stores only `FormulaText` (no formula-mode flag), and the
xlsx loader reads `xlCell.FormulaA1` (`XlsxFileAdapter.cs`), discarding the array/dynamic distinction. FreeX
therefore applies dynamic-array (spill) semantics to everything. Binary operators broadcast ranges
(`FormulaEvaluator.Operators.cs`); `CurrentCellAddress` is already available during evaluation
(`FormulaEvaluator.Contexts.cs`); a partial implicit-intersection already exists for named ranges
(`FormulaEvaluator.References.cs`).

## Scope

Full round-trip (chosen): detect on load, evaluate implicit intersection, and preserve the distinction on
save so a load→edit→save→reload keeps formulas behaving the same.

## Approach (A): per-cell `ArrayMode` flag + result-level intersection

### 1. Model — `Cell.ArrayMode`

Add `enum FormulaArrayMode { Dynamic, Implicit }` and `Cell.ArrayMode` (default `Dynamic`). `Dynamic` is the
default because it preserves FreeX's current behaviour and matches modern Excel's default for newly authored
formulas. The loader explicitly sets `Implicit` for legacy formulas; authoring/editing a formula yields
`Dynamic`. `Cell.Clone()` copies `ArrayMode`.

### 2. Detect (load)

In the xlsx loader, classify each formula cell:

- stored as a **non-array** formula (plain `<f>`) → `ArrayMode = Implicit`;
- stored as an **array** formula (`<f t="array">`, legacy-CSE or dynamic) → `ArrayMode = Dynamic` (keeps the
  current spill behaviour).

The array flag comes from ClosedXML's array-formula API if it exposes it; otherwise from the raw worksheet
XML FreeX already snapshots for the package-preserving save path. The implementation plan selects the exact
source after verifying ClosedXML's capability.

### 3. Evaluate — one intersection point in `RecalcEngine`

Pure helper `ImplicitIntersect(RangeValue r, CellAddress cell) → ScalarValue`, using the range's absolute
start coordinates:

- `r` is 1×1 → `r[0,0]`;
- single row (`RowCount == 1`) → if `cell.Col` within the range's columns, `r[0, cell.Col - r.StartCol]`,
  else `#VALUE!`;
- single column (`ColCount == 1`) → if `cell.Row` within the range's rows, `r[cell.Row - r.StartRow, 0]`,
  else `#VALUE!`;
- 2-D → if `cell.Row` and `cell.Col` both within range, the intersecting element, else `#VALUE!`.

In `RecalcEngine`, when a cell's formula yields a `RangeValue`:

- `ArrayMode == Implicit` → store `ImplicitIntersect(result, addr)` (a scalar); do **not** spill;
- `ArrayMode == Dynamic` → spill exactly as today.

Dependents read the resulting scalar normally. This is the single behavioural change in evaluation.

### 4. Save — round-trip

- **Unchanged cells:** byte-copied/patched, so their raw `<f>` (and any dynamic metadata) round-trips
  verbatim. This covers the legacy-file case end-to-end with no new save code.
- **Rebuilt cells (changed/new):** `Implicit` → plain `<f>` (ClosedXML default); `Dynamic` array-producing
  formulas → written as an **array formula** (e.g. ClosedXML `CreateArrayFormula` over the spill range) so
  they reload as `Dynamic` rather than being mis-detected as `Implicit`.

## Documented compromise (result-level vs reference-level)

Result-level intersection is **exact for element-wise formulas** — every surfaced case (`A7:J7*B15`,
`-G11:I11`, `ACOS(K8:N8)`) — because applying the function element-wise and then intersecting the output at
the cell's row/column lands on the same element as intersecting the input references would.

It is **approximate for reshaping functions** used directly in a legacy single cell (e.g. `TRANSPOSE`, an
array-returning `INDEX`), where the output array's geometry differs from the inputs and the intersected
position can diverge from Excel. These are vanishingly rare in real workbooks. The faithful upgrade is
reference-level `@` (Approach B): apply implicit intersection at each range reference in scalar context,
threading scalar-vs-array context through the AST. That is a much larger, riskier evaluator change and is
explicitly deferred.

## Components / boundaries

- `FormulaArrayMode` enum + `Cell.ArrayMode` (Core.Model) — data only.
- Loader classification (Core.IO) — sets `Implicit` for plain formulas.
- `ImplicitIntersect` helper (Core.Calc, next to `RecalcEngine`) — pure function, independently testable.
- `RecalcEngine` result handling (Core.Calc) — chooses intersect vs spill by `ArrayMode`.
- Save path (Core.IO) — writes `Implicit`/`Dynamic` forms; unchanged cells preserved by existing byte-copy.

## Error handling

- Off-axis intersection (cell's row/col not within the range) → `#VALUE!` (Excel's behaviour).
- 1×1 ranges always resolve to their single cell regardless of position.
- A `RangeValue` lacking meaningful absolute coordinates cannot occur for `Implicit` formulas (those derive
  from range references and carry source coordinates); dynamic-only constructs (`SEQUENCE`, `FILTER`, …) are
  `Dynamic` and continue to spill.

## Testing

- `ImplicitIntersect` unit tests: 1×1, single-row, single-column, 2-D, and off-axis `#VALUE!`.
- Evaluation: `Implicit` formulas (`=A7:J7*B15`, `=-G11:I11`, `=ACOS(K8:N8)`) intersect to the correct
  scalar at in-range cells and `#VALUE!` off-axis; `Dynamic` formulas (`=A1:A10*2`) still spill.
- Load: plain `<f>` array-producing formula → `Implicit` (intersects); CSE/dynamic array → `Dynamic` (spills).
- Round-trip: legacy `Implicit` survives load→save→reload (byte-copy and rebuild paths); authored `Dynamic`
  survives as `Dynamic`.
- Regression: full Core.Formula / Core.Calc / Core.IO suites; the compute-fidelity sweep on
  `FormulaEvalTestData` (the `#SPILL!` cases become correct scalars).
