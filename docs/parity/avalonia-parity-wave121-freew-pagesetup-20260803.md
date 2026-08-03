# FreeW Page Setup visual parity, Wave 121

Date: 2026-08-03

## Scope

Aligned the Page Setup initial, populated, Margins-tab, and validation states
against the WPF authority. The shared `PageSetupDialogPresentationMetrics`
contract now owns the 24-DIP field height and the Avalonia selected-content
template compensation used by the Avalonia host. WPF consumes the same field
height directly, while Avalonia applies the template-specific three-DIP inset
on both sides of each tab content panel. The selected pane no longer uses the
negative top offset that pulled Avalonia content above the WPF baseline.

Validation, initial focus, tab selection, paper synchronization, keyboard
handling, and launcher behavior remain on the existing shared planner and host
paths.

## Fresh route-scoped evidence

Fresh WPF and Avalonia harness captures cover all six Page Setup scenarios:
`initial`, `populated`, `validation-error`, `tab-margins`, `tab-paper`, and
`tab-layout`. The route-scoped report and paired PNGs are under:

`artifacts/parity-wave121-freew-page-setup-20260803/`

The focused comparison improved as follows:

| State | Previous changed pixels | Wave 121 changed pixels | Wave 121 mean channel delta |
| --- | ---: | ---: | ---: |
| Initial / populated / Margins | 15.25% | 10.10% | 7.11 |
| Validation error | 15.35% | 10.19% | 7.23 |
| Paper | 4.69% | 4.63% | 3.34 |
| Layout | 6.72% | 7.49% | 5.26 |

All six WPF captures and all six Avalonia captures passed the harness content
gate. The remaining delta is primarily native text antialiasing, input border
rasterization, tab chrome, focus border, and action-button template pixels.

## Verification

- `PageSetupDialogPlannerTests`: 9/9 passed.
- Avalonia `PageSetupDialog` focused tests: 34/34 passed.
- WPF `PageSetupDialog` focused tests: 4/4 passed.
- WPF harness build: 0 warnings, 0 errors.
- Avalonia harness build: 0 warnings, 0 errors.
- Fresh paired captures: 6/6 WPF and 6/6 Avalonia.
- `git diff --check`: passed before evidence generation.

The cross-app/global dashboards were intentionally not regenerated in this
worker slice.
