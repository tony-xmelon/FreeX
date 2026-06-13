# PivotTable Excel-Parity Hardening — Design

Date: 2026-06-13
Status: Approved for phased implementation
Branch base: `main`

## Context

FreeX already has an extensive PivotTable implementation: model
(`PivotTableModel`), refresh/materialization engine
(`PivotTableRefreshService.*`), XLSX read/write, slicers/timelines, styles,
GETPIVOTDATA, calculated fields/items, Show Values As, filters, sorting,
grouping, and a large UI surface. The Insert-tab parity doc already classifies
PivotTable as "Partial" with a very long list of working sub-features.

This effort is **parity hardening**, not greenfield: find and fix concrete,
verifiable divergences from Excel's documented behavior. Because the local Excel
instance cannot author reference PivotTables, correctness is anchored to Excel's
documented semantics, and visual/round-trip fidelity is verified by (a) tests
asserting exact materialized cell positions/values and (b) saving FreeX-authored
pivots to XLSX, validating schema with OpenXmlValidator, and opening in the real
Excel COM instance to confirm the workbook loads and renders without repair.

## Confirmed Gaps (with evidence)

### G1 — Calculated fields with non-linear formulas compute the wrong number (P1, data integrity)
`GetDataFieldValue` (`PivotTableRefreshService.Aggregates.cs:244`) evaluates a
calculated field's formula **per source row** and returns it as a synthetic cell
value; `Aggregate` then sums those per-row results. Excel evaluates a calculated
field on the **sum of each constituent field** within the group. Linear formulas
(`Revenue*0.1`) coincidentally match; non-linear ones (`Revenue/Units`,
`FieldA*FieldB`) are silently wrong: FreeX yields `Σ(Rᵢ/Uᵢ)`, Excel yields
`(ΣRᵢ)/(ΣUᵢ)`. Also: Excel always aggregates constituent fields with SUM
regardless of the data field's summary function.

### G2 — "% of Parent" Show Values As modes are wrong for nested fields (P1)
`DisplayAggregate` (`Aggregates.cs:150-164`) maps
`PercentOfParentRowTotal → RowTotalRows`, `PercentOfParentColumnTotal →
ColumnTotalRows`, `PercentOfParentTotal → GrandTotalRows` — i.e. identical to the
non-parent percent modes. Correct only at a single nesting level (which is all
the existing test exercises). Excel divides by the **immediate parent group's**
total. `PercentOfParentTotal` additionally has a configurable base field whose
parent total is the denominator.

### G3 — Subtotals render at only one nesting level (P1, visual + functional)
`WriteRowPivot` (`Writers.cs:47`) and `WriteMatrixPivot` (`MatrixWriter.cs:84`)
build the subtotal key with `Take(rowFields.Count - 1)`, producing subtotals only
for the innermost parent level. With 3+ row fields Excel emits subtotals at
**every** outer level. Confirmed by
`Refresh_CompactReportLayoutUsesSubtotaledFieldCaptionForNestedSubtotals`, which
asserts only Quarter-level subtotals for a 3-field pivot and no Region-level
subtotal.

### G4 — Nested column fields produce no column subtotals (P2)
`WriteMatrixPivot` writes one value column per **leaf** column key plus the grand
total; outer column groups get no subtotal column. Excel emits a subtotal column
per outer column group (subject to ShowSubtotals).

### G5 — Compact layout space-joins nested row labels (P2, visual)
`Writers.cs:75` / `MatrixWriter.cs:138` write `string.Join(" ", key.Values)` into
a single cell ("East Q1"). Excel compact layout places each row-field level on its
**own indented row** (outer item, then indented inner items), with the data value
for an outer row being that group's subtotal (or blank). This is the largest
visual divergence and the most test-churn-heavy change.

### G6 — Calculated items only work for a single row-only field (P2)
`Writers.cs:109` materializes calculated items only when `rowFields.Count == 1`
and only in the row-only layout; matrix and nested layouts ignore them.

### G7 — Min/Max/Product/StdDev/Var of an all-non-numeric group return 0 (P3)
`Aggregate` (`Aggregates.cs:68-87`) returns `0` when `numericCount == 0`. Excel
shows a blank cell for Min/Max/Product/StdDev/Var when a non-empty group has no
numeric values. (Empty intersections are already handled via `isEmptyIntersection`.)

### G8 — Locale-sensitive string matching in Show Values As (P3, consistency)
`RunningTotal`/`RankValue`/`BaseItemAggregate`/`EvaluateCalculatedItem`
(`Aggregates.cs:183-282`) use `CurrentCultureIgnoreCase`. Same Turkish-I class the
2026-06-11 comprehensive review flagged for GETPIVOTDATA. Switch to `Ordinal`/
`OrdinalIgnoreCase` to match item identity by codepoint.

## Approach

