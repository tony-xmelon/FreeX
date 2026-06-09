# Home Formatting, Number, And Cells Reconciliation - 2026-06-08

## Purpose

This note reconciles a stale parity reference that expected a dedicated Home formatting/number/cells subagent report. The current aggregate documentation records that coverage across the UI catalog and focused residual notes instead of this historical filename.

## Current Coverage

- `docs/testing/ui-test-catalog.md` tracks the Home font/alignment/number surface under `UI-CAT-HOME-002`, with command-level backlog rows for font, fill, borders, alignment, merge, number format dropdown, custom formats, and decimal/accounting/percent commands.
- The catalog also tracks Home cells/editing work under `UI-CAT-HOME-004A-M`, including insert/delete, row/column sizing, hide/unhide, AutoSum, fill, Flash Fill, clear, sort/filter, Find/Replace, Go To, and Go To Special.
- `docs/parity/subagent-dialog-accessibility-residual-2026-06-08.md` records the latest Format Cells dialog accessibility/focus checks.
- `docs/parity/subagent-command-source-remaining-audit-2026-06-08.md` records that Home command-source coverage is broadly guarded by focused Home command-source tests; remaining Home work is mostly live UI, rendering, persistence, and cross-target evidence.

## Reconciliation

No product or test-source patch is attached to this note. It exists so backlog entries that still reference `subagent-home-formatting-number-cells-2026-06-08.md` resolve to the current status rather than a missing file.

## Remaining Gaps

- Live visual evidence for Home formatting still needs real worksheet targets: blank/value/formula cells, ranges, tables, protected sheets, custom number formats, theme colors, and rendered grid/save-reload proof.
- `UI-CMD-HOME-NUM-002` remains the clearest catalog gap for custom/locale number formats.
- Whole-row/column, filtered-row, hidden-row, protected-sheet, and object-text cross-target behavior should continue to be reconciled through the cross-target command matrix rather than this summary note.
