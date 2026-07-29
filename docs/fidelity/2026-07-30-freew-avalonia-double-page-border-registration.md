# Avalonia Double Page-Border Registration

## Scope

Imported Word page borders with `w:pgBorders/@w:offsetFrom="page"`, a 24-point border space,
and `w:val="double"` were close but visibly misregistered in the Avalonia page compositor.

## Change

Keep the serialized 24-point inset unchanged and move the Avalonia paint rectangle from
`inset + 1` to `inset + 1.5` DIPs. This is local to the page-border renderer and affects no
document content, page geometry, watermark, or text-layout path.

## Evidence

Persistent Word PDF-raster references at 816x1056, compared with a freshly rebuilt
`FreeW.PageLayoutShot` Release artifact:

| Fixture | Whole page before | Whole page after | Border region before | Border region after |
| --- | ---: | ---: | ---: | ---: |
| `wordart-watermark-stress` | 4.8679% | 4.5911% | 5.2782% | 4.9757% |
| `wordart-picture-watermark-layout` | 6.7258% | 6.1642% | 7.3201% | 6.7063% |

Exact `#1F4E79` mask inspection shows the outer Word rail is three opaque pixels wide and the
inner rail begins one pixel farther inward than the previous Avalonia raster. The 1.5-DIP offset
matches both rails without changing the serialized border-space contract.

The four-page `field-page-number-variants` fixture has no page border; all four candidate PNG
SHA-256 hashes remained byte-identical to the pre-change renders.

## Verification

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~PageBorder"`
- `dotnet build freew\\tools\\FreeW.PageLayoutShot\\FreeW.PageLayoutShot.csproj --configuration Release`
