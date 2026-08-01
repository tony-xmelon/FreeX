# FreeW PDF shape and WordArt effects, Wave 90

## Scope

FreeW Avalonia's shared `DrawingObjectEffectsPlan` already fed the live WPF/Avalonia visual paths,
but direct PDF export only approximated WordArt shadow/glow with rectangular paint and omitted
shape effects plus soft edge, reflection, and bevel cues. This slice keeps the existing vector
geometry, text, group order, clip bounds, opacity, rotation, and flips intact while adding effect
layers around the same child draw operations.

## Shared representation

`PdfEffectGroup` is a real composable draw operation, not an effect metadata marker. It carries the
effect family, object bounds, opacity, radius, offsets, reflection direction/gap, and optional
highlight/shadow colors. Portable PDF emits recolored and translated silhouette passes; Skia uses
the same passes through its raster compositor. Because the operation wraps the original vector
children, effects work for ungrouped objects and recursively grouped shape/WordArt children.

The planner now carries the model's reflection start alpha/distance/direction and bevel width/
height into the shared plan. Shadow, glow, soft edge, reflection, and bevel are all emitted when
their model flags are present. WPF remains the authority for the shadow/glow values and the bevel
highlight cue; WPF's lightweight object path does not render a true soft-edge or reflection fade.

## Verification

```text
dotnet test tests/Free.Shared.Pdf.Tests/Free.Shared.Pdf.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~PortablePdfWriterTests|FullyQualifiedName~SkiaPdfWriterTests"
Passed: 55, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests"
Passed: 13, Failed: 0, Skipped: 0
```

## Residuals

Portable PDF has no native vector blur, so shadow/glow/soft-edge fall back to bounded repeated
silhouette passes. Skia uses the same portable-safe layer composition rather than a backend-only
filter, keeping the two writers visually aligned. Full Office reflection gradient/fade/skew and
true 3-D bevel/material geometry remain unsupported because the current shared effect plan exposes
only the model fields above; the exported PDF retains a visible reflection and bevel cue instead of
silently dropping those fields.
