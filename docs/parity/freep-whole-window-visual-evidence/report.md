# FreeP Paired Whole-Window Visual Evidence

Generated `2026-07-20T08:44:06.0044930+00:00` from independently activated WPF and Avalonia app processes.

- Scenarios: 36
- Paired captures: 36
- Pass: 0
- Mismatch: 36
- Limitation: 0
- Duplicate-image scenarios: 4
- Declared contextual tabs observed: 0
- Environment: All pixel gates use the complete 1280x760 app-owned client at logical 96 DPI.
- Environment: The app-owned titlebar, QAT, ribbon, Backstage, workspace, notes, panes, status bar, and zoom/view state are included in the gate.
- Environment: Native OS caption buttons, window-manager shadows, and other non-client decoration are excluded on both hosts; no app-owned client region is masked.
- Environment: WPF capture mode: visible-app-owned-full-client-render-target; native-non-client-excluded; scenario-isolated-processes; Avalonia capture mode: visible-app-owned-full-client-render-target; native-non-client-excluded; scenario-isolated-processes.
- Environment: FreeP currently declares zero contextual ribbon tabs; selected shape/chart/media/SmartArt probes remain explicit mismatches instead of false passes.

## Mismatch Categories

| Category | Scenarios |
|---|---:|
| app-owned-titlebar-raster | 1 |
| contextual-tab-unavailable | 4 |
| duplicate-capture | 4 |
| full-client-pixel-threshold | 1 |
| ribbon-geometry | 36 |
| workspace-geometry | 36 |

## Scenarios

