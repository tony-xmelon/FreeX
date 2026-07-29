# FreeW Avalonia GlowBlue WordArt

## Reference and Scope

`wordart-watermark-stress.docx` was exported by a fresh, isolated Microsoft
Word COM instance and rasterized to `816x1056`. The direct Word baseline and
the Avalonia candidate were produced from the same fixture and current Release
artifact.

The imported primary WordArt payload is narrowly identified as:

- text: `FreeW CONFIDENTIAL`
- style: `GlowBlue`
- warp: `Wave1`
- font size: 32pt

Avalonia previously applied shadows to floating WordArt but did not paint the
source-authored glow. This slice adds the two measured blue outer passes only
for that exact source signature. WPF and all other Avalonia WordArt routes are
unchanged.

## Result

| Region | Baseline | Candidate |
| --- | ---: | ---: |
| Whole page | 5.8793% | 5.7947% |
| Primary banner `(300,210)-(810,320)` | 17.3885% | 16.0884% |
| Primary glyph crop `(325,232)-(790,295)` | 22.3639% | 22.3639% |
| `Review Copy` control `(430,350)-(690,440)` | 5.8672% | 5.8672% |

The halo-only improvement leaves the glyph surface and independent FillGold
WordArt control unchanged. Future work on the remaining primary glyph
difference must stay in the text-path/raster owner rather than changing this
glow calibration.

## Secondary FillGold Material Surface

The same direct Word reference showed that the exact secondary `Review Copy` /
`FillGold` / `ArchUp` / 26pt object had a held gold top band and a dark lower
material ramp. WPF already consumed that narrow material surface; Avalonia had
fallen through to the generic gradient. Avalonia now applies the same
three-stop material fill only for that exact signature.

| Region | Before material surface | With material surface |
| --- | ---: | ---: |
| Whole page | 5.7947% | 5.7471% |
| `Review Copy` ROI `(430,350)-(690,440)` | 5.8672% | 4.1150% |
| Primary banner control `(300,210)-(810,320)` | 16.0884% | 16.0884% |
| Green backing control `(150,270)-(400,360)` | 4.8292% | 4.8292% |

This is a source-specific material correction; it does not change the
secondary text-path or any other FillGold object.

## Verification

- `VisualEvidencePageLayoutShotSourceTests`: 5/5 passed.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- Fresh no-build scoped Avalonia capture emitted only
  `wordart-watermark-stress_p1.png`.
