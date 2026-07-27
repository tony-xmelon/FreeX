# FreeW Wave39: Avalonia Picture Adjust Route

## Concrete mismatch

The WPF authority registered the Picture Format adjustment routes for brightness,
contrast, saturation, transparency, recolor, and color tone. Avalonia exposed the
picture ribbon controls, but its command registry stopped at the dialog opener,
crop, border, reset, and picture-style routes. Clicking those WPF-equivalent menu
items therefore had no Avalonia command to execute. This was a production route
difference, not an evidence-only or feature-depth comparison.

## Implementation

- Registered the WPF adjustment, color, transparency, recolor, color-tone, picture-effect,
  and artistic-effect command IDs in `FreeWAvaloniaRibbonCommands`.
- Added selection-aware state and thin `DocumentView` methods that execute the existing
  shared undoable image commands from `FreeW.Core.Model`.
- Added an Avalonia framebuffer pixel pipeline for correction/color/recolor presets, using
  the same operation order and formulas as the WPF `ImageAdjustHelper`.
- Cleared the Avalonia decoded-image cache on load and model changes so adjustments are
  visible immediately and undo/redo cannot display a stale bitmap.

## Verification

- `PictureCoreCommandParityTests`: 8 passed.
- Existing WPF `ImageAdjustHelperTests` remain the authority coverage for the matching pixel
  pipeline and were not duplicated with a host-only route test.

## Residuals

The picture-effect and artistic-effect commands now mutate and undo through the shared model,
but Avalonia still needs dedicated rendering work for shadow, glow, soft edge, bevel, and the
artistic filters. Reflection preset 1 was already rendered by Avalonia; other reflection
variants remain outside this wave. The Color and Transparency dialog IDs use Avalonia's
existing shared adjustment-dialog callback because `RibbonHostCallbacks` currently exposes
one full adjustment dialog route.
