# FreeP hidden-slide slideshow route parity

## Scope

PowerPoint stores a hidden slide as `p:sld/@show="0"`. FreeP already preserved that state in
`Slide.IsHidden` and through PPTX read/write, but the normal full-presentation slideshow route
previously copied every slide into playback.

## Change

`SlideShowCustomShowPlanner.BuildFullPresentationRoute` now excludes hidden slides and keeps the
original source-slide indices for navigation and ink/timing bookkeeping. Starting from a hidden
slide advances to the next visible slide. Explicit custom-show slide IDs remain authoritative, so
a custom show can still name a hidden slide intentionally.

## Verification

- `SlideShowCustomShowPlannerTests`: 21/21 passing after adding full-route filtering and explicit
  custom-show coverage.
- The broader `FreeP.App.Presentation.Tests` run reached 2213/2215; the two failures were
  pre-existing unrelated contracts for SmartArt connector color and the file-dialog print export
  descriptor.

This is a functional slideshow parity fix; it does not change slide rasterization.
