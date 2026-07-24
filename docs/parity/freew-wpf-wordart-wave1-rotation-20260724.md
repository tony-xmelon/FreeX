# WPF WordArt Wave1 rotation parity

## Scope

The primary imported `FreeW CONFIDENTIAL` `GlowBlue` / `Wave1` / 32pt WordArt
in `wordart-watermark-stress.docx` used the generic Wave1 per-glyph rotation
amplitude after its existing inverse-phase correction. Word's manually exported
raster has materially more upright glyphs, while preserving the established
panel, glow, and vertical-wave geometry.

The WPF-only exact-source route now applies 40% of the inverse generic glyph
rotation. The shared planner, Avalonia, envelope, fill, and unrelated WordArt
routes remain unchanged.

## Evidence

The source DOCX SHA-256 is `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`.
The manually saved Word PDF/PNG reference is 816x1056 with PNG SHA-256
`FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`.

Fresh Release composite scoring against that reference:

| Candidate | Whole page | Primary ROI | Panel ROI | Review Copy control |
| --- | ---: | ---: | ---: | ---: |
| Current 1.35 rotation amplitude | 4.9826% | 8.6920% | 10.1464% | 5.4125% |
| 1.0 | 4.9699% | 8.4727% | 9.8034% | 5.4125% |
| 0.8 | 4.9650% | 8.3892% | 9.6728% | 5.4125% |
| 0.6 | 4.9620% | 8.3376% | 9.5921% | 5.4125% |
| **0.4 accepted** | **4.9606%** | **8.3140%** | **9.5551%** | **5.4125%** |
| 0.0 rejected | 4.9632% | 8.3586% | 9.6250% | 5.4125% |

The candidate is accepted because the exact target and whole-page metrics improve
while the independent secondary WordArt control remains unchanged.
