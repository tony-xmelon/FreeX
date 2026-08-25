# FreeP Paired Whole-Window Visual Evidence

Generated `2026-08-25T06:16:57.9820713+00:00` from independently activated WPF and Avalonia app processes.

- Scenarios: 36
- Paired captures: 36
- Pass: 0
- Mismatch: 36
- Limitation: 0
- Duplicate-image scenarios: 0
- Declared contextual tabs observed: 2
- Environment: All pixel gates use the complete 1280x760 app-owned client at logical 96 DPI.
- Environment: The app-owned titlebar, QAT, ribbon, Backstage, workspace, notes, panes, status bar, and zoom/view state are included in the gate.
- Environment: Native OS caption buttons, window-manager shadows, and other non-client decoration are excluded on both hosts; no app-owned client region is masked.
- Environment: WPF capture mode: visible-app-owned-full-client-render-target; native-non-client-excluded; scenario-isolated-processes; Avalonia capture mode: visible-app-owned-full-client-render-target; native-non-client-excluded; scenario-isolated-processes.
- Environment: Observed 2 contextual ribbon tab id(s).
- Environment: Gridline/guide scenarios use the runtime ribbon command path; both current canvas renderers apply those flags to snapping and do not paint gridline/guide canvas raster.
- Environment: Rich-editor overlay scenarios use each host's production editor with shared mixed runs and deterministic selection/caret offsets. They prove visible layout, focus, selection, and caret state; they do not claim physical pointer hit-testing, IME, clipboard, undo, or commit behavior.

## Mismatch Categories

| Category | Scenarios |
|---|---:|
| app-owned-titlebar-raster | 36 |
| contextual-tab-strip | 17 |
| ribbon-tab-strip | 17 |
| rich-editor-selection-pixel-threshold | 1 |

## Scenarios

