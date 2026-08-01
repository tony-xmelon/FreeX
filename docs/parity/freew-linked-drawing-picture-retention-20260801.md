# FreeW Linked Drawing Picture Retention (2026-08-01)

## Gap

Word DrawingML pictures can reference an external image through `a:blip/@r:link`, either alone or
alongside an embedded preview in `r:embed`. FreeW previously recognized only `r:embed`; a link-only
picture therefore disappeared on open/save.

## Slice

- `InlineImage.LinkedImageTarget` preserves the exact external relationship target without fetching it.
- The DOCX reader accepts link-only and link-plus-preview pictures.
- The DOCX writer emits `r:link` with an external image relationship in body, header/footer, comment,
  footnote, and endnote stories. Grouped pictures use the same image-part path.
- Link-only pictures do not create an empty `word/media/*` part or a spurious image content type.
- Pictures carrying both forms retain their embedded bytes and external target.

## Verification

- `LinkedDrawingPictureRoundTripTests`: 4/4.
- Focused image, header, comment/chart, drawing-group, and DOCX round-trip gate: 263/263.
- Full `FreeW.Core.IO.Tests`: 1170/1170.

The package assertions verify `a:blip` attributes, relationship type/target/`TargetMode`, media-part
presence or absence, and the reopened model for document and part-local stories.

## Residual

FreeW deliberately does not resolve or download external image targets. A link-only picture is retained
for Word-compatible package round-trip but has no raster preview in FreeW unless the source package also
contains `r:embed` bytes.
