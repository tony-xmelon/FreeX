# FreeP Avalonia/WPF Parity Wave54

## Bounded functional slice

The WPF slide pane assigns each section header's planner-provided accessible name to
the header control. Avalonia rendered the same section-header plan and supported the
same keyboard/context-menu behavior, but omitted the automation name from the live
`ListBoxItem`. Screen readers and UI automation therefore could not identify the
section or its expanded/collapsed state on Avalonia.

Avalonia now assigns `SlidePaneSectionHeaderVisualPlan.AccessibleName` through
`AutomationProperties.Name`. A headless regression test verifies the live header
receives the WPF-equivalent value (`Section Intro  (2), expanded`).

## Verification

- Focused Avalonia headless regression: `SlidePane_section_headers_expose_wpf_equivalent_automation_names`
- Source guard: Avalonia slide-pane policy keeps the automation assignment beside the shared section-header plan.

## Residuals

- This slice covers section-header discoverability only; broader FreeP accessibility
  depth and PowerPoint-authoritative visual baselines remain separate work.
- No push or merge was performed.
