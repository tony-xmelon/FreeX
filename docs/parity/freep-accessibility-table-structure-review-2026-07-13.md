# FreeP Accessibility Table Structure Review - 2026-07-13

## Scope

This slice makes existing Accessibility Checker diagnostics for blank table header cells, blank table body cells, and merged or split cells actionable without auto-repairing table structure.

## Behavior

- Blank header cells, blank body cells, and merged/split table-cell diagnostics now route through `freep.review.accessibility.review-table-structure`.
- Missing table header rows continue to route through `freep.review.accessibility.set-table-header-row`.
- The shared review plan selects the target table and reports slide, shape, table name, row/column counts, blank header/body cell references, merged/split cell references and spans, and safe next-action guidance.
- WPF and Avalonia hosts keep routing thin: activating the row action navigates/selects the table, opens the shared review plan state, and refreshes the Accessibility Checker pane. It does not simplify, split, merge, delete, or rewrite table cells.

## Deferred

- No visual side pane for the detailed table-structure plan was added in this slice; tests expose the shared plan state for the next host UI pass.
- No automatic repair was added for blank or merged/split cells because PowerPoint-style review needs user judgment for table semantics.
