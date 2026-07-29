# Avalonia Header/Footer Image Word Surface

## Scope

`f2-hf-images.docx` was exported through the recovered visible Word COM pipeline and rasterized at its native 816x1056 page size. The matching Avalonia `FreeW.PageLayoutShot` fixture uses the exact DOCX through `--fixtures-dir`.

## Fix

`f2-hf-images` now participates in `ShouldCaptureWordComparablePageSurface`. It already has a section-page surface plan, but without the Word-page crop it emitted 864x1104 images that could not be scored against Word's 816x1056 pages.

The PageLayoutShot source contract now explicitly protects that inclusion.

## Matched Evidence

Both candidate pages now have the Word dimensions and `avalonia-word-page-surface` capture provenance:

| Page | Word size | Avalonia size | Whole-page mean RGB delta |
| --- | --- | --- | ---: |
| 1 | 816x1056 | 816x1056 | 1.5100% |
| 2 | 816x1056 | 816x1056 | 2.4993% |

The remaining high tiles are the body/header area. They are now valid layout evidence rather than a dimension-mismatched screen capture. The next visual slice should trace the section page-frame and header/body vertical ownership against this matched reference; it must not use the former 864x1104 capture as a baseline.
