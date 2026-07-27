# FreeW Page Setup Avalonia Parity, Wave 32

## Scope

This slice aligns the Avalonia Page Setup dialog with the unchanged WPF authority at the same
560 x 600 capture frame. The worker branch was synchronized with `origin/main` at `a30567678a`
before the final capture and verification pass.

## Changes

- Corrected the production dialog width from 440 to the WPF-authority 420.
- Applied the shared classic tab chrome, including the authority-specific horizontal and vertical
  content-pane compensation required by Avalonia's Fluent TabControl template.
- Replaced the content-sized StackPanel shell with a stretching Grid so the tab pane fills the
  authority height and the OK/Cancel row docks to the same footer position as WPF.
- Added Page Setup-specific 90 px label / star-sized editor rows. Text boxes and combo boxes now
  stretch to the pane edge instead of retaining narrow 120/170 px fields.
- Corrected Avalonia harness action-order semantics to enumerate rendered visual descendants only;
  logical descendants from inactive tabs no longer appear in the selected dialog's action list.

## Fresh Evidence

Fresh WPF and Avalonia captures were produced for `initial`, `populated`, and `validation-error`
at 560 x 600. The scoped report is:

`artifacts/parity-wave32-page-setup-fresh/final-compare/freew_dialog_visual_comparison.html`

The machine-readable report is:

`artifacts/parity-wave32-page-setup-fresh/final-compare/freew_dialog_visual_comparison.json`

| State | Changed pixels | Mean channel delta | P95 delta | pHash distance | Semantics |
| --- | ---: | ---: | ---: | ---: | --- |
| Initial | 13.41% | 7.89 | 66.67 | 1 | Match |
| Populated | 13.41% | 7.89 | 66.67 | 1 | Match |
| Validation error | 13.51% | 8.02 | 66.67 | 1 | Match |

Final painted bounds are WPF `x14,y14,517x537` and Avalonia `x14,y14,516x537` for the initial
state; the other lifecycle states use the same authority frame and pane geometry. The remaining
delta is framework-native control rasterization and theme rendering, not the former collapsed pane,
narrow editor columns, misplaced footer, or hidden-tab semantic contamination.

## Verification

- `DialogVisualHarnessSemanticTextTests`: **5/5**
- `PageSetupDialogTests` + `CommonDialogChromeParityTests`: **37/37**
- WPF authority captures: **3/3**
- Avalonia captures: **3/3**
- `git diff --check`: passed before final verification

All capture and test commands used foreground .NET execution with build servers and shared
compilation disabled. No build-server shutdown or process-wide process termination was used.
