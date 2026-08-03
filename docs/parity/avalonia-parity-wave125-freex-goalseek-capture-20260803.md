# Avalonia Parity Wave125: FreeX Goal Seek Status Capture

Date: 2026-08-03

## Diagnosis and fix

The current Avalonia source route was valid: `MainWindow.ParityCapture.cs`
selects `dialog.GoalSeekStatus` and opens the fixture-backed
`ShowGoalSeekStatusParityDialogAsync` route. A focused headless behavior test
now proves that this route writes one nonblank `380x190` PNG.

Wave124's Linux attempts failed in the container wrapper. The reusable
`freex-linux-interactive:ubuntu24.04` image has
`/usr/local/bin/freex-linux-interactive` as its entrypoint, so passing
`bash /work/container-run.sh` after the image did not run the capture script.
The fixed runner uses an explicit `/bin/bash` entrypoint and invokes the mounted
script directly. It runs `xvfb-run` and the app in the foreground, keeps the
app/Xvfb log, validates the app exit, manifest, PNG signature, nonblank size,
and dimensions, and enforces a 120-second timeout. Cleanup stops and removes
only the exact unique container name supplied to that run.

## Fresh evidence

- Exact container: `freex-wave125-goalseek-capture-20260803-avalonia-r5`
- App exit: `0`
- Capture: nonblank `380x190` PNG at 96 DPI
- Manifest: one captured `dialog.GoalSeekStatus` surface
- Scratch run directories: removed after promotion
- Promoted PNG: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.GoalSeekStatus.png`
- Promoted metadata: `docs/parity/dialog-visual-assets/avalonia-capture/manifest.json`

The current-source WPF/Avalonia comparer reports `2.0871075708061%` mean
pixel difference for the paired surface. Wave124's recorded baseline was
`3.255188%`, an improvement of `1.1680804291939` percentage points, or
`35.8836549284987%` relative. The regenerated dialog summary reports matching
logical and raw dimensions, `isNonBlank=true` on both sides, a triage score of
`0.036590`, and zero visual-review candidates across all 94 paired surfaces.

## Verification

- Focused `ParityCaptureTests`: 4 passed, including the targeted Goal Seek
  Status capture behavior test.
- Fresh bounded Docker capture: passed with `app_exit=0` and
  `capture_validated=true`.
- Dialog visual summary regenerated: 94 paired surfaces, zero nonblank PNG
  failures, zero paired dimension mismatches, zero stale expected-size rows.

## Residuals

The comparer was run with the single fresh Linux target against the canonical
WPF manifest, so its process exit remains nonzero only because the dialog-only
manifests omit the unrelated native Name Box popup contract. No synthetic
resizing, stale promotion, or unbounded timeout was used.
