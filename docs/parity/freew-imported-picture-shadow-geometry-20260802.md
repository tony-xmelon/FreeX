# FreeW imported picture shadow geometry

## Scope

Imported picture shadows retained exact DrawingML `blurRad`, `dist`, and `dir`, but rendering
reduced them to the nearest FreeW shadow preset. Avalonia additionally used the same offset on both
axes for every picture shadow.

## Change

- Added a shared picture shadow visual plan containing blur, distance, direction, X/Y offsets,
  opacity, and color.
- Imported geometry uses the retained EMU and 1/60000-degree values.
- WPF consumes exact blur, depth, and direction through `DropShadowEffect`.
- Avalonia converts the DrawingML vector to signed X/Y offsets and expands the bitmap on the
  owning sides.
- Preset-only shadows retain their previous blur, equal X/Y raster offsets, WPF direction,
  opacity, and black color.
- Glow continues to use zero X/Y offset in both Avalonia raster paths.

## Verification

- `PictureEffectVisualPlannerTests`: 16/16, including exact imported 90-degree vector and preset
  geometry control
- `FloatingImageRenderTests`: 25/25; WPF consumes imported 6pt blur, 5pt depth, and 90 degrees
- `PictureCoreCommandParityTests`: 38/38; 0, 90, and 180-degree imported shadows expand on the
  expected sides while source dimensions remain stable

This is source-semantic and host-consumption evidence. No Word visual ROI is claimed.
