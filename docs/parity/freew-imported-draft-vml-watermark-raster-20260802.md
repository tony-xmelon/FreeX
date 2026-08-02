# FreeW imported DRAFT VML watermark raster parity

## Scope

- Fixture: `f2-border-watermark.docx`
- DOCX SHA-256: `C26DCE9B6317EA5DCFF1DA669059E821581B95E6152849202139FB96B2E2FC03`
- Fresh Word COM PNG SHA-256: `D67138C3955E96F3427B37A91115375FDD6424D584DE16BDCADC102E0AF6576A`
- Capture size: 816 x 1056
- WPF candidate capture: `FreeW.FidelityRender --composite`, Release build

The package contains Word's canonical 468 x 117 pt VML `PowerPlusWaterMarkObject` with
`DRAFT`, Calibri, `#808080`, opacity `0.4`, fitshape enabled, and a 315-degree rotation.
The model already retained that payload, but imported native text paths were suppressed and the
detached WPF paginator's opaque page surface erased watermarks painted underneath it.

## Accepted behavior

The shared watermark planner now recognizes only this measured imported DRAFT signature. It uses
Word's observed pale-green raster color, Calibri Light glyph owner, a 200-DIP source size, 1.18 X / 0.76 Y
fitshape transform, and the measured page registration. The live WPF brush and FidelityRender consume
the same plan. FidelityRender paints it above the opaque body page only when no table, visible
header/footer, or floating-object owner is present.

## Evidence

| Metric | Baseline | Candidate | Delta |
| --- | ---: | ---: | ---: |
| Whole page mean channel diff | 3.7720% | 3.3220% | -0.4500 pp |
| Watermark ROI `(120,250)-(660,810)` | 7.9339% | 6.6515% | -1.2824 pp |

Word's dominant watermark mask is `#B4D699`, with 17,896 pixels and bbox
`(160,282)-(618,772)`. Broad native-VML restoration and uniform glyph scaling both regressed the
target and were rejected before this anisotropic fitshape calibration.

Byte-stable controls from the same final artifact:

- `table-page-composition-stress`, pages 1-3
- `wordart-watermark-stress`, page 1
- `backstage-pdf-export-fidelity`, pages 1-4

Focused verification:

- `TextWatermarkLayoutPlanner`: 7/7
- `FidelityRenderCompositeTests`: 10/10
- `FreeW.App.Presentation`, `FreeW.App.Host`, and `FreeW.FidelityRender` Release builds: 0 warnings / 0 errors

## Process rule

Treat serialized VML presence as source metadata, not universal paint evidence. Rebuild the shared
planner and every consuming renderer before scoring. Recover fitshape with independent X/Y raster
calibration, and accept an imported watermark only with target ROI plus whole-page improvement and
byte-stable structured/native-VML controls.
