# Avalonia Floating Drawing Fallback Text

Imported floating DrawingML objects carry a text fallback in their anchor run.
That fallback is source metadata for the overlay and must not become body text.
Avalonia incorrectly classified paragraphs containing floating text boxes and
WordArt as plain text, then flattened their fallback strings into the body
layout while also rendering the intended overlay.

The display-cell and editable-paragraph paths now skip only runs whose drawing
object is floating. The anchored shape, WordArt, chart, SmartArt, image, or
group continues through the existing floating-object collector and overlay
renderer. Inline content remains on its existing layout path.

Fresh matching Word-reference renders at 816x1056 improved both affected
fixtures:

| Fixture | Before | After | Change |
| --- | ---: | ---: | ---: |
| wordart-watermark-stress | 5.1569% | 5.0550% | -0.1019 pp |
| wordart-picture-watermark-layout | 6.7518% | 6.7258% | -0.0260 pp |

The body no longer contains the fallback strings while the intended floating
shape and WordArt overlays remain present. The no-floating-object
two-column control remained byte-identical.

Verification:

- dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewFloatingShapeTests (27/27)
- same focused test with --no-build (27/27)
- dotnet build freew\tools\FreeW.PageLayoutShot\FreeW.PageLayoutShot.csproj --configuration Release (0 warnings, 0 errors)
- fresh source-backed WordArt renders using the matching cached Word PNG corpus.
