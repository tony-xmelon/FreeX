# FreeX Options Formulas Wave 116

Date: 2026-08-03

## Scope

The current-source recapture established that iterative calculation is production behavior in both WPF and Avalonia. The prior committed WPF PNG was stale: it predated the WPF `OptIterativeEnabled`, maximum-iterations, and maximum-change controls. Both hosts were recaptured at the established 744x777 client frame before judging the layout.

Avalonia's Formulas page also had an extra `Enable background error checking` master row that is absent from the WPF authority. The row consumed vertical space and shifted the rule list, while the existing per-rule switches already route through the shared formula-error command. The Avalonia row was removed; persisted `ErrorCheckingEnabled` is carried through unchanged, individual rule behavior remains, and iterative calculation behavior is unchanged.

## Evidence

- WPF: fresh `FreeX.App.Host --parity-capture` capture from current source.
- Avalonia: fresh self-contained `linux-x64` capture from current source under Ubuntu 24.04 Docker/Xvfb with `--parity-capture --parity-capture-surface dialog.Options.Formulas`.
- Both promoted PNGs are nonblank and 744x777 pixels; the iterative band is present in both.
- The generated summary and both manifests now record current-source freshness and the replacement of the stale WPF evidence.

| Metric | Stale committed pair | Fresh pair after Wave116 | Change |
| --- | ---: | ---: | ---: |
| `triageScore` | 0.092999 | 0.044740 | -51.9% |
| `sampleMeanDelta` | 0.032790 | 0.031408 | -4.2% |
| `lumaDelta` | 0.005718 | 0.008047 | +40.7% |
| `nonBackgroundDelta` | 0.054211 | 0.005006 | -90.8% |
| Logical dimensions | 744x777 / 744x777 | 744x777 / 744x777 | matched |

The fresh pair's general comparer reports a 3.37% pixel-diff for the surface. The generated triage score is the repository's review-prioritization metric and is not a pass/fail visual acceptance threshold.

## Verification and limitations

- Focused services tests passed, including `QCalcSettingsAvaloniaOptionsTests` and `OptionsDialogPlannerTests`.
- Fresh WPF capture/build completed with 0 warnings and 0 errors.
- Fresh Avalonia `linux-x64` publish and Ubuntu 24.04 Docker/Xvfb capture completed successfully.
- The remaining delta is primarily WPF/Avalonia control and text rasterization, with the shared 744x777 frame still showing the lower rule list's natural scrollbar/clipping behavior. No Linux claim is made for the WPF image; the Avalonia image is explicitly Linux Docker/Xvfb evidence.
