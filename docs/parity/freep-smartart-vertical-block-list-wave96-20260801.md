# FreeP SmartArt `verticalBlockList` Shared Layout - Wave 96

FreeP now admits the native `verticalBlockList` SmartArt layout to the shared live
layout path. Before this slice, the reader classified the layout only through its
broad list-like name and left it outside the live allow-list, so imported diagrams
rendered from the cached `dsp:drawing` payload.

The shared plan now:

- classifies and admits `verticalBlockList` as `SmartArtFamily.List`;
- emits one editable renderer-neutral rectangular block per non-empty authored node;
- preserves pre-order node text and bounded left insets for authored levels; and
- is consumed by the existing WPF and Avalonia `SlideCompositor` paths without a
  renderer-specific SmartArt implementation.

Focused presentation, WPF compositor, and Avalonia headless composition tests cover
the reader admission, authored order, block geometry, and both-host consumption.

Remaining limitations are intentional: this slice does not add a new Insert SmartArt
or Change Layout command, does not regenerate native layout/style/color XML parts,
does not reproduce PowerPoint's exact block padding, bullet treatment, effects, or
theme geometry, and does not claim a PowerPoint-authoritative raster baseline. Unknown
list layout IDs and malformed/empty diagrams continue to use the cached drawing
fallback.
