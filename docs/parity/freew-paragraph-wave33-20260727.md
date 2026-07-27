# FreeW Paragraph Dialog Wave33

WPF remains the authority. The WPF implementation is `freew/FreeW.App.Host/ParagraphBreaksDialog.cs`;
Avalonia is `freew/FreeW.App.Avalonia/ParagraphDialog.cs`.

## Scope

- Preserved the matched WPF geometry already established by the preceding waves: `380x345` for
  Indents and Spacing and `380x327` for Line and Page Breaks.
- Fixed Avalonia result propagation so applying the dialog writes `WidowControlIsSet = true`, including
  when the checkbox is cleared. This matches WPF's explicit-off semantics.
- Fixed Avalonia inline validation visibility by applying validation chrome before restoring the status
  block's visible state.
- Added focused tests for explicit widow-control propagation and invalid-input routing. No WPF or shared
  project code was changed.

## Fresh Paired Evidence

The current harness was regenerated at 158 routes / 466 scenarios, then captured five matched Paragraph
states at 96 DPI. Historical canonical ratios were not used as the current baseline.

| State | Dimensions | Before changed ratio | After changed ratio | Before mean delta | After mean delta | After p95 | Classification |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `paragraph.initial` | 380x345 | 0.1494965675 | 0.1494965675 | 15.5008848207 | 15.5008848207 | 108 | genuine-visual-mismatch |
| `paragraph.populated` | 380x345 | 0.1494965675 | 0.1494965675 | 15.5008848207 | 15.5008848207 | 108 | genuine-visual-mismatch |
| `paragraph.tab-indents-and-spacing` | 380x345 | 0.1494965675 | 0.1494965675 | 15.5008848207 | 15.5008848207 | 108 | genuine-visual-mismatch |
| `paragraph.tab-line-and-page-breaks` | 380x327 | 0.0847819089 | 0.0847819089 | 9.7022721176 | 9.7022721176 | 83 | genuine-visual-mismatch |
| `paragraph.validation-error` | 380x345 | 0.1579023646 | 0.1579023646 | 16.3767302314 | 16.3767302314 | 108 | genuine-visual-mismatch |

The unchanged pixels are honest: the code fixes are functional and validation-only, while the visible
geometry/chrome was already aligned before Wave33. The final comparison has all five WPF/Avalonia captures
validated for content and no semantic difference reported for these rows.

## Evidence Paths

```text
Before comparison:
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-report-20260727\compare3\freew_dialog_visual_comparison.json
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-report-20260727\compare3\heatmaps\

After comparison:
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-final-report-20260727\compare\freew_dialog_visual_comparison.json
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-final-report-20260727\compare\heatmaps\

Final WPF manifest:
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-final-report-20260727\wpf_dialog_capture_manifest.json

Final Avalonia manifest:
C:\Users\anton\OneDrive\Documents\FreeX\FreeX\.worktrees\freew-paragraph-dialog-wave33-20260727\artifacts\freew-paragraph-wave33-final-report-20260727\avalonia_dialog_capture_manifest.json
```

## Verification

- `dotnet build FreeW.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- Avalonia focused filter (`ParagraphDialogVisualParityTests|FontAndParagraphDialogTests`): passed, 34/34.
- `FreeW.App.Presentation.Tests` filter `FullyQualifiedName~Paragraph`: passed, 29/29.
- `FreeW.App.Host.Tests` filter `FullyQualifiedName~Paragraph`: passed, 67/67.
- Fresh WPF captures: 5/5 captured.
- Fresh Avalonia captures: 5/5 captured.
- Final comparison: 5/5 Paragraph rows captured and content-valid; command exit code 2 because all five remain genuine visual mismatches, not because of unsupported captures.

## Remaining Gaps

This slice does not claim 100% visual parity. Remaining differences are platform text rasterization and
native/template details such as combo-arrow rendering. The static harness validation row captures invalid
input before activation; the post-activation inline error, tab reset, and dialog-open behavior are covered
by the focused Avalonia test rather than represented as a separate image state.
