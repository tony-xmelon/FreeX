# FreeW Wave 85: Avalonia PDF Inline Images

Wave 85 closes the next explicit FreeW Avalonia PDF residual: inline images.

## Divergence confirmed before the change

- WPF's `FreeW.App.Host/Editing/DocumentView.cs` `BuildImageRun` decodes the model image, applies the WPF image-adjust pipeline, clips `CropLeft`/`CropRight`/`CropTop`/`CropBottom`, and applies the model rotation/flip transform around the image center.
- Avalonia already owns the live page-space image layout in `FreeW.App.Avalonia/Editing/DocumentView.cs`: `LayoutImageParagraphPaged` reserves the fitted line box, records the page-space rect in `_images`, and the live render pass paints those cached image items before body text.
- Before Wave 85, `BuildPdfContent` emitted body/header/footer/note text and table surfaces but did not consume `_images`, so an image visible in Avalonia Print Layout was absent from the Avalonia PDF draw-op document. WPF PDF export remained a rasterized `DocumentPaginator` page and therefore included the image.

## Implemented

The Avalonia PDF adapter now reuses each existing `_images` item and its page-space rect. It emits shared `PdfImage` operations after table surfaces and before body text, so table fills/borders remain underneath the image pass and the image pass remains underneath text, matching the live compositor's ordering.

- Layout fit is preserved by converting the already-constrained Avalonia rect directly to PDF points; no second paginator or measurement pass is created.
- PNG/JPEG media keeps its original bytes and uses shared PDF source-crop, opacity, and center-rotation fields.
- Images that need Avalonia pixel adjustments, recolor, artistic effects, or a non-PNG/JPEG decoded format are encoded from the cached rendered bitmap as PNG, preserving the live alpha/effect pixels where the shared image writer can embed them.
- Page ownership is checked against the existing page-space rect. An inline image that is not wholly owned by one page is skipped rather than leaking into an adjacent page, since the current shared operation vocabulary has no arbitrary page-rectangle clip operation.

## Exact residuals

- `PdfImage` has no horizontal/vertical flip fields, so `FlipH` and `FlipV` are not represented in this slice. WPF still preserves those transforms through its raster page export.
- The shared draw-op vocabulary has no reflection/fade-mask operation or picture-border dash operation. Inline reflections and borders therefore remain outside this Avalonia direct-PDF slice; the live Avalonia page and WPF raster PDF still show them.
- Floating images remain a separate PDF residual. This change is intentionally limited to inline images already stored in `_images`.
- Metafile sources that Avalonia cannot decode remain absent from direct PDF output; the live editor's placeholder behavior is not serialized as a `PdfImage`.

## Verification

`DocumentViewPdfExportTests` now pair operation-level assertions for crop/opacity/rotation/layout ordering with a Skia render assertion that the inline image produces visible page pixels.
