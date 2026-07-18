# FreeP background, tab-stop, and vertical-text probes

Date: 2026-07-18

## Baseline

Fresh PowerPoint, WPF, and Avalonia renders were generated from
`tools/FreeP.RenderCompare/corpus/16-bg-tabs-vtext.pptx` at 1280x720. All paired
PNGs had matching dimensions and the gradient background was visually and
pixel-wise stable outside the title text.

| Slide | WPF vs PowerPoint | Avalonia vs PowerPoint |
|---|---:|---:|
| 1 gradient background | 0.5851% | 0.5775% |
| 2 tab stops | 0.5650% | 0.5944% |
| 3 vertical text | 0.4521% | 0.4187% |
| Average | 0.5340% | 0.5302% |

Raw dark-ink bands show the residual is text-owned. On slide 2, PowerPoint's
tab paragraph bands are y=91-108, 114-133, 140-159, and 165-182; WPF is
y=88-108, 113-134, 139-160, and 165-183. On slide 3, the white vertical
glyph masks are:

| Object | PowerPoint | WPF |
|---|---|---|
| upward text | (127,200)-(141,360) | (125,202)-(138,358) |
| downward text | (314,188)-(325,372) | (315,190)-(327,367) |

## Rejected probes

1. Using `TextFormattingMode.Ideal` only for WPF tab-stop measurement and
   painting worsened slide 2 from 0.5650% to 0.5775%. Slides 1 and 3 were
   unchanged. Reverted.
2. Using `Ideal` metrics only in the rotated vertical-text flow was
   byte-identical on all three slides. The formatting-mode choice is not the
   active owner for this fixture. Reverted.
3. Expanding rotated text around its shape center and applying the measured
   two-DIP upward registration worsened slide 3 from 0.4521% to 0.4529%.
   Slides 1 and 2 were unchanged. Reverted.

## Process rule

The raw glyph masks identify a small orientation-specific raster/geometry
difference, but a generic scale, offset, or font-mode change is not supported
by the full-slide gate. Keep this fixture as a text-raster diagnostic and do
not apply a global font correction.

Evidence comparisons must also reject mismatched raster surfaces before any
ROI score is interpreted. In particular, a fixed-frame PowerPoint export and
a renderer-native landscape PNG need an explicit final-raster normalization
contract with matching dimensions and capture provenance; source-layout
changes cannot repair an evidence-surface mismatch.
