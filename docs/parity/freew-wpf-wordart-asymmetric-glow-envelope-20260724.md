# WPF WordArt Asymmetric Glow Envelope Parity

## Scope

The imported `FreeW CONFIDENTIAL` GlowBlue/Wave1 WordArt in
`wordart-watermark-stress.docx` has an asymmetric outer halo in Word. The
existing WPF ring was four DIPs on every edge. Word's exact blue mask instead
extends two DIPs farther horizontally and four DIPs farther only below the
panel.

The WPF overlay now applies a signature-scoped six-DIP horizontal extent,
retains the four-DIP top inset, and adds four DIPs only to the bottom. Other
GlowBlue and GlowGold paths retain their original four-DIP symmetric envelope.

## Reference

The Word-visible PDF was manually saved beside the exact fixture and rasterized
at 816x1056. Its provenance is recorded in
`freew-wpf-wordart-glow-ring-compositor-20260724.md`.

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender` captures against that manual Word PNG used
the following mean absolute RGB channel deltas (lower is better):

| Region | Four-DIP baseline | Uniform six-DIP probe | Asymmetric envelope |
| --- | ---: | ---: | ---: |
| Whole page | 12.9771 | 12.8451 | **12.5735** |
| Primary WordArt ROI `(310,215)-(810,315)` | 28.0137 | 26.0099 | **22.1645** |
| Tight panel ROI `(325,230)-(795,295)` | 32.7821 | 29.3720 | **25.5198** |
| Review Copy control `(440,365)-(690,435)` | 13.8019 | 13.8019 | **13.8019** |

The exact blue-mask bounding box changed from WPF `(319,224)-(802,299)` to
`(317,224)-(804,303)`, matching Word exactly. The control crop has zero changed
pixels between the baseline and accepted candidate.

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~WordArtPlacementSourceGuardTests" --logger "console;verbosity=minimal"`: 1/1 passed.
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
