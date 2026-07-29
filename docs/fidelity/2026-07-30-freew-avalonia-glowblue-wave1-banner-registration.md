# Avalonia GlowBlue Wave1 Banner Registration

## Scope

The imported native WordArt banner in `wordart-watermark-stress.docx` has the exact visual
signature `FreeW CONFIDENTIAL` + `GlowBlue` + `Wave1` at 32pt. Its opaque `#242424` face was
one pixel short on the left and top in Avalonia, while the right and bottom edges already matched
the Word PDF-raster reference.

## Change

Expand only that renderer-local visual-owner rectangle by one DIP toward the left and top,
preserving the original right/bottom extent. The source predicate excludes all other WordArt,
including the independent FillGold/ArchUp `Review Copy` object.

## Evidence

Persistent Word PDF-raster target and fresh `FreeW.PageLayoutShot` Release candidate at 816x1056:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.5911% | 4.5145% |
| GlowBlue/Wave1 banner `(315,220)-(810,310)` | 17.7947% | 16.3129% |
| Opaque face `(320,225)-(800,300)` | 19.7998% | 18.1044% |
| FillGold/ArchUp Review Copy | 3.2586% | 3.2586% |

The `wordart-picture-watermark-layout` control PNG SHA-256 is byte-identical before/after:
`FE1916130F4D151E89A9CA0A12EF2B058216366821E6C3D4745361331B193296`.

## Verification

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~WordArt"`
- `dotnet build freew\\tools\\FreeW.PageLayoutShot\\FreeW.PageLayoutShot.csproj --configuration Release`
