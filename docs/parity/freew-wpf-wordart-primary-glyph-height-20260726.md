# WPF WordArt Primary Glyph Height Parity

## Scope

The imported `FreeW CONFIDENTIAL` GlowBlue/Wave1 32pt WordArt uses a
renderer-local vertical glyph scale after its shared Wave1 placement plan. Word
ink measured two pixels taller than the WPF glyph bands at the 816x1056 target
resolution. The exact imported signature now uses `1.78` instead of `1.72`;
all other WordArt text paths retain their existing scale.

## Reference

The Word-visible reference is the manually saved PDF from the exact fixture,
rasterized at 816x1056:

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender` comparison against that PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9490% | **4.9423%** |
| Primary WordArt ROI | 7.4577% | **7.4474%** |
| Banner ROI | 7.5461% | **7.4436%** |
| Glyph ROI | 9.5622% | **9.5622%** |
| Independent Review Copy control | 4.1009% | 4.1009% |

The exact white-mask bounding box stays quantized at this output resolution,
but the full banner and page gates improve while the unrelated WordArt control
is unchanged.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release`: 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~FloatingOverlay_UsesOuterOnlyGlowLayerForImportedWave1Signature`: 1/1 passed.
