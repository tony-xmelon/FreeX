# WPF Review Copy Material-Layer Height Parity

## Scope

The imported secondary `Review Copy` FillGold/ArchUp WordArt uses a dedicated
material layer behind its glyphs. Word's gold panel extended three pixels below
the WPF panel while their top edges aligned. The exact `Review Copy` signature
now gives that layer thirteen DIPs of extra height instead of ten; the glyph,
wrap, and primary GlowBlue paths are unchanged.

## Reference

The Word-visible reference is the manually saved PDF from the exact fixture,
rasterized at 816x1056:

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender` comparison against that PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9218% | **4.9204%** |
| Primary WordArt control | 7.3096% | **7.3074%** |
| Review Copy ROI | 4.1009% | **4.0495%** |
| Review text crop | 5.7652% | **3.9697%** |
| Gold panel crop | 7.7180% | **6.2314%** |

The rejected glyph-scale/position probe is deliberately not included: it
regressed the page and primary control, proving that the panel owns this local
residual.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~FloatingOverlay_ExtendsMaterialLayerForImportedReviewCopySignature`: 1/1 passed.
