# WPF WordArt Glow Ring Compositor Parity

## Scope

`wordart-watermark-stress.docx` contains an imported `FreeW CONFIDENTIAL`
GlowBlue/Wave1 WordArt object. The FidelityRender composite previously fit the
complete canvas into its bounded object rectangle, clipping the authored outer
halo. The renderer now draws the existing outer-only halo border before that
unchanged canvas composite. The guard is the exact imported text, style, warp,
and 32pt size.

## Reference

The reference is the Word-visible PDF manually saved beside the exact fixture,
then rasterized at 816x1056:

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

## Matched Composite Evidence

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 5.1745% | 5.1157% |
| Primary WordArt ROI | 10.8935% | 10.0324% |
| Tight WordArt ROI | 13.4112% | 12.2621% |
| Glyph ROI | 12.8357% | 12.4271% |
| Wrapped body ROI | 10.3627% | 10.3120% |
| Independent Review Copy control | 4.1009% | 4.1009% |

The candidate increases detected blue halo pixels from 1108 to 3943 while the
reference comparison improves across every scored target region. The independent
gold WordArt control is unchanged.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- Focused source contract: 1/1 passed.
- A broader pre-existing host filter still has two unrelated current-main
  failures: a stale evidence-source literal and a Wave1 rotation expectation.
