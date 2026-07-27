# FreeX Error Checking Parity Wave 29

Date: 2026-07-27

## Diagnosis

The Avalonia Error Checking route constructed a standalone `Window` without
opting into the shared compact dialog chrome. Its controls were styled one by
one, which left the window-level font, background, foreground, and descendant
normalization outside the shared WPF-parity path. The WPF and Avalonia parity
fixtures were also duplicated in separate hosts, making semantic drift
possible. Finally, WPF's targeted parity-capture selector did not support
`dialog.ErrorChecking`, so a focused WPF refresh could silently omit the pair.

## Bounded fix

- Applied `AvaloniaCompactDialogChrome.ApplyWindow` with the existing
  Error Checking style before the dialog is shown.
- Moved the deterministic two-issue capture fixture into
  `ErrorCheckingDialogPlanner` and made both hosts consume it.
- Added the missing targeted WPF `dialog.ErrorChecking` capture route.
- Added focused planner, host-source, and Avalonia-source guards.

## Fresh paired evidence

Both current-source captures were generated from this worktree through the
WPF executable and Linux Docker/Xvfb harness at a comparable `720x420`
logical/pixel frame. The temporary capture and comparison outputs are removed
after verification; the metrics below are retained as the durable evidence.

| Measure | Before | After |
| --- | ---: | ---: |
| Triage score | 0.103141 | 0.058275 |
| Sample mean delta | 0.030367 | 0.036947 |
| Luma delta | 0.006296 | 0.000262 |
| Non-background delta | 0.066375 | 0.020787 |
| Logical dimensions | 720x420 pair | 720x420 pair |
| Direct paired pixel diff | historical promoted pair | 4.3299% fresh pair |

The triage score fell 43.5%, and the non-background delta fell 68.7%. The
sample mean delta is higher in the fresh pair because the new comparison uses
fresh WPF output rather than the historical promoted WPF screenshot; native
font/control rasterization remains a visible source of raw pixel variance.

## Verification

- `FreeX.App.Services.Tests` Error Checking planner filter: 3 passed.
- `FreeX.App.Host.Tests` Error Checking dialog source filter: 18 passed.
- `FreeX.App.Avalonia.Tests` targeted Error Checking/shared-chrome source
  filter: 1 passed.
- WPF Release host build: passed.
- Avalonia `linux-x64` Release publish: passed.
- Fresh WPF and Linux Docker/Xvfb captures: both captured and nonblank at
  `720x420`.

The broader Avalonia compact-chrome source suite still has three unrelated
pre-existing failures in Pivot/DataOps/tab-count assertions; this slice did
not modify those areas.

## Residuals

The dialog still has native WPF versus Avalonia differences in text
anti-aliasing, button-template rasterization, selected-row rendering, and
scrollbar glyphs. This slice does not claim pixel-identical native controls or
complete formula-error taxonomy parity beyond the existing shared service.
