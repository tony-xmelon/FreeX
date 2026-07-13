# FreeP accessibility text contrast diagnostics - 2026-07-13

## Scope

This slice adds no-COM, shared-planner accessibility diagnostics for low-contrast FreeP text. The checker uses a WCAG-style 4.5:1 minimum contrast ratio and emits `Low text contrast` rows only when foreground and background are both explicit, fully opaque, solid sRGB colors.

Covered cases:

- Ordinary shape text against an explicit solid shape fill.
- Ordinary shape text against an explicit solid slide background when the shape has no fill.
- Table-cell text when the effective table cell fill is explicit solid and the run or effective table style text color is explicit solid.

Intentionally excluded in this first bounded slice:

- Readable text at or above 4.5:1.
- Non-text shapes.
- Gradient, pattern, picture, and other complex fills.
- Theme-referenced or otherwise inherited unresolved colors.
- Alpha or composited colors.
- Active chart, OMML/math, SmartArt, and renderer-policy paths.

## Host behavior

WPF and Avalonia consume the same `PresentationAccessibilityCheckerRowPlan` rows from `PresentationReviewWorkflowPlanner`. The hosts do not implement local contrast policy; a low-contrast row uses the generic object-selection action so users can navigate to the affected object and edit either text or background color.

## Validation

Focused validation for this branch is the FreeP shared planner test lane plus the WPF and Avalonia review workflow adapter lanes listed in the worker task.
