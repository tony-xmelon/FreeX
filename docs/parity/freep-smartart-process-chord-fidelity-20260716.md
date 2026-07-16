# FreeP SmartArt Process Chord Fidelity

Date: 2026-07-16

## Scope

The `14-smartart-live.pptx` corpus contains cached SmartArt process nodes using
DrawingML `a:prstGeom prst="chord"`. FreeP previously mapped the unsupported preset
to a rectangle, which made the dark process segments square. The preset adjustment
guides (`adj1` and `adj2`) were also lost when cached SmartArt shapes were cloned for
composition.

## Change

- Added a shared `DrawingShapeKind.Chord` geometry with clockwise elliptical arc and
  chord closure.
- Retained preset adjustment guides through PPTX read, clone, compose, write, and
  SmartArt cache regeneration paths.
- Added regression coverage for the shared geometry and the real SmartArt corpus.

## PowerPoint comparison

RenderCompare at 1280x720, four slides, using PowerPoint COM export as ground truth:

| Metric | Before | After |
| --- | ---: | ---: |
| Slide 1 WPF diff | 1.5707% | 1.2284% |
| Slide 1 Avalonia diff | 1.1840% | 1.1839% |
| Average WPF diff | 1.1239% | 1.0383% |
| Average Avalonia diff | 1.0956% | 1.0956% |
| Average Avalonia vs PowerPoint | 1.2355% | 1.1500% |

The remaining SmartArt differences are outside this slice, primarily layout-specific
connector geometry, color treatment, and other bounded approximations.
