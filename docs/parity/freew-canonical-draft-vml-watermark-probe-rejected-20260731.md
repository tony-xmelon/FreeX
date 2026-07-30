# Canonical DRAFT VML Watermark Probe Rejected

## Scope

`f2-border-watermark.docx`, 816x1056, compared with the fresh matched Word PNG in
`C:\Temp\FreeW-F2Corpus-20260731`.

## Observation

Word paints the imported default `DRAFT` VML text path. The package retains the canonical
468pt by 117pt `PowerPlusWaterMarkObject`, `fitshape`, 315 degree rotation, `#808080`, and
0.4 opacity. FreeW preserves this payload but deliberately suppresses imported VML paths,
which also keeps `wordart-watermark-stress.docx` correct because Word hides its serialized
`CONFIDENTIAL` VML path.

## Rejected probes

An exact DRAFT-only render allow-list was tested with a shared WPF/FidelityRender plan.

| Candidate | Whole page | Watermark ROI `(120,250)-(660,820)` | Result |
|---|---:|---:|---|
| Baseline, VML suppressed | 3.7737% | 7.7975% | Reference |
| Canonical geometry, source gray | 3.7969% | 7.8624% | Rejected |
| Larger glyph scale | 3.8793% | 8.0928% | Rejected |
| Word-measured green palette, scale 1.25 | 3.9139% | 8.1899% | Rejected |
| Word-measured green palette, scale 1.55 | 4.0305% | 8.5164% | Rejected |

At the final measured scale, Word's exact `#B4D699` mask was 17,896 pixels in
`(160,282)-(618,772)` and the candidate was 18,868 pixels in `(191,299)-(616,752)`, but
only 4,822 pixels overlapped. The residual is VML text-path glyph geometry/rasterization,
not a scale, offset, or color calibration.

## Decision

Reverted all product and test probe code. Keep serialized native VML text paths nonvisual
until the renderer can model their path/formula behavior. Do not enable imported VML based
only on text, dimensions, rotation, color, or opacity. The hidden `CONFIDENTIAL` control
remained SHA-256 byte-stable throughout the probe.
