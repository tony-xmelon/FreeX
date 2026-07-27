# FreeP Accessibility Checker chart-title action - 2026-07-28

The Accessibility Checker already identified charts without a title, but its
`Add Chart Title` row only selected the chart. The row now carries the shared
`freep.review.accessibility.chart-title` action and both hosts open the existing
Chart Display Options editor after navigation. The title edit therefore remains
an ordinary undoable chart-display mutation and survives the existing PPTX
round-trip path.

This is a workflow/function slice. It does not claim automatic title generation:
the user still supplies the meaningful title in the chart editor.

Verification covers the shared issue/action descriptor plus WPF and Avalonia
checker-row projection. The host action reuses the already-covered chart display
dialog rather than creating a second accessibility-specific title editor.
