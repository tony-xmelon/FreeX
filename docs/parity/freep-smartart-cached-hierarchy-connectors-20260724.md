# FreeP SmartArt Cached Hierarchy Connectors

## Change

PowerPoint's cached `hierarchy3` SmartArt drawing stores connector segments as
empty `dsp:sp` shapes with authored custom geometry, line styling, and omitted
`a:path/@w`/`@h`. FreeP previously lost the custom path when cloning fallback
shapes for composition and therefore rendered connector bounding boxes or
collapsed branches.

The reader now infers omitted custom-path extents from the authored points and
classifies geometry-less, textless cached shapes as line segments. `SlideCloner`
now preserves custom geometry paths and segments. The change is limited to the
cached SmartArt fallback path; normal slide shapes and live SmartArt layouts are
unchanged.

## Fresh PowerPoint Comparison

All captures used the current Release RenderCompare artifact, fresh PowerPoint
COM export, and 1280x720 output.

`14-smartart-live.pptx` WPF before/after mean RGB delta:

| Slide | Before | After |
| --- | ---: | ---: |
| 1 | 1.3477% | 1.3477% |
| 2 hierarchy | 1.2514% | 1.2114% |
| 3 | 0.4024% | 0.4024% |
| 4 | 1.3412% | 1.3412% |
| Average | 1.0857% | 1.0757% |

Avalonia remained stable across the sequence: average `1.0818% -> 1.0817%`
and hierarchy slide 2 `1.0680% -> 1.0676%`.

The simple `09-smartart.pptx` control stayed at WPF `0.4074%` and Avalonia
`0.2750%`. The remaining residual is primarily typography and broader cached
SmartArt geometry, not the previously visible connector-box artifact.

## Verification

- `Reader_SmartArt_HierarchyCachedConnectorSegmentsUseLineGeometry`: 1/1 compile run
- Same focused test with `--no-build`: 1/1
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors
- Fresh `14-smartart-live.pptx` WPF/Avalonia/PowerPoint comparison: 4/4 slides
- Fresh `09-smartart.pptx` WPF/Avalonia/PowerPoint comparison: 1/1 slide
