# Avalonia Page Border Raster Registration

## Owner

The two Word-backed WordArt fixtures share a serialized double page border:
`#1F4E79`, 2.25 pt, with the writer's 24 pt `w:pgBorders/@w:space` inset.
Avalonia preserved that semantic inset but centered its 3-DIP pen on it, placing
the opaque outer edge one pixel outside Word's raster.

## Correction

`DrawPageBorder` retains the serialized inset and adds a one-DIP paint-only
inset before centering the Avalonia stroke. This changes neither the page-border
model nor OOXML serialization.

## Word Evidence

Both fresh 816x1056 Word COM targets now share the exact `#1F4E79` mask bbox
with Avalonia: `(32,32)-(783,1023)`.

| Fixture | Whole-page mean channel delta before | After |
| --- | ---: | ---: |
| `wordart-picture-watermark-layout` | 23.2047 | 20.3356 |
| `wordart-watermark-stress` | 14.5638 | 13.1520 |

The outer 60-pixel chrome-band delta is 12.0034 for the picture fixture and
3.8466 for the stress fixture after the registration correction.

## Controls And Verification

- `field-page-number-variants` has no page-border source and is SHA-256
  byte-identical on all four Avalonia pages.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 9 passed after rebuild and 9 passed
  with `--no-build`.
