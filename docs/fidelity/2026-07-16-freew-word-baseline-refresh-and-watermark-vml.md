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

## Chart and SmartArt follow-up

The same fresh run isolated the remaining chart/SmartArt boundary. Word opens and exports the chart pair, but its PDF leaves both the `orgChart1` hierarchy and `pyramid1` SmartArt graphics blank while retaining their paragraphs; FreeW's WPF/Avalonia captures render the corresponding hierarchy and four polygon bands. A live Word-created SmartArt probe confirmed that the cached `dsp:drawing` shapes carry their node text, so the writer now includes node text in the hierarchy/pyramid cached shapes and emits `wp:cNvGraphicFramePr` on SmartArt frames. The focused package tests pass, but the visual Word export remains blank after this structural correction and is still an open DOCX SmartArt compatibility gap.

Evidence: the refreshed run under `freew-fidelity-corpus/runs/word-baseline-refresh-20260716-r2` exported the full corpus without COM failures; the focused chart/SmartArt comparison measured `9.5%` changed pixels for Avalonia page 1 and `10.2%` for WPF page 1 before this follow-up.

## SmartArt package repair

The native Word probes under `freew-fidelity-corpus/runs/native-word-smartart-20260715` showed two package rules that the writer missed: the `diagramDrawing` relationship belongs in `word/_rels/document.xml.rels` rather than `word/diagrams/_rels/dataN.xml.rels`, and the quick-style/colors parts must contain the gallery labels referenced by the presentation graph. FreeW now follows both rules. The focused `SmartArtRoundTripTests` lane passes `24/24`.

A fresh fixture generated after the repair was exported by visible Word and rasterized successfully. Word now renders the FreeW pyramid geometry and the hierarchy geometry instead of leaving both SmartArt objects blank. The remaining visual gap is text/style fidelity inside those Word-rendered SmartArt shapes; the cached FreeW drawing still supplies node text and explicit geometry for FreeW's own renderers.

Generated PDFs and PNGs remain ignored under `freew-fidelity-corpus/runs/` and are not part of the commit.
