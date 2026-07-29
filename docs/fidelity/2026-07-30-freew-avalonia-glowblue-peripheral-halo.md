# Avalonia GlowBlue Peripheral Halo

## Scope

The imported `FreeW CONFIDENTIAL` WordArt banner in
`wordart-watermark-stress.docx` has the exact visual signature `GlowBlue` +
`Wave1` at 32 pt. Its serialized glow is 10.67 DIPs at 60% opacity. Avalonia's
two existing rectangular passes left Word's outer blue halo too abrupt and too
short around the banner.

The renderer now adds one peripheral pass at 75% of the authored radius and
12% of the authored opacity. The existing nearer passes remain unchanged, and
the condition is limited to the imported banner signature.

## Evidence

The manual Word PDF-raster target and fresh Avalonia PageLayoutShot capture are
both 816x1056.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.5145% | 4.4915% | -0.0230 pp |
| Banner `(315,220)-(810,310)` | 16.3129% | 15.8725% | -0.4404 pp |
| Broad outer halo `(310,215)-(810,315)` | 14.6122% | 14.2171% | -0.3951 pp |
| Opaque face `(320,225)-(800,300)` | 18.1044% | 17.9218% | -0.1826 pp |
| Independent Review Copy ROI | 2.8236% | 2.8236% | 0.0000 pp |

The independent `wordart-picture-watermark-layout` control was rendered from
both the no-candidate and final candidate Release artifacts. Its SHA-256 was
byte-identical in both captures:
`435F37F440404A67EBABAD7D076F54DF2911695BA0DAABD6C505DC733F08E152`.

## Verification

- Release `FreeW.PageLayoutShot` build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 9/9.
- Fresh PageLayoutShot candidate captures against the matching Word PDF-raster
  references.
