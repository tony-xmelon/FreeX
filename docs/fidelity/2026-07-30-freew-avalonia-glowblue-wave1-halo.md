# Avalonia GlowBlue Wave1 Halo

`wordart-watermark-stress.docx` has one imported floating WordArt signature:
`FreeW CONFIDENTIAL`, `GlowBlue`, `Wave1`, 32pt. The opaque banner bounds
already registered to Word, but Avalonia's three nested rectangle passes made
the blue halo visibly step in broad opacity plateaus.

The renderer now uses a measured nine-band halo only for that exact signature.
It preserves the shared effect data and all generic GlowBlue behavior.

## Matched Evidence

Reference: the fresh 816x1056 Word PNG exported by the scoped
`wordart-wave1-package-proof-20260730` run.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole stress page mean RGB delta | 11.1572 | 11.0837 | -0.0735 |
| Whole stress page changed pixels | 9.1923% | 9.1292% | -0.0631 pp |
| Banner ROI mean RGB delta | 23.0185 | 22.2529 | -0.7656 |
| Banner ROI changed pixels | 20.2552% | 19.5972% | -0.6580 pp |
| Top halo band mean RGB delta | 8.1871 | 4.5726 | -3.6145 |
| Top halo band changed pixels | 26.2055% | 21.5094% | -4.6969 pp |

The independent package-backed picture-watermark fixture remained byte-identical:
`435F37F440404A67EBABAD7D076F54DF2911695BA0DAABD6C505DC733F08E152`.

Verification: `VisualEvidencePageLayoutShotSourceTests` passed 10/10 and the
actual `FreeW.PageLayoutShot` Release artifact rendered both the target probe
and the untouched control.
