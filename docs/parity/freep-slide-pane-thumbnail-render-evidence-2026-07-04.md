# FreeP Slide Pane Thumbnail Render Evidence - 2026-07-04

## Scope

This slice advances the slide-pane thumbnail bitmap/comparison evidence path without changing the already-merged thumbnail chrome or section-header chrome.

## Improvement

- `tools/FreeP.RenderCompare --slide-pane-thumbnail-compare <deck.pptx> <outDir>` now creates a slide-pane thumbnail evidence plan with WPF, Avalonia, PowerPoint, and diff artifact directories.
- The mode renders WPF and Avalonia thumbnail bitmaps at a deterministic 320x180 comparison size while recording the actual shared slide-pane thumbnail target of 150x84.375 DIP.
- The mode attempts a PowerPoint COM export into the matching thumbnail baseline directory and reports PowerPoint rows as `n/a` when COM is unavailable, instead of treating missing baselines as visual parity.
- `--allow-missing-powerpoint` lets COM-unavailable machines use the mode for WPF/Avalonia thumbnail evidence loops: PowerPoint-backed rows stay `n/a`, WPF/Avalonia failures still fail the run, and PowerPoint export failures other than missing COM remain nonzero.
- The diff table now separates WPF-vs-Avalonia, WPF-vs-PowerPoint, and Avalonia-vs-PowerPoint rows so a COM-capable machine can immediately produce slide-pane thumbnail evidence.

## Focused Evidence

- `tools/FreeP.RenderCompare.Tests/SlidePaneThumbnailEvidenceTests.cs` pins the evidence plan dimensions, artifact routes, renderer/baseline file-set collection, and missing-PowerPoint exit-code policy.
- `tools/FreeP.RenderCompare/SlidePaneThumbnailEvidence.cs` keeps the comparison harness isolated from host chrome and section-header implementation.
- `tools/FreeP.RenderCompare/Program.cs` exposes the mode in CLI routing and usage text.

## Remaining Gaps

- PowerPoint-authoritative thumbnail bitmap baselines still require a machine with `PowerPoint.Application` COM registered.
- Foreground pointer screenshots, true pane chrome screenshots, section grouping polish, and broader PowerPoint-measured slide-pane visual baselines remain future work.
