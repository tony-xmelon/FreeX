# Avalonia/WPF Parity Wave 130: FreeX About Dialog

Date: 2026-08-03

## Scope

This slice brings FreeX Avalonia `dialog.About` onto the shared Avalonia
About host and aligns its current-source content and geometry with the WPF
authority. `MainWindow` now delegates to `src/FreeX.App.Avalonia/AboutDialog.cs`,
which uses the shared `AvaloniaAboutDialog` and the centralized
`AppHelpInfo.AvaloniaPlatformSummary`.

## Current-source evidence

The existing WPF About capture was not a valid client-sized authority image:
the capture harness rendered a 560x420 outer-size window as a 560x420 client
surface, leaving an artificial blank lower band. `ParityCapture` now applies
the shared `AboutDialogMetrics.Width` and `Height` as fixed WPF client capture
geometry. A fresh WPF capture was rebuilt from current source at 560x420 and
passes nonblank and expected-size validation.

The Avalonia evidence was captured from the current source in Linux
Docker/Xvfb at the same 560x420 size and also passes `app_exit=0`,
`capture_validated=true`, nonblank, and dimension checks.

## Measured decisions

The Avalonia wrapper keeps a named platform override:
`AboutDialogMetrics.AvaloniaTextFontSize = 12.3`. With the same fresh WPF
client baseline and no neutral-button override, the deterministic triage
score was:

| Configuration | Triage score | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Avalonia font size 12 | 0.107320 | 0.070797 | 0.014215 | 0.022028 |
| Avalonia named font size 12.3 | **0.107196** | 0.071472 | 0.013961 | 0.021484 |
| Avalonia named 12.3 plus left padding +2 | 0.108003 | 0.072279 | 0.013961 | 0.021484 |

Lower is better. The 12.3 value is therefore retained as a measured,
test-backed Avalonia override rather than a magic number. The padding +2
experiment was rejected, as was the earlier root right-margin -1 adjustment.

`ApplyNeutralDefaultButtonChrome` was measured in isolation with the final
12.3 typography and geometry. Removing it scored `0.107196`; restoring it
scored `0.107744`. The shared About host therefore leaves the neutral override
removed, preserving the WPF-matching resting button chrome without changing
other shared dialog consumers.

## Verification

- `FreeX.App.Avalonia.Tests` About dialog parity test: 1 passed.
- `FreeX.App.Services.Tests` Avalonia shell source lane: 76 passed.
- `FreeX.App.Host.Tests` About dialog lane: 2 passed.
- `FreeW.App.Avalonia.Tests` WPF authority surface lane: 13 passed.
- Fresh WPF and Avalonia capture builds completed with zero errors.

## Residuals

The paired images still contain expected WPF-versus-Avalonia text rasterization
and native scrollbar differences. The old promoted WPF About PNG remains
untouched because it was stale; this slice records fresh current-source
evidence without making a stale-canonical-image visual claim.
