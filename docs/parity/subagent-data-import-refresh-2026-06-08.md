# Data Import And Refresh Reconciliation - 2026-06-08

## Purpose

This note preserves the historical data import/refresh report reference used by the visual parity ledger. Current aggregate coverage is split across Data tab residual notes, localization checks, and catalog rows.

## Current Coverage

- Data tab command-source coverage is documented in `docs/parity/subagent-data-sort-outline-scenarios-2026-06-07.md`, `docs/parity/subagent-data-import-localization-residual-2026-06-08.md`, and `docs/parity/subagent-command-source-remaining-audit-2026-06-08.md`.
- The UI catalog tracks Get & Transform Data, Queries & Connections, Sort & Filter, Data Tools, Forecast, and Outline surfaces.
- Source-visible tests cover dialog routing/localization for Data Validation, Text to Columns, Remove Duplicates, Subtotal, Scenario Manager, Forecast, and outline-related commands.

## Remaining Gaps

- Full Excel Get & Transform/Power Query semantics remain outside the current implementation depth.
- Refresh workflows still need live workbook-backed evidence for imported ranges, connection metadata, and disabled/unsupported command handling.
