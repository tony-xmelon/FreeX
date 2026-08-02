# FreeW imported picture shadow color

## Scope

Picture `a:outerShdw/a:srgbClr` was retained in `ShapeEffectLst.ShadowColorHex`, but WPF and
Avalonia picture renderers always painted black shadows.

## Change

- The shared picture-effect planner selects the imported shadow RGB only when an imported shadow
  payload owns the effect.
- WPF uses the resolved RGB in its existing `DropShadowEffect` path.
- Avalonia uses the same RGB in fixed-size and expanded shadow rasters.
- Preset-only shadows remain black.

Shadow geometry and compositor ordering are unchanged.

## Verification

- `PictureEffectVisualPlannerTests`: imported RGB and preset fallback contracts
- `FloatingImageRenderTests`: WPF `DropShadowEffect.Color` consumes imported `102030`
- `PictureCoreCommandParityTests`: expanded Avalonia halo contains red premultiplied pixels for
  imported `FF0000`, while visible preset halo pixels remain black

This is package/render-semantic evidence. No Word visual ROI is claimed.
