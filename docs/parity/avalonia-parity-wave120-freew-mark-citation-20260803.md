# Avalonia parity Wave120 FreeW Mark Citation - 2026-08-03

## Scope

This slice aligns FreeW References > Mark Citation between WPF and Avalonia.
The behavior contract was already shared through `MarkCitationDialogPlanner`,
but the hosts used different geometry: WPF rendered a vertical form while
Avalonia compressed the labels and fields into a two-column grid.

## Implementation

- Shared planner constants now own the 380-DIP dialog width, content margins,
  label-to-field rhythm, field spacing, action-row spacing, and button labels.
- Both hosts consume those constants while retaining native WPF/Avalonia
  controls and dialog chrome.
- Avalonia now uses the WPF vertical label-then-full-width-field structure.
- Avalonia restores initial focus and selection on the long-citation field.
- Validation, category selection, long and short citation construction,
  default/cancel behavior, and closing semantics remain unchanged.

The visual harness continues to capture both hosts on its fixed 560x600
comparison canvas. That canvas is evidence geometry, not the in-app dialog
size; both real dialogs remain 380 DIP wide and size themselves to content.

## Evidence

Fresh WPF and Avalonia captures completed for `initial`, `populated`, and
`validation-error`. All six captures passed the content gate and retained no
semantic differences.

| State | Before changed pixels | After changed pixels | After mean delta | WPF bounds | Avalonia bounds |
| --- | ---: | ---: | ---: | --- | --- |
| initial | 10.45% | 4.5363% | 3.4239 | 513x199 at 16,20 | 514x194 at 16,20 |
| populated | 10.48% | 4.8527% | 3.8960 | 513x199 at 16,20 | 514x194 at 16,20 |
| validation-error | 10.52% | 4.6497% | 3.5727 | 513x199 at 16,20 | 514x194 at 16,20 |

The route remains an honest `genuine-visual-mismatch` because native control
templates, text rasterization, and a five-pixel content-height residual still
differ. The canonical FreeW report was refreshed only for `mark-citation`.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj -c Release --filter FullyQualifiedName~MarkCitationDialogPlannerTests --no-restore`: 5 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~ReferencesTabTests.MarkCitation --no-restore`: 5 passed.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --filter FullyQualifiedName~MarkCitationDialogTests --no-restore`: 3 passed.
- Focused WPF capture: 3/3 captured.
- Focused Avalonia capture: 3/3 captured.
- Focused comparison: 3/3 paired, content gates passed, no semantic differences.
