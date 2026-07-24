# Primary Wave1 Envelope Calibration

## Scope

The manual Word PDF target is the exact `wordart-watermark-stress.docx` fixture saved by the user on
2026-07-24. The affected object is the imported primary DrawingML shape with this exact signature:

- text: `FreeW CONFIDENTIAL`
- WordArt style: `GlowBlue`
- text warp: `textWave1`
- font size: 42.67 DIPs (32 pt)

The original WPF route flattened this signature and drew unscaled glyphs. Raw white-ink masks showed
that the target preserves the same horizontal letter positions, while applying an inverse Wave1 phase and
a 1.72x vertical glyph envelope.

## Change

WPF now applies the measured inverse Wave1 placement phase at 1.35x amplitude and a 1.72x vertical
glyph scale only for the exact imported signature. Generic Wave1, other WordArt styles, and Avalonia are
unchanged.

## Evidence

Fresh 816x1056 WPF composite renders were compared against the manually saved Word PDF raster:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.7963% | 6.6312% | -0.1651 pp |
| Primary WordArt panel `(300,220)-(810,305)` | 17.2469% | 13.9661% | -3.2808 pp |
| Primary glyphs `(323,230)-(797,296)` | 17.1250% | 12.5789% | -4.5461 pp |
| Review Copy control `(430,355)-(690,440)` | 4.3952% | 4.3952% | unchanged |

Candidate-versus-control changed 7,666 pixels, bounded to `(326,236)-(794,291)`; zero pixels changed
outside the primary banner `(300,220)-(810,305)`.

Focused `WordArtPlacementSourceGuardTests` passed 1/1 and the consuming `FreeW.FidelityRender` Release
build completed with zero warnings and errors.
