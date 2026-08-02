# FreeP Wave107: Slide-Pane Thumbnail Alignment

Date: 2026-08-02
Authority: `freep/FreeP.App.Host/SlidePane.cs`
Scope: shared thumbnail content alignment consumed by WPF and Avalonia

## Residual closed

The WPF slide pane centers the slide-number label and thumbnail as one vertical
stack. Avalonia built the same children in a `StackPanel` that inherited stretch
alignment from its `ListBoxItem`. The shared thumbnail dimensions were correct,
but the outer thumbnail frame could therefore occupy the full item width and
render with different horizontal placement from WPF.

`SlidePanePlanner` now carries `CenterThumbnailContent`, with the default set to
the WPF behavior. Both hosts consume that policy in their thin visual adapters.
The change does not alter selection-before-drag, section state, thumbnail input
ownership, or the shared slide renderer.

## Verification

- Shared presentation planner: `53/53` passed (`SlidePanePlannerTests`).
- WPF host slide pane: `21/21` passed (`SlidePaneTests`).
- Avalonia slide-pane and source-guard lane: `16/16` passed.
- No Docker or build-server shutdown was run.

## Remaining

- PowerPoint-authoritative thumbnail bitmap baselines still require a
  COM-capable evidence machine.
- WPF and Avalonia still have renderer-specific raster/text differences in
  richer slide content; this slice only aligns pane placement/chrome.
- Foreground pointer screenshots and broader whole-window visual comparison
  remain future evidence work.
