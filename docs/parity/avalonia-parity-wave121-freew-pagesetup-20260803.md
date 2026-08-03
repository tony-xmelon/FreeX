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

The harness route seed is explicit and shared: both route factories use
`PageSetupDialogPlanner.VisualHarnessSectionStart` (`NextPage`, rendered as
`New page`). This matches both production entry points and avoids making the
WPF reflection helper's enum-zero accident part of the authority state. The
Avalonia production constructor accepts the section-start value while retaining
its production default of `NextPage`.

Validation, initial focus, tab selection, paper synchronization, keyboard
handling, and launcher behavior remain on the existing shared planner and host
paths.

## Fresh route-scoped evidence

Fresh WPF and Avalonia harness captures cover all six Page Setup scenarios:
`initial`, `populated`, `validation-error`, `tab-margins`, `tab-paper`, and
`tab-layout`. The route-scoped report and paired PNGs are under:

`artifacts/parity-wave121-freew-page-setup-20260803-corrected/`

The focused comparison improved as follows:

| State | Previous changed pixels | Corrected changed pixels | Corrected mean channel delta |
| --- | ---: | ---: | ---: |
| Initial / populated / Margins | 15.25% | 10.10% | 7.11 |
| Validation error | 15.35% | 10.19% | 7.23 |
| Paper | 4.69% | 4.63% | 3.34 |
| Layout | 6.72% | 7.48% | 5.23 |

All six WPF captures and all six Avalonia captures passed the harness content
gate. The corrected `tab-layout` pair now has the same authoritative
`Section start: New page` value in both images and manifests. The remaining
Layout delta is primarily native text antialiasing, input border rasterization,
tab chrome, focus border, and action-button template pixels, rather than a
state mismatch.

## Verification

- `PageSetupDialogPlannerTests`: 10/10 passed.
- Avalonia `PageSetupDialog` focused tests: 35/35 passed.
- WPF `PageSetupDialog` focused tests: 4/4 passed.
- WPF harness build: 0 warnings, 0 errors.
- Avalonia harness build: 0 warnings, 0 errors.
- Fresh paired captures: 6/6 WPF and 6/6 Avalonia.
- Harness route seed regression: both factories explicitly map to
  `VisualHarnessSectionStart = NextPage` (`New page`).
- `git diff --check`: passed after evidence generation.

## Production Linux Docker/Xvfb smoke

The current production FreeW Avalonia host was published and exercised in the
existing Ubuntu 24.04 Docker/Xvfb desktop at 1280x820 and 96 DPI. The Layout
ribbon opened Page Setup successfully, and fresh Margins, Paper, and Layout
screenshots were captured before the owned container was stopped. The
production Layout state correctly renders `Section start: New page`.

Fresh Wave121 evidence is retained under:

`artifacts/linux-interactive-wave121/freew/`

The latest session is `sessions/20260803T070354814Z/`; its metadata and full
Xvfb logs remain under that session directory. The stable three-state copies
are under `page-setup/` as `page-setup-margins.png`, `page-setup-paper.png`,
and `page-setup-layout.png`.

The cross-app/global dashboards were intentionally not regenerated in this
worker slice.
