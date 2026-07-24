# VML Watermark Source Ownership

## Evidence

The manually exported Word PDF for wordart-watermark-stress is an 816 x 1056
reference surface. Its source DOCX contains a FreeW custom watermark property
for CONFIDENTIAL but no Word header part and no VML text-path payload. Word does
not display a central diagonal watermark.

## Resolution

Imported custom watermark metadata with no native VML text-path now remains
metadata-only on save. FreeW no longer materializes a new header shape for it.
An explicit disabled VML text path remains serialized because its preserved
payload proves that the source owned an invisible VML layer.

Newly authored text watermarks continue to emit the canonical VML header shape.

## Verification

- WatermarkOptionsRoundTripTests: 27/27
- Fresh Release FidelityRender confirmed the current fixture has no synthesized
  central watermark, matching the manual Word reference's layer ownership.
