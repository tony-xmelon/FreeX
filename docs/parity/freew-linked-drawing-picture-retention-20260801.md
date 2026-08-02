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

## Local preview follow-up (2026-08-02)

Path-aware opens now resolve link-only pictures from local `file:` or relative filesystem targets into a runtime-only preview buffer. WPF, Avalonia, and Avalonia PDF rendering consume embedded bytes first and that resolved buffer second. The writer still sees only the original embedded bytes, so saving a displayed link-only picture does not create a `word/media/*` part or add `r:embed`.

Resolution is bounded to 64 MiB and deliberately rejects HTTP(S), other network schemes, and UNC hosts. Missing, inaccessible, oversized, or malformed targets keep the existing sized placeholder.

Verification on current main:

- `FreeW.Core.IO.Tests`: 1,428/1,428, including local resolution, remote rejection, link-only XML, and reopened-model assertions.
- `FreeW.App.Presentation.Tests`: 1,173/1,173, including the path-aware open workflow.
- WPF runtime decode: 1/1 focused host test.
- Avalonia runtime decode and PDF image operation: 2/2 focused tests.
- WPF and Avalonia consuming Release artifacts built with 0 warnings and 0 errors through the focused host gates.

## Residual

FreeW does not download remote linked pictures. They remain package-faithful and render as a sized placeholder unless the source package also contains `r:embed` bytes.
