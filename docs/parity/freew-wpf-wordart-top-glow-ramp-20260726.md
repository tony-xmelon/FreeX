# WPF WordArt Top Glow Ramp Parity

## Scope

The imported `FreeW CONFIDENTIAL` GlowBlue/Wave1 WordArt in
`wordart-watermark-stress.docx` has a blue outer glow with a soft upper edge.
The WPF compositor previously painted the active source-colored outer ring at a
uniform alpha. Only this exact imported signature now uses a short vertical
alpha ramp at the top of that ring; its side and lower-edge alpha remain
unchanged.

## Reference

The authoritative Word reference was manually saved from the exact fixture and
rasterized at 816x1056:

- DOCX SHA-256: `08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`
- PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender` comparison against that PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9596% | **4.9490%** |
| Primary WordArt ROI | 7.4967% | **7.4577%** |
| Banner ROI | 7.7087% | **7.5461%** |
| Top glow band | 6.2817% | **5.0405%** |
| Independent Review Copy control | 4.1009% | 4.1009% |

The source guard requires the exact text, `GlowBlue` style, `Wave1` warp, and
32pt imported size. Other WordArt effects retain their existing compositor
paths.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~FloatingOverlay_UsesOuterOnlyGlowLayerForImportedWave1Signature`: 1/1 passed.
