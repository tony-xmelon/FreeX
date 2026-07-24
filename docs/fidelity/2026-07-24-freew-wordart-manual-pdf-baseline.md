# FreeW WordArt Manual Word PDF Baseline

## Reference

The visible Microsoft Word PDF for
`wordart-watermark-stress.docx` was saved manually on 2026-07-24 and
rasterized at 96 DPI to `816x1056` before comparison.

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- Candidate: current Release `FreeW.FidelityRender` WPF composite route.

This Word-visible reference has no diagonal `DRAFT` watermark. That is
consistent with the package, whose native VML text-path payload is
`CONFIDENTIAL`. The older cached Word PNG with a visible `DRAFT` watermark is
therefore not admissible for this exact fixture.

## Current WPF Comparison

Raw mean RGB deltas against the manual Word PDF raster:

| Region | Raw mean delta | Normalized delta |
| --- | ---: | ---: |
| Whole page | 17.3305 | 6.7963% |
| Primary GlowBlue/Wave1 panel | 28.1496 | 11.0391% |
| Primary glyph crop | 39.7210 | 15.5769% |
| FillGold/ArchUp `Review Copy` | 13.9107 | 5.4552% |
| Green backing TextBox | 25.0877 | 9.8383% |
| Body text region | 32.6254 | 12.7943% |

The recently accepted opaque-core and material-frame registrations remain
present in the new capture. The primary residual is the transformed glyph and
outer-effect rasterization, while the page-wide body-text difference is a
separate WPF text-raster path.

## Rejected Halo Probe

The exact imported `FreeW CONFIDENTIAL` / `GlowBlue` / `Wave1` / 32pt WPF
path was probed by changing only its outer-ring extent from 4 to 8 DIPs. After
rebuilding the consuming Release FidelityRender artifact, the candidate
regressed:

| Region | Baseline | 8-DIP candidate |
| --- | ---: | ---: |
| Whole page | 17.3305 | 17.5630 |
| Primary panel | 28.1496 | 30.1672 |
| Primary core | 45.8133 | 50.9766 |
| `Review Copy` control | 13.9107 | 13.9107 |

The top halo crop was byte-identical, which shows that the edited ring extent
does not own that visible edge on the composite path. The probe was reverted.
Future work should inspect the transformed text/effect composition rather than
broaden the ring or apply a generic glyph scale.

## Rejected Glyph Models

The source payload is explicit: Calibri 32pt, `textWave1`, and no additional
text-fit metadata. Word's glyph ink is taller than the WPF glyph ink, but that
raw bounding-box difference did not identify an affine owner. Two exact
signature probes were rejected against the same manual PDF:

| Model | Whole page | Primary panel | Primary glyph crop |
| --- | ---: | ---: | ---: |
| Baseline | 17.3305 | 28.1496 | 42.6430 |
| 1.5x baseline-centered vertical glyph transform | 17.3867 | 28.4186 | 44.1259 |
| 1.5x Calibri em size with existing horizontal frame fit | 18.0427 | 33.6774 | 61.4432 |

`Review Copy` was byte-stable for both probes. The residual is therefore a
WordArt text-path/effect rasterization model gap; do not retry a generic
vertical scale or font-size multiplier for this payload.

## Rejected Surface-Fit Probe

The raw PDF mask provides a useful geometry constraint but not an affine paint
model. The Word glyph ink is `(333,236)-(788,291)` while the current WPF path
is `(329,250)-(791,274)`. A WPF-only exact-signature probe reserved the
measured 10-DIP horizontal inset and applied a 2.24 vertical glyph scale around
each glyph centre. It moved the candidate ink bounds to `(339,236)-(782,292)`,
matching the target height, but it over-painted the glyph surface and regressed
all material metrics:

| Region | Baseline | Surface-fit candidate |
| --- | ---: | ---: |
| Whole page | 6.7963% | 7.0367% |
| Primary panel | 16.6362% | 21.3339% |
| Primary glyph crop | 19.1488% | 26.6038% |

`Review Copy` remained byte-stable. The probe was reverted. The target needs a
real WordArt text-path glyph/raster model, rather than a scaled WPF `TextBlock`
surface; use the mask bounds only to validate a future model that also matches
ink density and character outlines.
