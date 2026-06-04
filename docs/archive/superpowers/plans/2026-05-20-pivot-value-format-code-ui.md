# PivotTable Value Format Code UI Implementation Plan

## Tasks

- [x] Identify the remaining PivotTable number-format UI gap: the model supports custom value-field format codes, but Value Field Settings only exposed numeric format IDs.
- [x] Add parser helpers for optional custom format codes and default custom ID assignment.
- [x] Add focused parser tests for blank/custom code and custom-ID fallback behavior.
- [x] Add a Custom format code field to `PivotValueFieldSettingsDialog`.
- [x] Add common built-in number-format presets to the Number Format tab while retaining raw ID entry.
- [x] Expand the preset catalog to cover common Excel built-in categories: currency/accounting, date/time, percentage, fraction, scientific, and text.
- [x] Load and save `PivotDataFieldModel.NumberFormatCode` through the dialog.
- [x] Update dialog source/XAML hygiene coverage.
- [x] Document the architecture and command-parity decision.
- [ ] Run focused verification, commit, merge to `main`, push, then continue with the next sensible fidelity slice.

## Decisions

- A custom value-field format code entered without a custom `numFmtId` is assigned ID `164`. Existing save logic can remap that ID if it collides with generated cell-style custom formats.
- Built-in ID-only behavior remains unchanged when no custom format code is entered.
- The dialog now offers a broader set of common built-in presets for discoverability, but still does not attempt full Excel format-code validation or a complete picker gallery.
