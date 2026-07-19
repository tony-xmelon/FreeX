# FreeP imported chart-title raster calibration

Date: 2026-07-18

## Corpus and diagnosis

Fresh PowerPoint, WPF, and Avalonia renders were generated from
`tools/FreeP.RenderCompare/corpus/18-chart-types.pptx` at 1280x720. All four
PowerPoint pages and all candidate pages had matching dimensions and non-empty
opaque output.

The imported chart XML carries an explicit 18pt chart-title run property but
no Latin typeface. Raw title masks showed that WPF's imported title glyphs
were smaller and higher than PowerPoint on the column, line, and bar charts;
the radar title path was already stable. This identified the title raster role
and its automatic title band as the ownership boundary, rather than a global
chart font or chart geometry correction.

## Accepted change

Imported chart titles with an explicit text style use a renderer-calibrated
24pt raster size. Imported automatic titles use a -4 DIP band adjustment,
moving the prior title band down by 6 DIPs. Axis, legend, plot, series, and
radar paths remain unchanged.

| Slide | Baseline WPF | Candidate WPF | Baseline Avalonia | Candidate Avalonia |
|---|---:|---:|---:|---:|
| 1 | 0.5004% | 0.4348% | 0.4610% | 0.4139% |
| 2 | 0.7874% | 0.7188% | 0.8171% | 0.7697% |
| 3 radar | 1.2063% | 1.2063% | 1.1763% | 1.1763% |
| 4 | 0.7395% | 0.6742% | 0.7529% | 0.7026% |
| Average | 0.8084% | 0.7585% | 0.8018% | 0.7652% |

The candidate is non-regressing across the complete page sequence for both
hosts. The radar page remains unchanged, providing an adjacent control for
the title-specific calibration.

## Rejected directions

Changing the imported chart grid stroke from gray to a darker gray worsened
the radar page from 1.2063% to 1.2924% for WPF and from 1.1763% to 1.2332%
for Avalonia. Assigning Aptos/Aptos Display explicitly also worsened the
matched chart controls. Both probes were reverted; the host-local title
raster calibration is the only accepted change.

## Verification

- Focused title contracts: 4/4.
- Chart planner and baseline corpus tests: 199/199.
- Release RenderCompare build: 0 warnings, 0 errors.
- Fresh PowerPoint comparison: 4/4 pages, 1280x720 on every page.
