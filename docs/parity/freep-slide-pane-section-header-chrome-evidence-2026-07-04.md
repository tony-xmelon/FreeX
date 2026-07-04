# FreeP Slide Pane Section Header Chrome Evidence - 2026-07-04

## Scope

This slice closes the next non-overlapping FreeP slide-pane visual parity gap after thumbnail chrome sharing: section-header chrome and grouping affordances.

## Shared Planning

- `SlidePanePlanner.BuildSectionHeaderVisualPlan` now owns section header label text, disclosure text, height, padding, margins, corner radius, normal/hover backgrounds, foreground, tooltip text, and accessible name.
- WPF `SlidePane` consumes the shared section-header visual plan while preserving section context actions and collapse/expand routing.
- Avalonia `MainWindow` consumes the same section-header visual plan and records rendered header plans for headless parity evidence.

## Verification Hooks

- `FreeP.App.Presentation.Tests/SlidePanePlannerTests.cs` verifies expanded and collapsed section-header visual plans.
- `FreeP.App.Host.Tests/SlidePaneTests.cs` verifies WPF rendered section-header chrome against the shared plan, including tooltip and automation name.
- `FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` verifies Avalonia rendered section-header plans expose the shared chrome tokens.
- WPF and Avalonia source guards pin the consumers to `BuildSectionHeaderVisualPlan` so local header color/spacing constants do not drift back in.

## Remaining Slide-Pane Visual Gaps

- PowerPoint-authoritative foreground hover/drop screenshots remain future evidence work.
- Thumbnail bitmap fidelity and richer cross-platform visual comparison remain outside this section-header chrome slice.
