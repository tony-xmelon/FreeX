# FreeW imported picture shadow alpha

## Scope

FreeW retained picture `a:outerShdw` alpha in `ShapeEffectLst.ShadowAlpha`, but both visual
hosts replaced it with the selected preset's opacity. Imported alpha therefore round-tripped in
the package without affecting the rendered document.

## Change

- The shared picture-effect planner now resolves imported shadow alpha on the DrawingML
  0..100000 scale.
- WPF consumes the result through `DropShadowEffect.Opacity`.
- Avalonia consumes the same value in fixed-size and expanded shadow rasters.
- Preset-only shadows retain their existing per-preset opacity.
- Imported shadow and glow colors without an `a:alpha` transform now default to fully opaque,
  as required by DrawingML, instead of inheriting FreeW's authored-preset defaults.

Blur, distance, direction, and color remain on their existing render paths in this slice.

## Verification

- `PictureEffectVisualPlannerTests`: 12/12 focused planner cases
- `FloatingImageRenderTests`: imported 0%, 25%, 100%, and preset fallback WPF contract
- `PictureCoreCommandParityTests`: imported alpha ordering and pixel-identical preset fallback
- `ImageEffectsRoundTripTests`: missing-alpha DOCX package defaults to 100000 for shadow and glow

This is package/render-semantic evidence. No Word visual ROI is claimed.
