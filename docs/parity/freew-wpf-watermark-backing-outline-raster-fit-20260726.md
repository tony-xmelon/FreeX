# Imported Watermark Backing Outline Raster Fit

## Scope

This is a follow-up to the exact imported `watermark backing layer` TextBox outline
signature. It changes no generic shape renderer behavior.

## Investigation

Word's authored 1.67-DIP `#70AD47` outline has a denser raster footprint than WPF's
fractional `Border` stroke. Starting from the accepted 2-DIP WPF calibration, two
bounded probes were measured against the same manually saved Word PDF reference:

| WPF outline | Whole page | TextBox ROI `(160,265)-(415,360)` |
| --- | ---: | ---: |
| 2.0 DIP baseline | 4.9145% | 5.2853% |
| 2.25 DIP | 4.9104% | 5.1394% |
| 2.5 DIP | 4.9070% | 5.0197% |

`UseLayoutRounding` plus `SnapsToDevicePixels` was rejected: it worsened the TextBox
ROI to 5.5710% and the page to 4.9225%.

## Accepted Result

The exact signature now uses a 2.5-DIP WPF outline. The primary glyph crop and the
independent Review Copy crop are pixel-stable relative to the 2-DIP baseline.

## Verification

- `ImportedWatermarkBackingTextbox_UsesMeasuredOutlineRasterFit`.
- Source-contract test for the exact signature.
- Fresh `FreeW.FidelityRender` Release build and composite render.
