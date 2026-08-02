# Avalonia Parity Wave111: FreeX Options View

Date: 2026-08-02

## Delivered

- Aligned Avalonia `dialog.Options.View` with the WPF authority at the shared `744x521` client frame: explicit body/footer rows, WPF-matched View header rhythm, and fractional category-row rasterization with the WPF 1 px horizontal inset.
- Added `OptionsDialogParityFixture` in shared services. Normal launches remain store-backed; both parity-capture routes use the same explicit fixture so screenshots cannot inherit different user-local options stores.
- The fixture keeps the production default semantic state: `ShowFormulaBar=true`, `FormulaBarExpanded=false`.

## Evidence

- Fresh WPF and Avalonia captures were produced from the parity harness. Both are `744x521` at `96 DPI`, nonblank, and are promoted under `docs/parity/dialog-visual-assets`.
- Existing canonical pair: triage score `0.098637`; normalized pixel comparison `2.04%`.
- Fresh pair: triage score `0.014`; normalized pixel comparison `1.153%`.

## Remaining

- The remaining difference is primarily platform text and checkbox rasterization; the former Options.View sidebar/footer/state drift is removed.
- The full parity runner still reports the repository's unrelated native name-box contract as unavailable in Docker; the targeted Avalonia capture itself completed successfully.
