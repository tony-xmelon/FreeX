# FreeW imported picture glow alpha

## Scope

DrawingML picture glow opacity is serialized as `a:glow/*/a:alpha` on a 0..100000 scale.
FreeW already retained that value in `ShapeEffectLst.GlowAlpha`, but WPF and Avalonia both
rendered every picture glow at a fixed 60% opacity.

## Change

- Added a renderer-neutral glow-opacity plan.
- Imported glows use their authored alpha, clamped to the DrawingML range.
- FreeW picture-format preset glows without an imported glow payload retain the existing 60%
  fallback.
- WPF consumes the plan through `DropShadowEffect.Opacity`.
- Avalonia consumes the same plan in both fixed-size and expanded-raster halo paths, including
  the bitmap path used by PDF export.

An authored zero-alpha glow remains invisible rather than falling back to a visible preset.

## Verification

- `PictureEffectVisualPlannerTests`: 6/6
- `FloatingImageRenderTests`: 22/22
- `PictureCoreCommandParityTests`: 35/35
- `ImageEffectsRoundTripTests`: 23/23

The Avalonia control asserts that a preset glow is pixel-identical to an imported 60000-alpha
glow, preserving the prior fallback raster. This is a package/render-semantic parity slice; no
Word visual ROI is claimed because the change is fully determined by the authored alpha payload.
