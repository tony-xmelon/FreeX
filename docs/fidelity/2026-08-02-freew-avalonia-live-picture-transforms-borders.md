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

`DocumentViewPictureRenderingTests` provides headless captures for inline, floating, header, and grouped
pictures using an asymmetric four-quadrant bitmap. It verifies both flips plus 90-degree rotation, the
unchanged identity controls in every host, authored red dash/gap pixels, exact point-to-DIP border width,
RGB brush color, and large-dash-dot contract values.

Focused evidence command:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewPictureRenderingTests --logger "trx;LogFileName=picture-rendering-tests.trx"
```

Result: 10 passed, 0 failed, 0 skipped.

`BuildPdfContent`, `BuildPdfImage`, PDF tests, and existing PDF documentation were not edited.
