# Pivot Value Format Canonical Presets Plan

## Tasks

- [x] Identify duplicate built-in ID `14` labels in the PivotTable Value Field Settings preset catalog.
- [x] Add a focused test that requires `Short Date` to be the canonical display label for built-in ID `14`.
- [x] Reorder the preset catalog so `Short Date` is canonical while `Date` remains accepted as a compatibility alias.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- Preset order is meaningful: reverse lookup uses the first preset with a matching `numFmtId`.
- `Short Date` is the canonical Excel-style label for built-in `numFmtId` 14.
- The legacy `Date` alias remains in the catalog so existing user input and older tests continue to resolve to ID 14.
