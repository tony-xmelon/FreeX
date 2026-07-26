# Imported Watermark Backing TextBox Outline

## Scope

`wordart-watermark-stress.docx` contains one imported floating DrawingML TextBox with
fill `#E2F0D9`, outline `#70AD47`, text `watermark backing layer`, square wrapping,
and margin/paragraph anchoring. Its authored outline is 1.67 DIPs wide.

## Baseline

The manually saved Word PDF reference is rasterized at 816x1056:

- PDF SHA-256: `EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A`
- PNG SHA-256: `FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`

Word paints the outline as a two-pixel opaque perimeter. WPF's fractional `Border`
stroke blended into the fill, losing the solid top edge.

## Change

Only the exact imported TextBox signature uses a 2-DIP WPF `BorderThickness`. Its
layout rectangle, fill, text, shadow, and all other shape signatures remain unchanged.

## Matched Composite Evidence

Fresh Release `FreeW.FidelityRender --composite`, rendered from the actual consuming
artifact against the manual Word PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9204% | 4.9145% |
| TextBox ROI `(160,265)-(415,360)` | 5.4946% | 5.2853% |
| Primary watermark ROI | 7.3074% | 7.2827% |
| Review Copy ROI | 4.0495% | 4.0495% |

Candidate-versus-baseline pixel checks: primary glyph crop and Review Copy crop changed
zero pixels; only the TextBox ROI changed.

## Verification

- `ImportedWatermarkBackingTextbox_UsesOpaqueTwoDipOutline`: passed 1/1.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
