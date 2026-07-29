# Avalonia WordArt Gradient Direction

## Source Authority

The serialized `wordart-picture-watermark-layout.docx` contains its in-front
`WATERMARK` WordArt as DrawingML `a:gradFill` with the following payload:

- stops: `#FF6000` at 0, `#C00000` at 50000, `#7030A0` at 100000;
- `a:lin/@ang=5400000`, meaning a top-to-bottom gradient.

`DrawingObjectVisualPlanner` preserves this in `DrawingObjectFillPlan`.
Avalonia's WordArt consumer ignored the plan angle and hard-coded a diagonal
brush, despite its ordinary shape brush already honoring DrawingML angles.

## Correction

`BuildWordArtGradientBrush` now converts the serialized 60k-degree angle to
relative midpoint-centered brush endpoints. This is a renderer-local consumer
fix; the model, package payload, shared visual plan, and WPF path are unchanged.

## Word Evidence

The Word target is the fresh 816x1056 COM PDF export used for the preceding
serialized-fixture capture. After rebuilding the actual `FreeW.PageLayoutShot`
Release consumer and rendering the same DOCX:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page mean channel delta | 23.9463 | 23.2698 |
| `WATERMARK` WordArt ROI `(360,280)-(630,375)` mean channel delta | not isolated | 23.0688 |

The candidate's fill now follows the Word top-to-bottom orange, red, then purple
direction instead of the prior diagonal interpolation.

## Controls And Verification

- `wordart-watermark-stress` Avalonia PNG is SHA-256 byte-identical.
- All four `field-page-number-variants` Avalonia PNGs are SHA-256 byte-identical.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 7 passed after rebuild and 7 passed
  with `--no-build`.
