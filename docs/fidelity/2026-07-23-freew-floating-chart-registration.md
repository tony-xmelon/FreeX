# Floating Chart Registration

## Scope

The imported `drawing-objects-complex` package contains one paragraph-anchored
column chart with the effective reader signature:

- title: `Quarterly revenue`;
- size: 210 x 126 pt;
- legend and both axis titles enabled (`Quarter`, `USD`);
- `TopAndBottom` wrapping;
- margin-relative horizontal offset 210 pt and paragraph-relative vertical
  offset 120 pt.

Although the serialized anchor labels the horizontal reference as `column`,
the current reader intentionally normalizes that reference to the model's
`Margin` anchor. The visual guard therefore follows the effective model route.

## Change

`SyncFloatingObjectsCanvas` applies a -15 DIP WPF overlay registration only to
that exact imported chart signature. The shared chart scene, legend plan, and
non-chart floating-object routes are unchanged.

## Matched Evidence

Fresh WPF composite rendering against the persistent 816x1056 Word PNG:

| Region | Before mean RGB delta | After mean RGB delta |
| --- | ---: | ---: |
| `drawing-objects-complex` whole page | 16.8251 | 16.4821 |
| Chart `(355,315)-(675,535)` | 26.6559 | 22.4579 |
| Tight chart `(375,335)-(660,520)` | 27.8986 | 22.2696 |
| Title `(390,335)-(640,380)` | 36.1328 | 29.7035 |
| Plot `(430,380)-(650,450)` | 29.9511 | 19.8834 |
| SmartArt `(75,470)-(400,690)` | 22.5621 | 22.5621 |

Whole-page changed pixels improved from 14.8263% to 14.6756%.

The chart legend is a separate internal layout owner and moved from 14.6432 to
15.1230 mean RGB delta. The bounded -14 DIP sweep was worse for whole page,
chart, title, and legend, so -15 DIP is retained; legend layout remains queued
for an independent correction rather than changing the accepted frame
registration.

Fresh `f2-01-float-wrap`, `object-format-position-size-style`, and
`wordart-watermark-stress` WPF PNGs were SHA-256 byte-identical to their
current-main captures.

## Verification

```powershell
dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj `
  --configuration Release `
  --filter "FullyQualifiedName~FloatingObjectRenderTests" `
  --disable-build-servers `
  --logger "console;verbosity=minimal"

dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj `
  --configuration Release `
  --disable-build-servers `
  -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

Result: focused tests 16/16 passed; the consuming renderer build completed
with zero warnings and zero errors.

## Process Note

A first source guard used `HorizontalAnchor.Column` and produced a byte-stable
render because the reader had already normalized `wp:positionH/@relativeFrom`
from `column` to `Margin`. Inspect effective rehydrated payload before scoring;
serialized source labels alone are not necessarily the active dispatch key.
