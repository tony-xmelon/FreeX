# FreeW floating WordArt Wave1 envelope

## Scope

The generated `drawing-objects-complex.docx` fixture contains a floating
`FreeW` WordArt object with the exact `GlowBlue`, `Wave1`, 30-point signature.
Word uses a larger vertical glyph-placement envelope than WPF's generic Wave1
plan while retaining the same phase and tangent rotations.

WPF now doubles only that signature's vertical placement offsets. Shared
planner geometry, Avalonia, the `FreeW CONFIDENTIAL` stress path, and other
WordArt presets remain unchanged.

## Evidence

Mean absolute RGB difference against the matching 816x1056 Word PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 6.5875% | 6.5848% |
| WordArt ROI | 15.1871% | 15.0390% |
| Tight panel ROI | 14.8306% | 14.5933% |

The image, chart, SmartArt, and group ROIs were unchanged. The complete
`wordart-watermark-stress` and `object-format-position-size-style` control PNGs
remained SHA-256 byte-identical.

A bounded amplitude sweep rejected negative phase, zero amplitude, and 4x
amplitude. The measured 2x envelope outperformed 2.25x, 2.5x, 2.75x, and 3x.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~WordArtPlacementSourceGuardTests|FullyQualifiedName~FloatingOverlay_UsesOuterOnlyGlowLayerForImportedFreeW30PointWave1Signature" --logger "console;verbosity=minimal"` (2/2)
- Fresh Release composite renders for the target and both control fixtures
