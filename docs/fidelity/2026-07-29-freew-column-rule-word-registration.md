# Column Rule Word Registration

## Reference

- Fixtures: `wordart-picture-watermark-layout.docx` and `f2-columns.docx`
- Word reference: fresh Word COM PDF export, rasterized at 96 DPI to 816x1056 PNGs
- Candidate: Release `FreeW.FidelityRender --composite`, rebuilt after the host change

## Change

The WPF print-layout compositor draws column rules separately from the editable
`FlowDocument` rule. Its device-pixel alignment was one pixel right of Word. The
overlay now uses the preceding pixel center while preserving the page's serialized
`w:cols/@w:sep` semantics and the native editable rule path.

## Result

| Fixture / Region | Before | After |
| --- | ---: | ---: |
| Picture-watermark whole page | 5.8949% | 5.7114% |
| Picture-watermark divider ROI `(390,60)-(425,960)` | 5.4240% | 0.4029% |
| Ordinary columns whole page | 3.6769% | 3.4766% |
| Ordinary columns divider ROI `(390,60)-(425,960)` | 5.4849% | 0.0057% |

The `wordart-watermark-stress` no-column control remained SHA-256 identical.
