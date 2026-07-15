# FreeW Word Baseline Refresh and Watermark VML - 2026-07-16

## Fresh Word baseline

The Word-capable Windows lane was refreshed from the current FreeW corpus using the visible Word publish path. The run generated 30 DOCX fixtures, exported all 30 fixtures to Word PDFs, and rasterized 88 Word page images at the same dimensions as the FreeW WPF evidence surface.

The first fresh attempt failed all 30 exports with `RPC_E_CALL_REJECTED` because Word's visible `Powering your experiences` startup dialog kept the automation server busy. `tools/FreeW.RenderCompare/Export-WordPdfsVisible.ps1` now retries rejected COM calls and dismisses that Word-owned startup dialog. A one-fixture probe then exported successfully, followed by a clean 30/30 corpus export (5,712,508 PDF bytes in the first complete run).

The rasterizer previously produced 653x845 Word images against 816x1056 FreeW images. `tools/Run-FreeWWordBaselineEvidence.ps1` now derives the target surface from the matching WPF PNG and compensates for the rasterizer's 120-to-96 DPI conversion, including landscape pages.

The normalized fresh comparison contained 88 paired rows: 84 failed strict Word-image tolerance, 1 passed, and 3 were skipped. The summary's trust gate still fails on this host because WPF evidence used the software renderer, and the remaining image deltas are recorded as real renderer gaps rather than COM or dimension failures.

## DOCX watermark emission

Before this slice, FreeW persisted watermark settings only in `docProps/custom.xml`; Word therefore showed the floating WordArt but omitted the text and picture watermarks from the generated DOCX. `DocxWriter` now emits Word-compatible VML watermark shapes in the relevant header parts, including default/first/even header slots. Text watermarks carry the configured text, font, color, orientation, and opacity. Picture watermarks carry a header-local image relationship and media part.

Focused validation:

- `WatermarkOptionsRoundTripTests`: 11/11 passed.
- A fresh `f2-border-watermark.docx` export through visible Word produced a PDF with the VML text watermark visible in Word's own output.
- The picture watermark package contract is covered by the header relationship/media test. Word's filled-VML picture rendering remains a follow-up visual target; the non-destructive text watermark path is the validated portion of this slice.

Generated PDFs and PNGs remain ignored under `freew-fidelity-corpus/runs/` and are not part of the commit.
