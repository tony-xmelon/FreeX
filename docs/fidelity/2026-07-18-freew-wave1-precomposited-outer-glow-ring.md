# Wave1 Precomposited Outer Glow Ring

## Scope

The imported `wordart-watermark-stress.docx` primary WordArt is a `GlowBlue`,
`Wave1`, 32-point floating object. Word renders its `#2E75B6` 60% glow outside
the opaque `#242424` panel. WPF's `DropShadowEffect` remains clipped in the
floating overlay route, so the renderer emitted no blue halo even though the
effect object was present.

The WPF-only path now places a precomposited four-DIP `#2E75B6` / 60% outer
ring behind the existing effect and opaque fill layers for that exact imported
signature. The shared model and effect plan remain unchanged.

## Matching Word COM Evidence

All images are 816 x 1056 and use the persistent Word COM PNG baseline.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Full page | 7.8427% | 7.8113% | -0.0314 pp |
| Blue halo `(315,220)-(805,305)` | 24.2429% | 23.5922% | -0.6507 pp |
| Panel `(320,225)-(800,300)` | 25.1553% | 24.4025% | -0.7528 pp |
| Gold ArchUp control | 10.0475% | 10.0475% | 0.0000 pp |

The independent `wordart-picture-watermark-layout.docx` control is byte-stable:
`98D465EE4F3A6C93A71CD2D5A25A9B64FFCA610A0656D7E25C163DD1CB481496`.

## Verification

- Focused WPF WordArt tests pass compiled and with `--no-build`.
- `FreeW.FidelityRender` Release build completes with zero warnings and errors.
- The target and independent control were freshly rendered after rebuilding the
  dependent FidelityRender artifact.
