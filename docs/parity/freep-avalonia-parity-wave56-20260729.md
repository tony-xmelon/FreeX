# FreeP Avalonia parity Wave 56

## Live slide-pane accessibility

The shared `SlidePanePlanner` already derives accessible names for slide thumbnail
and section-header plans. Wave 56 assigns the thumbnail name to the live slide item
container in both hosts:

- WPF `SlidePane` assigns `plan.AccessibleName` to each thumbnail `Border`.
- Avalonia `MainWindow` assigns `plan.AccessibleName` to each thumbnail `ListBoxItem`.
- Both hosts reapply the planner-derived name during selection-only chrome updates.
- Section-header names continue to come from the shared section-header plan, including
  expanded/collapsed state.

The live host tests cover title changes, reordered slide numbers, selection changes,
and section expansion/collapse. The shared planner test covers refreshed entry and
slide content.

## Verification

- `FreeP.App.Presentation.Tests`, filtered to `SlidePanePlannerTests`: 53 passed.
- `FreeP.App.Host.Tests`, filtered to `SlidePane`: 25 passed.
- `FreeP.App.Avalonia.Tests`, filtered to `SlidePane`: 15 passed.
- `dotnet build FreeP.slnx --configuration Release`: 0 warnings, 0 errors.

## Residuals

Broader live accessibility contracts for notes, Selection Pane headings, slide
thumbnail containers beyond the pane, and adjacent authored panes remain outside
this bounded slice.
