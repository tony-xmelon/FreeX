# FreeX Format Cells Border parity - Wave109

Date: 2026-08-02

## Scope

This slice aligns the Avalonia `dialog.FormatCells.Border` surface with the WPF Format Cells Border tab. WPF is the behavioral and visual authority for this dialog.

## Changes

- Replaced Avalonia's inline `Individual border details` label and grid wrapper with the shared `AvaloniaCompactDialogChrome.ApplyWpfExpander` chrome.
- Kept the details expander open by default and matched WPF's 8 px content inset.
- Removed the Avalonia-only `Inside horizontal` and `Inside vertical` buttons from the visible Border preview. Interior-border state remains available to the shared planner and is rendered in the preview when the `Inside` preset is applied.
- Kept the existing per-edge style/color controls, preview wiring, automation ids, and apply behavior unchanged.
- Fixed the Linux capture regression where X11 still reported the preceding tab's `620x540` arranged bounds after Border requested `620x596.5`. The parity renderer now treats an explicit dialog size as authoritative, and the selected-tab frame pins the corresponding minimum height while the resize is applied.

## Verification

Focused foreground command:

```text
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --no-restore --filter "FullyQualifiedName~FormatCellsBorderVisualParityTests|FullyQualifiedName~FormatCellsBorderStyleChoicesTests|FullyQualifiedName~FormatCellsDialogNumberFormatSeedTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 29 passed, 0 failed, 0 skipped. This includes the expanded WPF-style expander structure check, absence of visible inside buttons, and a rendered-bounds regression proving Top, Right, Bottom, Left, OK, and Cancel are fully visible in the authoritative `620x597` capture.

The last paired evidence score before this change was triage `0.098981` (`sampleMeanDelta 0.036424`, `nonBackgroundDelta 0.059710`). A fresh WPF/Avalonia pixel recapture was not run in this worker because Docker capture is parent-owned and explicitly serialized; the next parent capture should record the after score.

The production regression capture was `620x540`; the corrected renderer resolves the Border request to `620x597`. Residual risk is limited to platform text rasterization and the final pixel score until the parent refreshes the Docker-owned paired evidence.
