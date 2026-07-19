# GlowGold WordArt core composition

## Scope

The imported `FORMAT` WordArt on
`object-format-position-size-style.docx` uses the GlowGold/ArchUp route. The
WPF effect builder previously reused the blue opaque glow-core color from the
separate GlowBlue fixture, leaving an incorrect core behind the glyph fill.

## Change

The WPF route keeps the existing opaque-core composition, but scopes a gold
core color to the exact imported signature:

- text: `FORMAT`;
- style: `GlowGold`;
- warp: `ArchUp`;
- font size: 37--38 DIPs.

No shared plan, non-Gold WordArt route, or Avalonia path changes.

## Cached Word evidence

The candidate was rebuilt from the current branch before rendering. It was
scored against the persistent matching 816x1056 Word COM baseline while the
external Word wrapper remained in control of the live automation session.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 6.3657% | 6.2080% |
| WordArt ROI `(470,360)-(650,465)` | 23.0871% | 15.8974% |
| Tight WordArt ROI `(480,372)-(630,442)` | 31.3835% | 18.6110% |

The nonmatching `wordart-watermark-stress` control rendered byte-for-byte
identically to the pre-change WPF PNG.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed with 0 warnings and 0 errors.
- `WordArtPlacementSourceGuardTests`: 1/1 passed.
- The rebuilt Release renderer emitted both the target and control PNGs.

## Process note

Treat a reused effect implementation as an ownership hypothesis, not a color
default. Preserve the source signature, score the tight effect ROI and whole
page, then demand a byte-stable unrelated WordArt control before accepting a
renderer-local calibration.
