# FreeP Zoom cover-image crop semantics

## Scope

PowerPoint Zoom objects with `imageType="cover"` fill the Zoom frame by cropping
the source image to the frame aspect ratio. The previous FreeP draw operation
preserved the cover type but passed zero crop values to the shared picture
renderers, so a newly authored cover image could be stretched into the frame.

## Change

The renderer-neutral `PictureRenderPlanner` now computes a centered crop from
the source pixel aspect ratio and destination frame aspect ratio when a picture
is marked `IsCover` and has no explicit crop. Explicit `CropLeft`, `CropTop`,
`CropRight`, and `CropBottom` values remain authoritative. Single-target and
Summary Zoom tile composition set `IsCover` from the native `imageType` property,
and canvas transform previews preserve it.

## Verification

- `RendererNeutralDedupPlannerTests`, `SlideCompositorTests`,
  `SlideZoomInsertionPlannerTests`, and `SummaryZoomInsertionPlannerTests`:
  **165/165**;
- `dotnet build freep/FreeP.App.Host/FreeP.App.Host.csproj --configuration Release`:
  **0 warnings, 0 errors**;
- `dotnet build freep/FreeP.App.Avalonia/FreeP.App.Avalonia.csproj --configuration Release`:
  **0 warnings, 0 errors**.

This is a package/model/compositor function slice. No PowerPoint raster baseline
was used or claimed.
