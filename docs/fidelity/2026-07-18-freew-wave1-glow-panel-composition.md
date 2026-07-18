# Wave1 Glow Panel Composition

## Scope

The `drawing-objects-complex` fixture contains a floating `FreeW` WordArt
panel with the exact serialized signature:

- solid `#242424` panel fill;
- glow `#2E75B6` at 60% alpha and 8 DIP radius;
- `textWave1` transform;
- 30pt text in a 93pt by 48pt anchor.

The generic WPF `DropShadowEffect` draws that glow on both sides of the panel
edge. It reduced the opaque panel core and did not match Word's outward-only
composition.

## Change

The existing WPF outer-only glow composition now also applies to this exact
30pt `FreeW` GlowBlue/Wave1 source signature. It keeps the opaque fill surface
above the glow layers. The pre-existing 32pt imported GlowBlue signature and
the separate GlowGold ArchUp signature remain distinct paths.

## Matched Word Evidence

The candidate used the persistent Word PNG cache; no COM export was started.
Fresh Release composite output at 816x1056 showed:

| Fixture | Measurement | Before | After |
| --- | --- | ---: | ---: |
| `drawing-objects-complex` | Whole page | 7.6095% | 7.5984% |
| `drawing-objects-complex` | `FreeW` Wave1 ROI `(470,160)-(720,310)` | 19.7020% | 19.4470% |
| `wordart-watermark-stress` | Whole page, 32pt GlowBlue control | 7.7588% | 7.7588% |
| `object-format-position-size-style` | Whole page, GlowGold control | 6.1948% | 6.1948% |

Both controls are candidate-vs-baseline SHA-256 stable.

## Verification

The new exact-signature STA test and the pre-existing 32pt GlowBlue control
test passed from Release output. The fidelity renderer Release build completed
with zero warnings and zero errors.
