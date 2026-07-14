# FreeP Accessibility Checker Navigation - 2026-07-14

## Scope

This slice moves Accessibility Checker row-selection and navigation fallback policy into `PresentationReviewWorkflowPlanner` so WPF and Avalonia consume the same workflow plan.

## Implemented behavior

- Invalid or stale requested row indexes now normalize through the shared FreeP planner.
- Empty checker results produce a shared no-navigation plan instead of host-local branching.
- Selected rows produce a shared navigation plan with the target slide, optional shape id, and shape-selection requirement.
- WPF and Avalonia adapters route row selection through `BuildAccessibilityCheckerNavigationPlan` before selecting a slide or shape.

## Evidence

- `PresentationReviewWorkflowPlannerTests.BuildAccessibilityCheckerNavigationPlan_NormalizesRequestedRowsForHostAdapters`
- `ReviewWorkflowAdapterTests.MainWindow_AccessibilityCheckerPane_RendersSharedPlanAndRoutesRows`
- `MainWindowHeadlessTests.Accessibility_checker_pane_routes_rows_through_shared_plan`
- WPF and Avalonia source guards assert both adapters call the shared row-selection and navigation planner helpers.

## Deferred

- This is local WPF/Avalonia no-COM workflow evidence only.
- PowerPoint-authoritative Accessibility Checker pane navigation and visual behavior remain deferred until a Microsoft PowerPoint baseline is captured on a COM-capable machine.
