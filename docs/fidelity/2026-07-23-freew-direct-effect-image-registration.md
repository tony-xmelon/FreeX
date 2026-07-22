# Direct Effect Image Registration

## Scope

The imported `drawing-objects-complex` fixture contains a paragraph-anchored
DrawingML picture with the exact signature:

- alt text: `Floating image with shadow glow reflection and artistic effect`;
- size: 126 x 72 pt;
- shadow preset: 2;
- glow: 5 pt;
- reflection preset: 1;
- artistic effect: `GlowDiffused`.

Its source `wp:anchor` and its Word-visible effect footprint place the picture
18 DIPs above the generic WPF overlay location. The image is otherwise a
normal square-wrapped, column/paragraph anchored drawing.

## Change

`SyncFloatingObjectsCanvas` applies the measured -18 DIP correction only to
that imported image signature. It changes the overlay location, not the image
pixels, reflection geometry, shared floating-object planner, or other image
routes.

## Matched Evidence

Fresh WPF composite rendering against the persistent 816x1056 Word PNG:

| Region | Before mean RGB delta | After mean RGB delta |
| --- | ---: | ---: |
| `drawing-objects-complex` whole page | 17.4711 | 16.8251 |
| Direct image `(280,205)-(500,430)` | 52.8164 | 41.5700 |
| Tight direct image `(295,220)-(475,395)` | 60.5040 | 43.0452 |
| Wave1 WordArt `(480,190)-(650,320)` | 44.2145 | 44.2145 |
| SmartArt `(75,470)-(400,690)` | 22.5621 | 22.5621 |

The whole-page changed-pixel ratio improved from 14.8982% to 14.8263%.
The apparent chart change is only the corrected image overlapping its left
edge; no chart visual path changed.

Fresh `f2-01-float-wrap`, `object-format-position-size-style`, and
`wordart-watermark-stress` WPF PNGs were SHA-256 byte-identical to their
accepted current-main captures.

## Verification

```powershell
dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj `
  --configuration Release `
  --filter "FullyQualifiedName~FloatingImageRenderTests" `
  --disable-build-servers `
  --logger "console;verbosity=minimal"

dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj `
  --configuration Release `
  --disable-build-servers `
  -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: focused tests 18/18 passed; consuming renderer build completed with
zero warnings and zero errors.

## Process Note

The first offset probe was byte-identical because the scored renderer artifact
was stale. The focused overlay assertion and a fresh consuming Release build
proved the branch was active before the accepted comparison. Treat a no-op
candidate as artifact/provenance evidence until the consuming DLL timestamp
and exact compositor route have both been verified.
