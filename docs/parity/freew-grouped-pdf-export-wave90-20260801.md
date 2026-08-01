# FreeW grouped PDF export, Wave 90

## Scope

FreeW Avalonia direct PDF export previously admitted only top-level floating images and shapes to
the shared `PdfContentDocument` adapter. A `DrawingGroup` therefore remained visible in the live
Avalonia surface but contributed no PDF draw operations. The WPF path was audited as the reference:
its paginator rasterizes `BuildFloatingGroupVisual`, which already consumes the shared recursive
`DrawingObjectVisualPlan` and composes child offsets, child order, and nested transforms.

## Change

- Avalonia PDF export now consumes the shared recursive group visual plan for every supported
  drawing child: images, shapes, charts, SmartArt, and WordArt.
- Group children are emitted in model list order, preserving z-order, with shape geometry, text,
  solid/gradient/pattern fills, outlines, custom paths, child rotation, and child flips retained.
- Chart scene primitives, SmartArt layout geometry/connectors/nodes, and WordArt text/style/effect
  plans use the same ungrouped PDF builders at group-resolved page geometry, so nested children do
  not take a host-specific or raster-only detour.
- Each group is represented by a shared `PdfClipGroup` for local bounds and a nested
  `PdfRotationGroup` when the group has rotation or flips. This keeps nested transforms explicit for
  both the portable and Skia PDF writers instead of flattening them in the Avalonia adapter.
- Shared portable and Skia writers now recurse through clip groups and restore their graphics state.

## Proof

Focused commands run from this worktree:

```text
dotnet test tests/Free.Shared.Pdf.Tests/Free.Shared.Pdf.Tests.csproj --configuration Release --filter "FullyQualifiedName~PortablePdfWriterTests|FullyQualifiedName~SkiaPdfWriterTests" --logger "console;verbosity=minimal"
Passed: 53, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~DocumentViewPdfExportTests" --logger "console;verbosity=minimal"
Passed: 12, Failed: 0, Skipped: 0
```

The Avalonia tests build an outer flipped/rotated group containing a rotated/flipped nested group,
pattern-filled and dashed-outline ellipse geometry, nested text, and a separately rotated/flipped
front text box. The continuation case adds a line chart, Process SmartArt, and Wave1 WordArt to the
nested group; it asserts chart lines/data text, SmartArt paths/node text, WordArt glyph text/effects,
the nested `PdfRotationGroup`/`PdfClipGroup` tree, and both Skia and portable PDF emission. The shared
tests assert portable clip-path syntax and Skia acceptance of a clip nested below a rotation group.

## Residuals

This slice covers grouped images, shapes, charts, SmartArt, and WordArt through the shared visual
plan and existing vector PDF vocabulary. WPF remains raster-backed and continues to preserve the
same children through its existing visual paginator path. The vector PDF output follows the live
scene plans; it is not a pixel-identical replacement for WPF's raster paginator.