| Scenario | Kind | Result | Categories | Changed pixels | Mean delta | Perceptual distance | Evidence |
|---|---|---|---|---:|---:|---:|---|
| startup.slide | Startup | mismatch | ribbon-geometry, workspace-geometry | 11.21 % | 6.32 | 2 | [WPF full](wpf/full/startup.slide.png) / [Avalonia full](avalonia/full/startup.slide.png) / [WPF client](wpf/client/startup.slide.png) / [Avalonia client](avalonia/client/startup.slide.png) / [diff](diff/startup.slide.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| startup.notes | Startup | mismatch | ribbon-geometry, workspace-geometry | 12.59 % | 8.15 | 4 | [WPF full](wpf/full/startup.notes.png) / [Avalonia full](avalonia/full/startup.notes.png) / [WPF client](wpf/client/startup.notes.png) / [Avalonia client](avalonia/client/startup.notes.png) / [diff](diff/startup.notes.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| ribbon.home | StaticRibbonTab | mismatch | duplicate-capture, ribbon-geometry, workspace-geometry | 15.19 % | 10.53 | 4 | [WPF full](wpf/full/ribbon.home.png) / [Avalonia full](avalonia/full/ribbon.home.png) / [WPF client](wpf/client/ribbon.home.png) / [Avalonia client](avalonia/client/ribbon.home.png) / [diff](diff/ribbon.home.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
|  | Detail |  |  |  |  |  | WPF client PNG is byte-identical to: status.slide-1. |
|  | Detail |  |  |  |  |  | Avalonia client PNG is byte-identical to: status.slide-1. |
| ribbon.insert | StaticRibbonTab | mismatch | ribbon-geometry, workspace-geometry | 14.89 % | 10.41 | 3 | [WPF full](wpf/full/ribbon.insert.png) / [Avalonia full](avalonia/full/ribbon.insert.png) / [WPF client](wpf/client/ribbon.insert.png) / [Avalonia client](avalonia/client/ribbon.insert.png) / [diff](diff/ribbon.insert.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| ribbon.design | StaticRibbonTab | mismatch | ribbon-geometry, workspace-geometry | 13.03 % | 8.96 | 3 | [WPF full](wpf/full/ribbon.design.png) / [Avalonia full](avalonia/full/ribbon.design.png) / [WPF client](wpf/client/ribbon.design.png) / [Avalonia client](avalonia/client/ribbon.design.png) / [diff](diff/ribbon.design.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| ribbon.transitions | StaticRibbonTab | mismatch | ribbon-geometry, workspace-geometry | 17.08 % | 11.55 | 5 | [WPF full](wpf/full/ribbon.transitions.png) / [Avalonia full](avalonia/full/ribbon.transitions.png) / [WPF client](wpf/client/ribbon.transitions.png) / [Avalonia client](avalonia/client/ribbon.transitions.png) / [diff](diff/ribbon.transitions.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| ribbon.animations | StaticRibbonTab | mismatch | ribbon-geometry, workspace-geometry | 15.55 % | 10.73 | 4 | [WPF full](wpf/full/ribbon.animations.png) / [Avalonia full](avalonia/full/ribbon.animations.png) / [WPF client](wpf/client/ribbon.animations.png) / [Avalonia client](avalonia/client/ribbon.animations.png) / [diff](diff/ribbon.animations.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| ribbon.view | StaticRibbonTab | mismatch | ribbon-geometry, workspace-geometry | 11.81 % | 8.26 | 2 | [WPF full](wpf/full/ribbon.view.png) / [Avalonia full](avalonia/full/ribbon.view.png) / [WPF client](wpf/client/ribbon.view.png) / [Avalonia client](avalonia/client/ribbon.view.png) / [diff](diff/ribbon.view.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| contextual.shape | ContextualSelection | mismatch | contextual-tab-unavailable, ribbon-geometry, workspace-geometry | 15.63 % | 10.84 | 4 | [WPF full](wpf/full/contextual.shape.png) / [Avalonia full](avalonia/full/contextual.shape.png) / [WPF client](wpf/client/contextual.shape.png) / [Avalonia client](avalonia/client/contextual.shape.png) / [diff](diff/contextual.shape.png) |
|  | Detail |  |  |  |  |  | contextual-tab-visible: Expected contextual tab 'ShapeFormatTab', but FreeP declares no contextual ribbon tabs. |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| contextual.chart | ContextualSelection | mismatch | contextual-tab-unavailable, ribbon-geometry, workspace-geometry | 15.87 % | 11.00 | 4 | [WPF full](wpf/full/contextual.chart.png) / [Avalonia full](avalonia/full/contextual.chart.png) / [WPF client](wpf/client/contextual.chart.png) / [Avalonia client](avalonia/client/contextual.chart.png) / [diff](diff/contextual.chart.png) |
|  | Detail |  |  |  |  |  | contextual-tab-visible: Expected contextual tab 'ChartDesignTab', but FreeP declares no contextual ribbon tabs. |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| contextual.media | ContextualSelection | mismatch | contextual-tab-unavailable, ribbon-geometry, workspace-geometry | 15.53 % | 10.71 | 4 | [WPF full](wpf/full/contextual.media.png) / [Avalonia full](avalonia/full/contextual.media.png) / [WPF client](wpf/client/contextual.media.png) / [Avalonia client](avalonia/client/contextual.media.png) / [diff](diff/contextual.media.png) |
|  | Detail |  |  |  |  |  | contextual-tab-visible: Expected contextual tab 'MediaFormatTab', but FreeP declares no contextual ribbon tabs. |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| contextual.smartart | ContextualSelection | mismatch | contextual-tab-unavailable, ribbon-geometry, workspace-geometry | 15.61 % | 10.81 | 4 | [WPF full](wpf/full/contextual.smartart.png) / [Avalonia full](avalonia/full/contextual.smartart.png) / [WPF client](wpf/client/contextual.smartart.png) / [Avalonia client](avalonia/client/contextual.smartart.png) / [diff](diff/contextual.smartart.png) |
|  | Detail |  |  |  |  |  | contextual-tab-visible: Expected contextual tab 'SmartArtDesignTab', but FreeP declares no contextual ribbon tabs. |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.info | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 1.75 % | 1.69 | 0 | [WPF full](wpf/full/backstage.info.png) / [Avalonia full](avalonia/full/backstage.info.png) / [WPF client](wpf/client/backstage.info.png) / [Avalonia client](avalonia/client/backstage.info.png) / [diff](diff/backstage.info.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.recent | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 7.41 % | 6.94 | 3 | [WPF full](wpf/full/backstage.recent.png) / [Avalonia full](avalonia/full/backstage.recent.png) / [WPF client](wpf/client/backstage.recent.png) / [Avalonia client](avalonia/client/backstage.recent.png) / [diff](diff/backstage.recent.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.new-from-template | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 2.22 % | 1.62 | 0 | [WPF full](wpf/full/backstage.new-from-template.png) / [Avalonia full](avalonia/full/backstage.new-from-template.png) / [WPF client](wpf/client/backstage.new-from-template.png) / [Avalonia client](avalonia/client/backstage.new-from-template.png) / [diff](diff/backstage.new-from-template.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.print | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 6.75 % | 5.83 | 4 | [WPF full](wpf/full/backstage.print.png) / [Avalonia full](avalonia/full/backstage.print.png) / [WPF client](wpf/client/backstage.print.png) / [Avalonia client](avalonia/client/backstage.print.png) / [diff](diff/backstage.print.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.export | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 3.08 % | 2.65 | 1 | [WPF full](wpf/full/backstage.export.png) / [Avalonia full](avalonia/full/backstage.export.png) / [WPF client](wpf/client/backstage.export.png) / [Avalonia client](avalonia/client/backstage.export.png) / [diff](diff/backstage.export.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.options | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 2.20 % | 2.07 | 0 | [WPF full](wpf/full/backstage.options.png) / [Avalonia full](avalonia/full/backstage.options.png) / [WPF client](wpf/client/backstage.options.png) / [Avalonia client](avalonia/client/backstage.options.png) / [diff](diff/backstage.options.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| backstage.account | BackstagePane | mismatch | ribbon-geometry, workspace-geometry | 3.39 % | 3.25 | 1 | [WPF full](wpf/full/backstage.account.png) / [Avalonia full](avalonia/full/backstage.account.png) / [WPF client](wpf/client/backstage.account.png) / [Avalonia client](avalonia/client/backstage.account.png) / [diff](diff/backstage.account.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| status.slide-1 | StatusBar | mismatch | duplicate-capture, ribbon-geometry, workspace-geometry | 15.19 % | 10.53 | 4 | [WPF full](wpf/full/status.slide-1.png) / [Avalonia full](avalonia/full/status.slide-1.png) / [WPF client](wpf/client/status.slide-1.png) / [Avalonia client](avalonia/client/status.slide-1.png) / [diff](diff/status.slide-1.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
|  | Detail |  |  |  |  |  | WPF client PNG is byte-identical to: ribbon.home. |
|  | Detail |  |  |  |  |  | Avalonia client PNG is byte-identical to: ribbon.home. |
| status.slide-2 | StatusBar | mismatch | ribbon-geometry, workspace-geometry | 12.22 % | 7.21 | 4 | [WPF full](wpf/full/status.slide-2.png) / [Avalonia full](avalonia/full/status.slide-2.png) / [WPF client](wpf/client/status.slide-2.png) / [Avalonia client](avalonia/client/status.slide-2.png) / [diff](diff/status.slide-2.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| view.gridlines-guides | ViewState | mismatch | duplicate-capture, ribbon-geometry, workspace-geometry | 12.24 % | 8.57 | 2 | [WPF full](wpf/full/view.gridlines-guides.png) / [Avalonia full](avalonia/full/view.gridlines-guides.png) / [WPF client](wpf/client/view.gridlines-guides.png) / [Avalonia client](avalonia/client/view.gridlines-guides.png) / [diff](diff/view.gridlines-guides.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
|  | Detail |  |  |  |  |  | WPF client PNG is byte-identical to: view.clean-canvas. |
|  | Detail |  |  |  |  |  | Avalonia client PNG is byte-identical to: view.clean-canvas. |
| view.clean-canvas | ViewState | mismatch | duplicate-capture, ribbon-geometry, workspace-geometry | 12.24 % | 8.57 | 2 | [WPF full](wpf/full/view.clean-canvas.png) / [Avalonia full](avalonia/full/view.clean-canvas.png) / [WPF client](wpf/client/view.clean-canvas.png) / [Avalonia client](avalonia/client/view.clean-canvas.png) / [diff](diff/view.clean-canvas.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
|  | Detail |  |  |  |  |  | WPF client PNG is byte-identical to: view.gridlines-guides. |
|  | Detail |  |  |  |  |  | Avalonia client PNG is byte-identical to: view.gridlines-guides. |
| view.zoom-fit | ViewState | mismatch | ribbon-geometry, workspace-geometry | 12.39 % | 8.72 | 2 | [WPF full](wpf/full/view.zoom-fit.png) / [Avalonia full](avalonia/full/view.zoom-fit.png) / [WPF client](wpf/client/view.zoom-fit.png) / [Avalonia client](avalonia/client/view.zoom-fit.png) / [diff](diff/view.zoom-fit.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| view.zoom-200 | ViewState | mismatch | app-owned-titlebar-raster, full-client-pixel-threshold, ribbon-geometry, workspace-geometry | 26.03 % | 35.42 | 11 | [WPF full](wpf/full/view.zoom-200.png) / [Avalonia full](avalonia/full/view.zoom-200.png) / [WPF client](wpf/client/view.zoom-200.png) / [Avalonia client](avalonia/client/view.zoom-200.png) / [diff](diff/view.zoom-200.png) |
|  | Detail |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.0%). |
|  | Detail |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.0%). |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
|  | Detail |  |  |  |  |  | Full-client threshold failed: changed 26.03 % (max 20 %), mean channel delta 35.42 (max 18.00), perceptual hash distance 11 (max 18). |
| workspace.slide-pane | WorkspaceRegion | mismatch | ribbon-geometry, workspace-geometry | 11.92 % | 7.09 | 3 | [WPF full](wpf/full/workspace.slide-pane.png) / [Avalonia full](avalonia/full/workspace.slide-pane.png) / [WPF client](wpf/client/workspace.slide-pane.png) / [Avalonia client](avalonia/client/workspace.slide-pane.png) / [diff](diff/workspace.slide-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| workspace.notes-pane | WorkspaceRegion | mismatch | ribbon-geometry, workspace-geometry | 9.08 % | 5.71 | 1 | [WPF full](wpf/full/workspace.notes-pane.png) / [Avalonia full](avalonia/full/workspace.notes-pane.png) / [WPF client](wpf/client/workspace.notes-pane.png) / [Avalonia client](avalonia/client/workspace.notes-pane.png) / [diff](diff/workspace.notes-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x128.7. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| workspace.canvas | WorkspaceRegion | mismatch | ribbon-geometry, workspace-geometry | 13.70 % | 9.43 | 3 | [WPF full](wpf/full/workspace.canvas.png) / [Avalonia full](avalonia/full/workspace.canvas.png) / [WPF client](wpf/client/workspace.canvas.png) / [Avalonia client](avalonia/client/workspace.canvas.png) / [diff](diff/workspace.canvas.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| review.comments-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 16.45 % | 12.24 | 3 | [WPF full](wpf/full/review.comments-pane.png) / [Avalonia full](avalonia/full/review.comments-pane.png) / [WPF client](wpf/client/review.comments-pane.png) / [Avalonia client](avalonia/client/review.comments-pane.png) / [diff](diff/review.comments-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| review.accessibility-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 17.57 % | 13.15 | 10 | [WPF full](wpf/full/review.accessibility-pane.png) / [Avalonia full](avalonia/full/review.accessibility-pane.png) / [WPF client](wpf/client/review.accessibility-pane.png) / [Avalonia client](avalonia/client/review.accessibility-pane.png) / [diff](diff/review.accessibility-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| review.alt-text-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 16.69 % | 12.39 | 7 | [WPF full](wpf/full/review.alt-text-pane.png) / [Avalonia full](avalonia/full/review.alt-text-pane.png) / [WPF client](wpf/client/review.alt-text-pane.png) / [Avalonia client](avalonia/client/review.alt-text-pane.png) / [diff](diff/review.alt-text-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| review.reading-order-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 18.15 % | 13.55 | 11 | [WPF full](wpf/full/review.reading-order-pane.png) / [Avalonia full](avalonia/full/review.reading-order-pane.png) / [WPF client](wpf/client/review.reading-order-pane.png) / [Avalonia client](avalonia/client/review.reading-order-pane.png) / [diff](diff/review.reading-order-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| review.proofing-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 15.03 % | 10.82 | 7 | [WPF full](wpf/full/review.proofing-pane.png) / [Avalonia full](avalonia/full/review.proofing-pane.png) / [WPF client](wpf/client/review.proofing-pane.png) / [Avalonia client](avalonia/client/review.proofing-pane.png) / [diff](diff/review.proofing-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| accessibility.media-caption-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 17.26 % | 13.29 | 8 | [WPF full](wpf/full/accessibility.media-caption-pane.png) / [Avalonia full](avalonia/full/accessibility.media-caption-pane.png) / [WPF client](wpf/client/accessibility.media-caption-pane.png) / [Avalonia client](avalonia/client/accessibility.media-caption-pane.png) / [diff](diff/accessibility.media-caption-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| context.smartart-text-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 15.52 % | 11.53 | 7 | [WPF full](wpf/full/context.smartart-text-pane.png) / [Avalonia full](avalonia/full/context.smartart-text-pane.png) / [WPF client](wpf/client/context.smartart-text-pane.png) / [Avalonia client](avalonia/client/context.smartart-text-pane.png) / [diff](diff/context.smartart-text-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
| animations.animation-pane | AuxiliaryPane | mismatch | ribbon-geometry, workspace-geometry | 17.35 % | 12.38 | 5 | [WPF full](wpf/full/animations.animation-pane.png) / [Avalonia full](avalonia/full/animations.animation-pane.png) / [WPF client](wpf/client/animations.animation-pane.png) / [Avalonia client](avalonia/client/animations.animation-pane.png) / [diff](diff/animations.animation-pane.png) |
|  | Detail |  |  |  |  |  | Ribbon bounds differ: WPF 0.0,34.0 1280.0x123.0; Avalonia 0.0,34.0 1280.0x132.0. |
|  | Detail |  |  |  |  |  | Slide pane, canvas, or notes-pane bounds differ. |
