# FreeP Slide Pane Wave34 Evidence

Date: 2026-07-27
Branch: `codex/freep-slide-pane-wave34-20260727`
Authority: WPF `FreeP.App.Host/SlidePane.cs`; shared behavior/chrome policy remains in `SlidePanePlanner`.

## Change

Avalonia slide-pane thumbnails now match WPF's display-only preview contract: the embedded
`SlideCanvas` has hit testing and input disabled. Selection, drag reorder, context menus, and
keyboard handling therefore remain owned by the surrounding slide item. No WPF source was changed,
and upstream shape/animation changes from `b89bfd092f` are preserved.

## Audit

| Area | Result | Evidence |
| --- | --- | --- |
| Selection; Insert/Delete/Duplicate; Alt+Up/Down reorder | Pass | Shared planner routes; Avalonia and WPF slide-pane tests |
| Drag threshold, insertion indicator, drop, cancellation | Pass | Shared drag plans and host adapter tests |
| Context menus, Apps/Shift+F10, Escape dismissal/focus restore | Pass | Shared context catalog and Avalonia lifecycle tests |
| Section header collapse/expand, keyboard toggle, section menus | Pass | Shared section projection/plans and host tests |
| Hidden-slide toggle, checked Show/Hide state, undo | Pass | Shared action plan and Avalonia headless test |
| Bottom `+ New Slide`, scroll host, spacing/chrome | Pass | Shared affordance/visual plans and paired shell captures |
| Thumbnail rendering/input ownership | Improved | Avalonia preview is now non-interactive like WPF; WPF remains the richer thumbnail renderer |
| Automation | Pass with residual | Header/button names and context routes are covered; focused visual harness reports no semantic route failures |

## Fresh Captures And Metrics

Fresh pre-edit and post-merge whole-window runs each captured 33/33 paired scenarios at
1280x760 and 96 DPI with zero limitations or duplicates. The target metrics were unchanged:
`startup.slide` remained at 7.4046% target / 8.0274% foreground changed pixels, while
`workspace.slide-pane` remained at 12.3694% / 13.4041%.

The focused seeded runs each captured 28/28 routes with no limitations; 24 passed and four
unrelated dialog routes mismatched. For `startup.slide-pane.seeded`, both pane targets were
180x578 and the semantic focus, button order, enabled state, and nonblank assertions passed.
The pre-edit and final target metrics were unchanged: 30.4931% changed pixels, 38.2981%
foreground changed pixels, and 24.4732 mean channel delta. The 1280x760 shell context measured
29.8683%, 32.2825%, and 22.4700 respectively. This visual residual predates the input-ownership
fix and does not justify changing WPF solely to lower image diff. The generated run directories
were intentionally kept as transient validation artifacts rather than duplicating 598 PNG/report
files in source control.

## Verification

- `FreeP.App.Avalonia.Tests` slide-pane filter: 12/12 passed.
- `FreeP.App.Host.Tests` slide-pane filter: 23/23 passed.
- `FreeP.App.Presentation.Tests` slide-pane filter: 52/52 passed.
- WPF, Avalonia, and `FreeP.RenderCompare` Release builds passed with foreground no-server settings.
- `Generate-FreePWholeWindowVisualEvidenceManifest.ps1` generation and `-Check` passed: 33/33 paired, zero explicit product mismatches, zero capture limitations.

## Residuals

WPF still owns richer thumbnail rendering and deeper section behavior. The focused fresh raster gate
remains a mismatch despite semantic parity; PowerPoint-authoritative thumbnail baselines and deeper
visual comparison are deferred to that rendering lane.
