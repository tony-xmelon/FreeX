# FreeW Avalonia live picture transforms and borders

## Scope

The live Avalonia `DocumentView` previously decoded and painted imported pictures without applying
`InlineImage.RotationAngle`, `FlipH`, `FlipV`, `BorderColorHex`, `BorderWidthPt`, or `BorderDash`.
The direct PDF path already handled these properties and was intentionally left unchanged.

The live renderer now uses one model-aware picture draw path for the adjusted/effect raster,
reflection, flip/rotation transform, and authored border. The source layout rectangle is unchanged.
Pictures without a transform or border retain the prior draw sequence and do not push a transform.

## Ownership audit

| Live context | Exact model owner carried to drawing |
| --- | --- |
| Inline body picture | Existing `_images.Model` `InlineImage` reference |
| Floating picture | Owning run's `InlineImage`, stored in `_floatingImages.Model` during collection |
| Header/footer picture | Existing `HfRenderItem.Image` `InlineImage` reference |
| Grouped picture | Exact group child `InlineImage`, stored in `FloatingGroupChildData.ImageModel` |

No requested live context required inference or index-based model guessing, so there are no excluded
contexts in this slice. Group ownership is captured while the group child object is directly available;
floating ownership is captured from the validated block/run snapshot during collection.

## Rendering contract

- Flip is composed before rotation around the authored picture rectangle center, matching the existing
  Avalonia drawing-object transform convention.
- Picture borders use the authored RGB color, a minimum `0.75 pt` width when a border is active, and
  DrawingML dash mappings for `dash`, `dot`, `dashDot`, `lgDash`, `lgDashDot`, and `lgDashDotDot`
  (including the supported `sys*` aliases).
- Existing adjusted/effect bitmap bounds and reflection geometry remain inputs to the same live draw;
  the composed picture transform affects those painted visuals without changing layout reservations.
- Neutral pictures keep identity geometry and do not gain a border.

## Evidence

`DocumentViewPictureRenderingTests` verifies the exact center-based matrix produced by both flips plus
90-degree rotation, neutral identity controls, authored point-to-DIP border width, RGB brush color,
every supported dash token, and the model-bearing call site for inline, floating, header/footer, and
grouped pictures.

The current Avalonia headless backend returns no compositor frame and no bytes from an offscreen
`RenderTargetBitmap`, so this slice makes no pixel-level visual claim. The tests fail loudly on the
deterministic geometry/pen/ownership contracts instead of treating missing pixel output as a skip.

Focused evidence command:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewPictureRenderingTests --logger "trx;LogFileName=picture-rendering-tests.trx"
```

Result: focused result recorded by the integration gate.

`BuildPdfContent`, `BuildPdfImage`, PDF tests, and existing PDF documentation were not edited.
