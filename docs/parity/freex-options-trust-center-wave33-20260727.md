# FreeX Options Trust Center parity, Wave33

Date: 2026-07-27

Surface: `dialog.Options.TrustCenter`

## Scope and diagnosis

WPF remains the authority in `src/FreeX.App.Host/OptionsDialog.xaml`. The
Avalonia counterpart is built in `src/FreeX.App.Avalonia/MainWindow.Options.cs`.

The matched baseline showed two semantic gaps and one structural gap:

- Avalonia rendered the crash-report consent checkbox and Trust Center Settings
  button disabled; WPF renders both controls enabled.
- Avalonia used a 150 px Settings button while WPF uses 170 px.
- The dynamically-built Avalonia panel had no finite content width, so the long
  diagnostics paragraph was clipped instead of wrapping in the WPF content frame.

The fix keeps WPF UI code unchanged. The only WPF-side change is a focused
`ParityCapture` selector for this already-existing Options tab, added solely to
produce fresh authority evidence. The shared planner change is a genuine
cross-shell persistence contract: it carries the same crash-consent value and
preserves prompt history when the user opts out again.

## Implemented behavior

- Trust Center consent is seeded from and persisted to `CrashAnalyticsEnabled`.
- Enabling consent marks the prompt as seen; disabling it does not clear prompt
  history, matching the WPF assignment.
- Trust Center Settings opens the existing Avalonia modal message surface using
  the same localized deferred-command resource keys as WPF.
- The panel is constrained to the shared 468 px Options content width, and the
  button is 170 px wide.
- Existing category keyboard navigation, default OK, cancel, awaited dialog
  lifecycle, and the Options hang guard remain intact.

## Evidence

Fresh matched captures, both `744x521` px at the canonical client frame:

- WPF authority: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Options.TrustCenter.png`
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Options.TrustCenter.png`
- Fresh WPF run: `artifacts/options-trust-center-wave33/wpf/manifest.json`
- Fresh Avalonia run: `artifacts/options-trust-center-wave33/avalonia/manifest.json`

The same comparer and threshold were used for both pairs:

| Metric | Before | After |
| --- | ---: | ---: |
| Changed-pixel diff | 3.8873837146% | 3.6451661220% |
| Reduction | -- | 6.23% |
| Logical frame | 744x521 | 744x521 |

Reports:

- Baseline comparison: `artifacts/options-trust-center-wave33/before-compare/parity-report.json`
- Fresh comparison: `artifacts/options-trust-center-wave33/compare/parity-report.json`

This is a measurable improvement, not a 100% pixel-parity claim. Remaining
variance is primarily Avalonia/Linux versus WPF text rasterization and native
control chrome; the long diagnostics copy also wraps at slightly different
word boundaries.

## Verification

- `OptionsDialogPlannerTests`: 36 passed, 0 failed.
- Focused Avalonia Options parity source lane: 4 passed, 0 failed.
- WPF Release build: 0 warnings, 0 errors.
- Avalonia self-contained `linux-x64` publish: succeeded.
- Fresh WPF targeted capture `dialog.Options.TrustCenter`: succeeded.
- Fresh Avalonia production capture under the prebuilt Ubuntu 24.04/Xvfb
  harness: succeeded; manifest captured the target surface.
- Parity comparer: target present on both sides, 3.6451661220% diff, no hard
  regression at the evidence threshold.

The initial fresh Ubuntu attempt was blocked in `apt-get update` before app
startup; only the task-owned container was stopped. The same capture then
completed successfully with the repository's prebuilt
`freex-linux-interactive:ubuntu24.04` image.
