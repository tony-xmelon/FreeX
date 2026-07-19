# Wave1 Outer-Glow Composition

## Scope

The primary imported `textWave1` WordArt in `wordart-watermark-stress.docx`
has a dark `GlowBlue` panel and a DrawingML outer glow. WPF's zero-depth
`DropShadowEffect` blurred the panel inward as well as outward, shrinking the
opaque `#242424` core and making the panel materially different from Word.

## Change

The exact imported `GlowBlue` + `Wave1` + 32-point signature now composes a
blurred 2-DIP blue layer behind a second opaque fill layer in the WPF overlay.
The foreground glyph canvas remains on top. This keeps the Word-like opaque
panel while retaining a real outer glow. The shared placement planner,
Avalonia, other styles, and inline WordArt stay unchanged.

## Matched Word Evidence

All output is 816x1056 and uses the persisted Word COM target from
`FreeW-WordBaselineSurfaceRefresh-20260717`.

| Measurement | Before | After |
| --- | ---: | ---: |
| Full page WPF vs Word | 8.3042% | 7.8427% |
| Wave1 ROI `(315,215)-(805,310)` | 30.3788% | 21.8371% |
| Panel ROI `(320,225)-(805,300)` | 36.0469% | 25.1159% |

The generic one-layer WPF blur measured 10.67 DIPs from DrawingML, but its
inward bleed reduced the opaque core. A bounded two-layer sweep selected a
2-DIP outer-only WPF blur; 4 and 10.67 DIPs scored worse, while a zero-blur
probe was rejected because it removed the authored glow rather than modeling it.

## Controls And Verification

- `wordart-picture-watermark-layout` remains an independent ArchUp and
  DrawingML-picture control; it is required to stay SHA-256 stable.
- Wave1 and inline ArchUp host contracts cover 2/2 existing paths.
- The targeted outer-only glow composition contract asserts two panel layers,
  no root blur, and the glyph count.
- `FreeW.FidelityRender` Release build completed with 0 warnings and 0 errors.