| Scenario | Kind | Result | Categories | Changed pixels | Mean delta | Perceptual distance | Selection changed pixels | Evidence |
|---|---|---|---|---:|---:|---:|---:|---|
| startup.slide | Startup | mismatch | app-owned-titlebar-raster | 7.70 % | 5.44 | 2 | n/a | [WPF full](wpf/full/startup.slide.png) / [Avalonia full](avalonia/full/startup.slide.png) / [WPF client](wpf/client/startup.slide.png) / [Avalonia client](avalonia/client/startup.slide.png) / [diff](diff/startup.slide.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| startup.notes | Startup | mismatch | app-owned-titlebar-raster | 9.26 % | 7.27 | 3 | n/a | [WPF full](wpf/full/startup.notes.png) / [Avalonia full](avalonia/full/startup.notes.png) / [WPF client](wpf/client/startup.notes.png) / [Avalonia client](avalonia/client/startup.notes.png) / [diff](diff/startup.notes.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.home | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 9.71 % | 7.32 | 3 | n/a | [WPF full](wpf/full/ribbon.home.png) / [Avalonia full](avalonia/full/ribbon.home.png) / [WPF client](wpf/client/ribbon.home.png) / [Avalonia client](avalonia/client/ribbon.home.png) / [diff](diff/ribbon.home.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.insert | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 10.11 % | 7.84 | 3 | n/a | [WPF full](wpf/full/ribbon.insert.png) / [Avalonia full](avalonia/full/ribbon.insert.png) / [WPF client](wpf/client/ribbon.insert.png) / [Avalonia client](avalonia/client/ribbon.insert.png) / [diff](diff/ribbon.insert.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.design | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 7.92 % | 6.23 | 2 | n/a | [WPF full](wpf/full/ribbon.design.png) / [Avalonia full](avalonia/full/ribbon.design.png) / [WPF client](wpf/client/ribbon.design.png) / [Avalonia client](avalonia/client/ribbon.design.png) / [diff](diff/ribbon.design.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.transitions | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 7.07 % | 5.81 | 2 | n/a | [WPF full](wpf/full/ribbon.transitions.png) / [Avalonia full](avalonia/full/ribbon.transitions.png) / [WPF client](wpf/client/ribbon.transitions.png) / [Avalonia client](avalonia/client/ribbon.transitions.png) / [diff](diff/ribbon.transitions.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.animations | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 9.05 % | 6.74 | 4 | n/a | [WPF full](wpf/full/ribbon.animations.png) / [Avalonia full](avalonia/full/ribbon.animations.png) / [WPF client](wpf/client/ribbon.animations.png) / [Avalonia client](avalonia/client/ribbon.animations.png) / [diff](diff/ribbon.animations.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.slide-show | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 7.37 % | 5.51 | 3 | n/a | [WPF full](wpf/full/ribbon.slide-show.png) / [Avalonia full](avalonia/full/ribbon.slide-show.png) / [WPF client](wpf/client/ribbon.slide-show.png) / [Avalonia client](avalonia/client/ribbon.slide-show.png) / [diff](diff/ribbon.slide-show.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.review | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 7.66 % | 5.87 | 3 | n/a | [WPF full](wpf/full/ribbon.review.png) / [Avalonia full](avalonia/full/ribbon.review.png) / [WPF client](wpf/client/ribbon.review.png) / [Avalonia client](avalonia/client/ribbon.review.png) / [diff](diff/ribbon.review.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| ribbon.view | StaticRibbonTab | mismatch | app-owned-titlebar-raster | 10.64 % | 8.07 | 2 | n/a | [WPF full](wpf/full/ribbon.view.png) / [Avalonia full](avalonia/full/ribbon.view.png) / [WPF client](wpf/client/ribbon.view.png) / [Avalonia client](avalonia/client/ribbon.view.png) / [diff](diff/ribbon.view.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| backstage.info | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 1.50 % | 1.59 | 0 | n/a | [WPF full](wpf/full/backstage.info.png) / [Avalonia full](avalonia/full/backstage.info.png) / [WPF client](wpf/client/backstage.info.png) / [Avalonia client](avalonia/client/backstage.info.png) / [diff](diff/backstage.info.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.recent | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 2.20 % | 1.99 | 0 | n/a | [WPF full](wpf/full/backstage.recent.png) / [Avalonia full](avalonia/full/backstage.recent.png) / [WPF client](wpf/client/backstage.recent.png) / [Avalonia client](avalonia/client/backstage.recent.png) / [diff](diff/backstage.recent.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.new-from-template | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 1.51 % | 1.46 | 0 | n/a | [WPF full](wpf/full/backstage.new-from-template.png) / [Avalonia full](avalonia/full/backstage.new-from-template.png) / [WPF client](wpf/client/backstage.new-from-template.png) / [Avalonia client](avalonia/client/backstage.new-from-template.png) / [diff](diff/backstage.new-from-template.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.print | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 5.82 % | 5.37 | 5 | n/a | [WPF full](wpf/full/backstage.print.png) / [Avalonia full](avalonia/full/backstage.print.png) / [WPF client](wpf/client/backstage.print.png) / [Avalonia client](avalonia/client/backstage.print.png) / [diff](diff/backstage.print.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.export | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 2.72 % | 2.68 | 0 | n/a | [WPF full](wpf/full/backstage.export.png) / [Avalonia full](avalonia/full/backstage.export.png) / [WPF client](wpf/client/backstage.export.png) / [Avalonia client](avalonia/client/backstage.export.png) / [diff](diff/backstage.export.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.options | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 2.10 % | 2.00 | 1 | n/a | [WPF full](wpf/full/backstage.options.png) / [Avalonia full](avalonia/full/backstage.options.png) / [WPF client](wpf/client/backstage.options.png) / [Avalonia client](avalonia/client/backstage.options.png) / [diff](diff/backstage.options.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| backstage.account | BackstagePane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 2.89 % | 2.95 | 1 | n/a | [WPF full](wpf/full/backstage.account.png) / [Avalonia full](avalonia/full/backstage.account.png) / [WPF client](wpf/client/backstage.account.png) / [Avalonia client](avalonia/client/backstage.account.png) / [diff](diff/backstage.account.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| status.slide-2 | StatusBar | mismatch | app-owned-titlebar-raster | 9.01 % | 6.64 | 3 | n/a | [WPF full](wpf/full/status.slide-2.png) / [Avalonia full](avalonia/full/status.slide-2.png) / [WPF client](wpf/client/status.slide-2.png) / [Avalonia client](avalonia/client/status.slide-2.png) / [diff](diff/status.slide-2.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| view.gridlines-guides | ViewState | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 11.01 % | 8.37 | 3 | n/a | [WPF full](wpf/full/view.gridlines-guides.png) / [Avalonia full](avalonia/full/view.gridlines-guides.png) / [WPF client](wpf/client/view.gridlines-guides.png) / [Avalonia client](avalonia/client/view.gridlines-guides.png) / [diff](diff/view.gridlines-guides.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| view.clean-canvas | ViewState | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 10.89 % | 8.29 | 3 | n/a | [WPF full](wpf/full/view.clean-canvas.png) / [Avalonia full](avalonia/full/view.clean-canvas.png) / [WPF client](wpf/client/view.clean-canvas.png) / [Avalonia client](avalonia/client/view.clean-canvas.png) / [diff](diff/view.clean-canvas.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| view.zoom-fit | ViewState | mismatch | app-owned-titlebar-raster | 11.19 % | 8.46 | 2 | n/a | [WPF full](wpf/full/view.zoom-fit.png) / [Avalonia full](avalonia/full/view.zoom-fit.png) / [WPF client](wpf/client/view.zoom-fit.png) / [Avalonia client](avalonia/client/view.zoom-fit.png) / [diff](diff/view.zoom-fit.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| view.zoom-200 | ViewState | mismatch | app-owned-titlebar-raster | 12.36 % | 9.80 | 1 | n/a | [WPF full](wpf/full/view.zoom-200.png) / [Avalonia full](avalonia/full/view.zoom-200.png) / [WPF client](wpf/client/view.zoom-200.png) / [Avalonia client](avalonia/client/view.zoom-200.png) / [diff](diff/view.zoom-200.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| workspace.slide-pane | WorkspaceRegion | mismatch | app-owned-titlebar-raster | 9.41 % | 7.17 | 3 | n/a | [WPF full](wpf/full/workspace.slide-pane.png) / [Avalonia full](avalonia/full/workspace.slide-pane.png) / [WPF client](wpf/client/workspace.slide-pane.png) / [Avalonia client](avalonia/client/workspace.slide-pane.png) / [diff](diff/workspace.slide-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| workspace.notes-pane | WorkspaceRegion | mismatch | app-owned-titlebar-raster | 10.19 % | 8.03 | 2 | n/a | [WPF full](wpf/full/workspace.notes-pane.png) / [Avalonia full](avalonia/full/workspace.notes-pane.png) / [WPF client](wpf/client/workspace.notes-pane.png) / [Avalonia client](avalonia/client/workspace.notes-pane.png) / [diff](diff/workspace.notes-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| workspace.canvas | WorkspaceRegion | mismatch | app-owned-titlebar-raster | 8.47 % | 6.62 | 2 | n/a | [WPF full](wpf/full/workspace.canvas.png) / [Avalonia full](avalonia/full/workspace.canvas.png) / [WPF client](wpf/client/workspace.canvas.png) / [Avalonia client](avalonia/client/workspace.canvas.png) / [diff](diff/workspace.canvas.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| workspace.slide-master | WorkspaceRegion | mismatch | app-owned-titlebar-raster | 8.25 % | 6.07 | 1 | n/a | [WPF full](wpf/full/workspace.slide-master.png) / [Avalonia full](avalonia/full/workspace.slide-master.png) / [WPF client](wpf/client/workspace.slide-master.png) / [Avalonia client](avalonia/client/workspace.slide-master.png) / [diff](diff/workspace.slide-master.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| editor.rich-text-selection | RichEditorOverlay | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip, rich-editor-selection-pixel-threshold | 10.31 % | 7.74 | 4 | 21.86 % | [WPF full](wpf/full/editor.rich-text-selection.png) / [Avalonia full](avalonia/full/editor.rich-text-selection.png) / [WPF client](wpf/client/editor.rich-text-selection.png) / [Avalonia client](avalonia/client/editor.rich-text-selection.png) / [diff](diff/editor.rich-text-selection.png) / [selection diff](diff/editor.rich-text-selection.selection.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
|  | Detail |  |  |  |  |  |  | Rich-editor selection threshold failed: changed 21.86 % (max 20 %), mean channel delta 13.74 (max 18.00), perceptual hash distance 10 (max 18). |
| editor.rich-text-caret | RichEditorOverlay | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 10.36 % | 7.97 | 4 | n/a | [WPF full](wpf/full/editor.rich-text-caret.png) / [Avalonia full](avalonia/full/editor.rich-text-caret.png) / [WPF client](wpf/client/editor.rich-text-caret.png) / [Avalonia client](avalonia/client/editor.rich-text-caret.png) / [diff](diff/editor.rich-text-caret.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| review.comments-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 13.43 % | 10.20 | 6 | n/a | [WPF full](wpf/full/review.comments-pane.png) / [Avalonia full](avalonia/full/review.comments-pane.png) / [WPF client](wpf/client/review.comments-pane.png) / [Avalonia client](avalonia/client/review.comments-pane.png) / [diff](diff/review.comments-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| review.accessibility-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster | 11.26 % | 8.92 | 5 | n/a | [WPF full](wpf/full/review.accessibility-pane.png) / [Avalonia full](avalonia/full/review.accessibility-pane.png) / [WPF client](wpf/client/review.accessibility-pane.png) / [Avalonia client](avalonia/client/review.accessibility-pane.png) / [diff](diff/review.accessibility-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| review.alt-text-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 11.23 % | 8.77 | 7 | n/a | [WPF full](wpf/full/review.alt-text-pane.png) / [Avalonia full](avalonia/full/review.alt-text-pane.png) / [WPF client](wpf/client/review.alt-text-pane.png) / [Avalonia client](avalonia/client/review.alt-text-pane.png) / [diff](diff/review.alt-text-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| review.reading-order-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 11.84 % | 9.57 | 4 | n/a | [WPF full](wpf/full/review.reading-order-pane.png) / [Avalonia full](avalonia/full/review.reading-order-pane.png) / [WPF client](wpf/client/review.reading-order-pane.png) / [Avalonia client](avalonia/client/review.reading-order-pane.png) / [diff](diff/review.reading-order-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| review.proofing-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 10.16 % | 7.80 | 4 | n/a | [WPF full](wpf/full/review.proofing-pane.png) / [Avalonia full](avalonia/full/review.proofing-pane.png) / [WPF client](wpf/client/review.proofing-pane.png) / [Avalonia client](avalonia/client/review.proofing-pane.png) / [diff](diff/review.proofing-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| accessibility.media-caption-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster | 12.29 % | 10.03 | 3 | n/a | [WPF full](wpf/full/accessibility.media-caption-pane.png) / [Avalonia full](avalonia/full/accessibility.media-caption-pane.png) / [WPF client](wpf/client/accessibility.media-caption-pane.png) / [Avalonia client](avalonia/client/accessibility.media-caption-pane.png) / [diff](diff/accessibility.media-caption-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
| context.smartart-text-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 13.14 % | 10.17 | 3 | n/a | [WPF full](wpf/full/context.smartart-text-pane.png) / [Avalonia full](avalonia/full/context.smartart-text-pane.png) / [WPF client](wpf/client/context.smartart-text-pane.png) / [Avalonia client](avalonia/client/context.smartart-text-pane.png) / [diff](diff/context.smartart-text-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
| animations.animation-pane | AuxiliaryPane | mismatch | app-owned-titlebar-raster, contextual-tab-strip, ribbon-tab-strip | 10.17 % | 7.69 | 7 | n/a | [WPF full](wpf/full/animations.animation-pane.png) / [Avalonia full](avalonia/full/animations.animation-pane.png) / [WPF client](wpf/client/animations.animation-pane.png) / [Avalonia client](avalonia/client/animations.animation-pane.png) / [diff](diff/animations.animation-pane.png) |
|  | Detail |  |  |  |  |  |  | WPF titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.2%). |
|  | Detail |  |  |  |  |  |  | Avalonia titlebar accent is not visibly present in its declared raster bounds (accent ratio 0.1%). |
|  | Detail |  |  |  |  |  |  | Visible ribbon tab order differs between hosts. |
|  | Detail |  |  |  |  |  |  | Visible contextual ribbon tabs differ between hosts. |