Phased, each phase independently verifiable and shippable. File contention is
high across `Aggregates.cs`, `Writers.cs`, `MatrixWriter.cs`, so phases run
**sequentially** (per FreeX's low-contention sequential-work convention), each
driven by a sonnet implementation agent using TDD, verified inline before the
next phase starts.

- **Phase 1 — Aggregation correctness** (`Aggregates.cs`, `PivotCalculatedExpressionEvaluator.cs`)
  - G1: compute calculated fields on summed constituent fields. Introduce a
    field-sum resolver passed to the expression evaluator; aggregate constituent
    fields with SUM per group, then evaluate the formula once per group.
  - G7: return blank (not 0) for Min/Max/Product/StdDev/Var with zero numerics;
    thread a "no value" sentinel through `DisplayAggregate`/`SetPivotValueCell`.
  - G8: switch item-identity comparisons to ordinal.
  - Tests: non-linear calc field (`Revenue/Units`) vs hand-computed Excel result;
    min over text-only group → blank; ordinal item matching.

- **Phase 2 — Multi-level subtotals** (`Writers.cs`, `MatrixWriter.cs`)
  - G3: emit a subtotal row for every outer nesting level that changes, using the
    correct subtotaled-field caption per level; honor top/bottom placement,
    blank-line-after-items, compact captions.
  - Tests: 3-field row pivot asserts subtotals at level 1 AND level 2 with correct
    captions and sums; matrix variant; tabular and compact.

- **Phase 3 — Parent-total Show Values As** (`Aggregates.cs`, writer context plumbing) — DONE
  - G2: writers now pass the immediate-parent group rows into `PivotDisplayContext`
    (`ParentRowRows`/`ParentColumnRows`). `% of Parent Row Total` divides by the
    parent prefix total taken in the SAME column; `% of Parent Column Total` divides
    by the parent column prefix total taken in the SAME row; outermost items fall
    back to the grand total along that axis.
  - RESIDUAL: base-field-driven `% of Parent Total` is not yet modeled (it needs a
    selected base field whose parent total is the denominator); it currently falls
    back to `% of Grand Total`. Deferred until the base-field model/UI path is wired.
  - Tests: unambiguous 2-level row-only pivot (`% of Parent Row Total` =
    child/parent-subtotal ratio, subtotal = subtotal/grand, grand = 100%); the
    single-level matrix test corrected to same-column/same-row parent semantics.

- **Phase 4 — Nested column subtotals** (`MatrixWriter.cs`, column-key plumbing) — DONE
  - G4: a `ColumnSlot` (Leaf | Subtotal) list is built from the leaf column keys and
    every column iteration (headers, data rows, row-subtotal rows, column grand
    total) is routed through it, emitting a subtotal column per outer column group
    when `ShowSubtotals && columnFields.Count > 1`. Single-column-field and
    no-subtotal matrices are byte-identical to before.

- **Phase 6 — Compact layout true rendering (row-only)** (`Writers.cs`, `Styles.cs`) — DONE
  - G5: `WriteRowPivot`'s compact branch now renders one indented row per row-field
    level (header rows for non-leaf levels carry no value under bottom/off subtotals;
    leaf rows carry the values; subtotal "X Total" rows sit at their level's indent),
    matching Excel. Per-row indent levels are tracked on `PivotRenderFootprint` and
    applied in `ApplyCompactRowLabelIndent`. All compact row-only tests rewritten to
    the Excel-accurate shape.

- **Phase 5 — Calculated items beyond single row field** (`Writers.cs`, `MatrixWriter.cs`) — RESIDUAL
  - G6: calculated items still materialize only in the single-row-field row-only
    layout. Matrix/nested calculated items are deferred — a niche feature with
    confusing Excel double-counting semantics; low value relative to risk.

- **Matrix compact rendering** — RESIDUAL: `WriteMatrixPivot`'s compact branch still
  space-joins nested row labels. Phase 6 deliberately scoped to the common row-only
  case; applying the same per-level rendering to the matrix path is a follow-up.

- **Base-field `% of Parent Total`** — RESIDUAL (see Phase 3): needs the base-field
  model/UI path; currently falls back to `% of Grand Total`.

- **Visual/round-trip verification** (after Phases 1–3) — DONE:
  `PivotParityRoundTripTests` authors a 3-level row pivot with multi-level
  subtotals, grand totals, and a `% of Parent Row Total` data field, refreshes it
  (grand total = 220, an Excel-correct anchor), saves through `XlsxFileAdapter`,
  and reloads: the pivot cache + definition and *every* materialized cell survive
  the round-trip unchanged. Functional correctness of each phase is locked by unit
  tests with hand-computed Excel ground-truth values; schema validity is unaffected
  because the fixes write only plain cell values (numbers/text/blanks) and existing
  Core.IO pivot-schema tests already cover the pivot parts.
  - LIMITATION: live-Excel verification of pivots is out of scope by the user's
    explicit constraint ("the local Excel instance does not have pivot tables, so
    cannot use it"). Correctness is therefore anchored to Excel's documented
    semantics via ground-truth unit tests, not a live Excel comparison. (A COM open
    attempt failed with "Unable to get the Open property", the known PowerShell
    late-binding failure on this machine's non-English Office UI; the general
    workaround is a C# console with `Thread.CurrentCulture = en-US`, but it is moot
    here since the local Excel cannot host pivots regardless.)

## Sequencing & Risk

- Phases 1–4 are the highest value (silent-wrong-number and missing-structure
  bugs). Phase 5 is additive. Phase 6 is visual-correctness but the most
  disruptive (rewrites compact materialization and rewrites several existing
  tests), so it goes last and may be split out if it grows.
- Each phase gated by: `dotnet build FreeX.slnx -c Release` +
  `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` green, plus the
  phase's new tests.
- Backward-compat: existing pivot round-trip/XLSX tests must stay green except the
  compact-layout tests intentionally updated in Phase 6.

## Out of Scope

Power Pivot / data model / OLAP cubes, external/data-model cache execution,
Recommended PivotTables heuristics, and full Excel style-gallery theme semantics
(all already documented as excluded/partial in the parity surface).
