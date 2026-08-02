# Avalonia Find/Replace Parity Wave114 - 2026-08-02

## Scope

`dialog.FindReplace` now derives its shared 720x430 layout authority from
`FindReplaceDialogPlanner` in both desktop hosts. The WPF XAML consumes typed adapters for
WPF-only `GridLength` and `DataGridLength` properties; Avalonia consumes the same numeric
planner values directly. Find and Replace behavior, format-picker cancellation behavior,
result navigation, options controls, and action routing remain unchanged.

The Avalonia construction also corrects measured evidence-size geometry: its options header
uses the Avalonia-only 112px minimum and restores left content alignment after common button chrome,
the options/results transition uses the measured Avalonia calibration, and the root bottom
inset moves the results and action bands down toward the WPF positions. No fake renderer
controls were added.

## Evidence

Fresh WPF capture completed at 720x430 for:

- `dialog.FindReplace`
- `dialog.FindReplace.Find`
- `dialog.FindReplace.Replace`

The fresh WPF Find state shows the fully visible `Options >>` header, results top at the
WPF reference position, and actions docked at the lower band. The Replace state preserves
the second row and all five actions with the same shared widths. The WPF `OptionsExpander`
remains auto-sized as the visual authority. The prior real-Linux
Avalonia capture was inspected for both states; it showed the pre-fix clipped options label
and results/actions bands 3-6px high.

The current Avalonia after capture was attempted with these exact commands from the worktree:

```text
$captureRoot=(Resolve-Path 'artifacts\wave114-findreplace-after\avalonia').Path; docker run --rm --name freex-wave114-findreplace-after -v "${captureRoot}:/work" ubuntu:24.04 bash -c "apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq xvfb libfontconfig1 libfreetype6 libx11-6 libxext6 libxrender1 libxcb1 libice6 libsm6 >/dev/null && cp -a /work/_publish-linux-x64/. /work/runtime && chmod +x /work/runtime/FreeX && mkdir -p /work/out && xvfb-run -a -s '-screen 0 1280x900x24' /work/runtime/FreeX --parity-capture /work/out --parity-capture-surface dialog.FindReplace"
$captureRoot=(Resolve-Path 'artifacts\wave114-findreplace-after\avalonia').Path; docker run --rm --name freex-wave114-findreplace-after -v "${captureRoot}:/work" --entrypoint /bin/bash freex-linux-interactive:ubuntu24.04 -c "rm -rf /work/runtime /work/out && cp -a /work/_publish-linux-x64/. /work/runtime && chmod +x /work/runtime/FreeX && mkdir -p /work/out && xvfb-run -a /work/runtime/FreeX --parity-capture /work/out --parity-capture-surface dialog.FindReplace"
```

The first container stayed in quiet `apt-get` with no output files for over three minutes.
The prebuilt-Xvfb retry stayed alive for 60 seconds with an empty `out` directory. Both
owned containers were stopped by their exact names. Therefore the canonical Avalonia PNGs
remain the last successful real-Linux capture, and no Avalonia after/after metric is claimed.

For a quantitative reference, fresh WPF after PNGs versus that retained real-Linux Avalonia
reference measured:

| Surface | Prior WPF vs Avalonia reference | Corrected WPF baseline vs retained Avalonia |
| --- | ---: | ---: |
| `dialog.FindReplace` / Find | 2.4765789760% | 2.4765789760% |
| `dialog.FindReplace.Find` | 2.4765789760% | 2.4765789760% |
| `dialog.FindReplace.Replace` | 2.7847540850% | 2.7847540850% |

These values are reference comparisons, not a substitute for the unavailable current
Avalonia after capture. The parity tool reports all three surfaces present on both sides,
with no hard regressions; its focused run still reports the repository-wide name-box contract
failure because this capture intentionally contains only Find/Replace surfaces.

## Tests and generated evidence

- `FreeX.App.Services.Tests`: 34 passed, including shared planner metrics and Avalonia
  surface contracts.
- `FreeX.App.Avalonia.Tests`: 8 passed for `DialogVisualParitySourceTests`.
- `FreeX.App.Host.Tests`: 22 passed for `FindReplaceDialogXamlTests`.
- WPF and Avalonia Release builds passed with zero warnings/errors.
- `tools/Generate-DialogVisualEvidenceSummary.ps1` regenerated the canonical summary:
  94 paired captured surfaces, no blank PNGs, no expected-size mismatches, and no paired
  dimension mismatches.

## Residuals

The remaining material uncertainty is the missing current Avalonia Linux screenshot and
therefore the missing true after/after pixel delta. A rerun in an environment where the
capture container can start the app is required to close that evidence gap. Renderer-native
font and control-template differences also remain outside the shared planner's authority.
