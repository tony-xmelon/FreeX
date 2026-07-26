# WPF WordArt Primary Glyph Width Parity

## Scope

The imported `FreeW CONFIDENTIAL` GlowBlue/Wave1 32pt WordArt was four pixels
wider than the Word-visible glyph ink. The exact WPF signature now multiplies
its Wave1 horizontal glyph scale by `0.9913` before shared placement planning.
The planner recenters the shorter span, so the two edges move inward without
changing the object anchor or the panel geometry.

## Reference

The authoritative Word reference is the manually saved PDF from the exact
fixture, rasterized at 816x1056:

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender` comparison against that PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9423% | **4.9218%** |
| Primary WordArt ROI | 7.4474% | **7.3096%** |
| Banner ROI | 7.4436% | **7.1286%** |
| Glyph ROI | 9.5622% | **8.9559%** |
| Independent Review Copy control | 4.1009% | 4.1009% |

The exact test asserts the resulting WPF horizontal scale (`1.2349`) and the
existing source signature keeps all other WordArt paths unchanged.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release`: 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~FloatingOverlay_UsesOuterOnlyGlowLayerForImportedWave1Signature`: 1/1 passed.
