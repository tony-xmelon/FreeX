# Avalonia Serialized Fixture Capture

## Problem

The Word-baseline path and WPF FidelityRender both consume the generated DOCX
fixture. Avalonia PageLayoutShot previously rendered the in-memory factory
model instead. That distinction is material for `wordart-watermark-stress`:
the serialized `word/header1.xml` contains the native VML
`PowerPlusWaterMarkObject` text-path payload for `CONFIDENTIAL`, which the
reader preserves and the shared watermark planner suppresses from paint.

The direct Avalonia model did not carry that serialized payload, so it drew a
text watermark from the editable custom-property fields while the Word and WPF
paths did not. The compared renderers were therefore using different document
representations.

## Correction

`FreeW.PageLayoutShot` accepts an optional `--fixtures-dir`. When a selected
scenario's DOCX exists there, it uses `DocxReader` to render that serialized
fixture. Standalone PageLayoutShot runs still use the in-memory factory. The
visual-evidence runner supplies its generated fixture directory to the
Avalonia capture process.

## Fresh Word Evidence

The Word references were freshly exported through Word COM from the same
fixture directory before this renderer-only change. At 816x1056:

| Fixture | Avalonia mean channel delta before | After | Changed pixels before | After |
| --- | ---: | ---: | ---: | ---: |
| `wordart-watermark-stress` | 14.6555 | 14.5638 | 12.132% | 11.781% |
| `wordart-picture-watermark-layout` | 26.0125 | 24.1824 | 22.434% | 18.839% |

WPF `wordart-watermark-stress` stayed SHA-256
`5D811E2929A4254863F9E9B6B68942792FD3E5D616F6CF80F53FD90B7CFFC7D4`.

## Control

The unrelated four-page `field-page-number-variants` fixture is SHA-256
byte-identical before and after in both WPF and Avalonia on all four pages.
Its first/even/default header-footer field routing remains unchanged.

## Verification

- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidenceRunnerScriptTests`: 8 passed.
- `VisualEvidencePageLayoutShotSourceTests`: 5 passed.
- Direct two-document Word COM export: 2/2 succeeded.
