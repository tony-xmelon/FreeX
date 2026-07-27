# Avalonia/WPF Parity Wave 22

Date: 2026-07-27

## FreeX

The Avalonia Page Setup Sheet tab now follows the WPF three-column layout,
including range-picker buttons, WPF control order, full-width fields, and a
fixed non-scrolling body at the shared 600x560 dialog size.

Fresh Ubuntu 24.04 Docker/Xvfb evidence reduced the committed Sheet-tab triage
score from 0.116830 to 0.048332. The remaining capture difference includes
different demo-sheet values as well as platform text/control rasterization.

Focused tests: 85 passed.

## FreeW

The shared Avalonia legal-notices dialog now uses WPF-aligned tab metrics,
content-pane insets, typography, padding, scrolling, and focus behavior. The
content-pane adjustment is an explicit per-dialog parameter, so other shared
tabbed dialogs retain their existing layout.

All six legal-notices states improved in the fresh paired report:

| State | Before | After |
| --- | ---: | ---: |
| Initial | 10.93% | 10.32% |
| Project License | 10.93% | 10.32% |
| Legal Notices | 21.82% | 21.06% |
| Privacy Notice | 18.84% | 18.39% |
| Third-Party Notices | 22.03% | 21.67% |
| Third-Party License Texts | 22.00% | 21.74% |

Focused tests: 15 passed. The canonical report remains at 171 visual-only
mismatches, 12 passes, 4 state-not-applicable rows, and 96 Avalonia extensions.

## FreeP

Split animation effect options now cover Horizontal In, Horizontal Out,
Vertical In, and Vertical Out through the shared model, PPTX reader/writer,
Animation Pane planner, playback planner, and both slideshow hosts. Legacy
Horizontal and Vertical values retain their historical center-out behavior.

Focused tests: 426 passed.

## Verification

Parent integration verification passed 526 focused tests with zero failures.
Generated FreeX dialog evidence, FreeW paired visual evidence, FreeP command
parity inventory, and the cross-app dashboard pass their freshness checks.
