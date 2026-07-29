# Avalonia GlowBlue Wave1 Phase

## Scope

Imported `wordart-watermark-stress.docx` contains one exact GlowBlue / Wave1
WordArt signature: `FreeW CONFIDENTIAL`, 32pt, rendered above the black banner.
The reference is the validated package-backed 816x1056 Word PNG.

## Finding

Avalonia used the shared Wave1 placement directly. The paired WPF renderer
already had evidence for the imported DrawingML object's inverse wave phase and
damped per-glyph rotation, but transferring its font scale also transferred a
WPF-specific glyph raster assumption and regressed Avalonia.

## Correction

Avalonia now applies only the measured geometric part of that exact signature:

- invert and amplify the Wave1 vertical phase by `1.35`;
- reverse and damp glyph rotation by `0.4`;
- retain Avalonia's existing font size, width fit, and effect/raster paths.

No generic Wave1 or other WordArt preset changes.

## Matched Evidence

Fresh rebuilt Avalonia PageLayoutShot against the same Word PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.4915% | 4.3790% |
| GlowBlue banner | 12.8977% | 11.2220% |
| Body | 7.3546% | 7.0377% |
| Independent Review Copy | 2.8960% | 2.8960% |

The package-backed `wordart-picture-watermark-layout` control remained
byte-identical (`435F37F440404A67EBABAD7D076F54DF2911695BA0DAABD6C505DC733F08E152`).

## Verification

- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 10 passed, 0 failed.
