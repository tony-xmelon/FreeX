# FreeX Format Cells Border parity - Wave109

Date: 2026-08-02

## Scope

This slice aligns the Avalonia `dialog.FormatCells.Border` surface with the WPF Format Cells Border tab. WPF is the behavioral and visual authority for this dialog.

## Changes

- Replaced Avalonia's inline `Individual border details` label and grid wrapper with the shared `AvaloniaCompactDialogChrome.ApplyWpfExpander` chrome.
- Kept the details expander open by default and matched WPF's 8 px content inset.
- Removed the Avalonia-only `Inside horizontal` and `Inside vertical` buttons from the visible Border preview. Interior-border state remains available to the shared planner and is rendered in the preview when the `Inside` preset is applied.
- Kept the existing per-edge style/color controls, preview wiring, automation ids, and apply behavior unchanged.
- Fixed the Linux X11 resize regression where changing the requested `Height` left the actual client and arranged bounds at the preceding tab's `620x540` size. The selected-tab frame now sets `ClientSize`, which drives Avalonia's native platform resize API, while retaining the matching width, height, and minimum-height constraints.
- Dialog capture now waits for the requested layout and renders only the actual arranged bounds. A request/bounds mismatch fails capture instead of creating a larger bitmap with black padding.

## Verification

Focused foreground command:

```text
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --no-restore --filter "FullyQualifiedName~FormatCellsBorderVisualParityTests|FullyQualifiedName~FormatCellsBorderStyleChoicesTests|FullyQualifiedName~FormatCellsDialogNumberFormatSeedTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 29 passed, 0 failed, 0 skipped. This includes the expanded WPF-style expander structure check, absence of visible inside buttons, a capture invariant rejecting the observed `620x540` stale layout, and a rendered-bounds regression proving Top, Right, Bottom, Left, OK, and Cancel are fully visible in the authoritative `620x597` client.

The parent-owned production Linux Docker/Xvfb recapture produced a complete `620x597` bitmap and reduced triage from `0.098981` to `0.032791` (`sampleMeanDelta 0.026232`, `nonBackgroundDelta 0.003493`). The capture has exact paired pixel dimensions, contains all four edge rows and both action buttons, and has no padded black rows. This is a 66.9% reduction in the triage score.

The production regression had a `620x540` client padded into a `620x597` bitmap. The corrected production resize requests a `620x596.5` client, which captures to `620x597`, while the capture invariant prevents undersized native bounds from being hidden. The remaining delta is native control and text rasterization rather than missing or clipped content.
