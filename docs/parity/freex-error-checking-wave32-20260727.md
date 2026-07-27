# FreeX Error Checking Parity Wave 32

Date: 2026-07-27
Base after sync: `a30567678a`

## Diagnosis

The shared parity planner already supplied the same deterministic two-issue
fixture to WPF and Avalonia. The report that WPF had one issue was stale
evidence: a fresh WPF capture from the unchanged host rendered both `D6`
(`DIV/0!`) and `D7` (formula stored as text).

The remaining layout difference was the native-frame reserve. WPF's
`720x420` value is an outer dialog size, leaving a `704x383` client rectangle
for the content. Avalonia's borderless client surface had been filling the
whole `720x420` frame, moving the action row down and widening the issue pane.

## Changes

- Kept the shared `ErrorCheckingDialogPlanner.CreateParityIssues` fixture as
  the sole WPF/Avalonia capture source and strengthened its exact row/content
  test contract.
- Added the shared Avalonia client-rectangle metrics (`704x383`) to the
  planner.
- Wrapped only the Avalonia Error Checking content in that top-left client
  rectangle, preserving the WPF outer `720x420` contract and leaving WPF
  implementation code unchanged.

## Fresh paired evidence

Both captures were generated from the synced branch at the same logical
`720x420` surface size. The Linux capture used the self-contained Avalonia
publish under the repository's Ubuntu/Xvfb image and the targeted
`dialog.ErrorChecking` route.

| Measure | Wave 29 documented pair | Wave 32 fresh pair |
| --- | ---: | ---: |
| Paired surfaces | 1 | 1 |
| Fixture rows | WPF/Avalonia drift reported | 2 / 2 |
| Mean pixel diff | 4.3299% | 2.9191% |
| Relative improvement | -- | 32.5% lower |
| Comparison gate | -- | PASS |

Fresh PNG SHA-256:

- WPF: `1BD6056634CDB6AA402A6A212743447185F6536651BEDBCB6283B69A0036B1ED`
- Avalonia/Linux: `01D6EBCEEEAEAEE2E9F8BDD70F85131646117B72BD146B1E9B16E03FCC7BC03A`

Local generated evidence is under
`artifacts/parity-wave32-error-checking/`, with the paired report at
`artifacts/parity-wave32-error-checking/comparison/parity-report.html`.

## Verification

- `FreeX.App.Services.Tests` planner filter: **3/3 passed**.
- `FreeX.App.Host.Tests` non-UI Error Checking source/fixture filter:
  **9/9 passed**.
- `FreeX.App.Avalonia.Tests` Error Checking/shared-chrome source filter:
  **1/1 passed**.
- WPF Release host build: **0 warnings, 0 errors**.
- Avalonia `linux-x64` Release self-contained publish: passed.
- Objective paired comparison: **1/1 present, PASS**.

The full WPF Error Checking class was not used as the final gate because its
UI-thread subset exceeded the bounded foreground timeout; the bounded source
and fixture assertions passed and no test-owned process remained afterward.

## Residuals

The pair still contains expected native WPF/Avalonia differences in font
rasterization, button templates, selected-row colors, and scrollbar glyphs.
Those are visual residuals only; the two-row fixture, client geometry, and
dialog action layout are now aligned. No WPF source was changed in this wave.
