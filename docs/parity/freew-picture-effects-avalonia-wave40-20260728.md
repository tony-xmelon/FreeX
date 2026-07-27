# FreeW Avalonia Picture Effects: Wave 40

Date: 2026-07-28

## Scope

This wave closes the remaining bounded picture-effects rendering gap between the FreeW WPF host and the FreeW Avalonia host. WPF remains the authority for effect availability, precedence, preset values, and reflection layout.

## Implemented

- Avalonia now renders all fourteen WPF artistic effects into a premultiplied BGRA raster: Blur, Glow Diffused, Glow Edges, Pencil Grayscale, Pencil Sketch, Line Drawing, Paintbrush, Paint Strokes, Photocopy, Posterize, Pastels, Watercolor, Film Grain, and Mosaic.
- Avalonia now renders the WPF effect precedence chain: Shadow, then Glow, then Soft Edge, then Bevel. Shadow and glow use alpha halos, soft edge uses a raster blur, and bevel uses alpha-edge highlight and shade passes.
- Shadow presets 1 through 5 use the WPF blur, distance, and opacity values. Glow uses the model color and size. Soft Edge and Bevel use the model values and WPF point-to-pixel scaling.
- Reflection presets 1 through 5 are composed for both floating and inline images. Inline layout reserves the reflection height so the reflected raster does not overlap following content.
- The existing decoded-image cache now owns the effect output and releases intermediate bitmaps when a new effect stage is applied. Existing model-change invalidation therefore rebuilds the rendered result after commands and undo.

## Verification

- Avalonia `PictureCoreCommandParityTests`: 30 passed, 0 failed, 0 skipped. This includes deterministic raster assertions for all fourteen artistic effects and Shadow, Glow, Soft Edge, and Bevel, plus command/cache/undo coverage for shadow, reflection, glow, soft edge, bevel, and mosaic.
- Avalonia `DocumentViewFloatingImageTests`: 24 passed, 0 failed, 0 skipped. Reflection region coverage includes presets 1 through 5.
- WPF `ImageAdjustHelperTests`: 12 passed, 0 failed, 0 skipped.

## Residuals

- The Avalonia raster implementation is a platform-independent approximation of WPF compositor effects. WPF can expand an effect outside the source bitmap bounds and uses compositor-specific blur/fade kernels; Avalonia currently keeps the decoded bitmap dimensions and applies the effect inside those bounds.
- Reflection opacity masks and floating-image capture are aligned by preset and layout behavior, but exact anti-aliasing and gradient pixels remain renderer-dependent.
- A paired Windows/Linux screenshot pass in the Linux harness is still needed for final visual sign-off of these effects.
