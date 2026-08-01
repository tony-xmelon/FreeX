# FreeW table-cell wave border raster (2026-08-01)

## Scope

FreeW already preserved WordprocessingML `w:tcBorders` edges with `w:val="wave"`, but the shared
table-cell border plan explicitly sent that style through a solid-line host fallback. The shared plan
now owns the measured eight-DIP repeat, four-DIP outward amplitude, and 86/255 composited stroke
opacity. WPF and Avalonia consume the same sampled half-wave offsets; each keeps only its physical
cell-rect registration local to the backend compositor.

Dashed, dotted, double, thick, and single edges retain their existing paths.

## Provenance

A temporary package variant was generated from the current `table-layout-complex.docx` fixture by
changing exactly four custom top-border tokens from `double` to `wave`. No model content, geometry,
fill, text, or other edge changed.

- Variant DOCX SHA-256: `68FA15548271EF1C5A3C5C16C05A02B8C6F6FCDAFB4EAC759669EB39BABD2171`
- Word 16 PNG SHA-256: `3A8AA9BE3713C7A58824967BF349F2A0AF3EF3359F0EE6202997341A3A8D94F7`
- WPF before / after:
  - `F36123578B23DC1F45CCD1E578BAF882DD70DC6C23DF277C4E6F8F13551EB7D3`
  - `11B58861F66C1DF2743A79325C150FAA5137E17C43A001DBE4B9D346996CB80F`
- Avalonia before / after:
  - `95C73C2A75A9743EFC2E84B9103C3CC54B4073690BCB1E5A6EFF2B1DD3D397C2`
  - `E20E36CA0820CC06727408D7C28505CDC3FC5B8DF5A7737377A09226414AC6E9`

Word exported the short-path fixture through an isolated visible COM process and quit cleanly.

## Evidence

Mean absolute RGB channel delta against the matching 816x1056 Word PNG:

| Host / region | Before | After | Change |
|---|---:|---:|---:|
| WPF whole page | 3.1927% | 3.1041% | -0.0886 pp |
| WPF header-wave ROI `(95,198)-(720,218)` | 8.5308% | 5.5558% | -2.9750 pp |
| WPF total-wave ROI `(95,438)-(720,458)` | 11.2671% | 8.1319% | -3.1352 pp |
| WPF table ROI `(95,198)-(720,503)` | 8.9438% | 8.5431% | -0.4007 pp |
| Avalonia whole page | 3.8208% | 3.7796% | -0.0412 pp |
| Avalonia header-wave ROI `(95,198)-(720,218)` | 9.9999% | 8.0099% | -1.9900 pp |
| Avalonia table ROI `(95,198)-(720,503)` | 13.2248% | 13.0386% | -0.1862 pp |

Candidate-vs-baseline changed-pixel ownership is limited to the authored wave bands:

- WPF: 6,548 changed pixels, only output rows 205-211 and 439-445.
- Avalonia: 6,438 changed pixels, only output rows 202-208 and 392-398.

The different second-band coordinates reflect the existing host table-height/layout difference; the
whole-page direct Word gate still improves in both hosts.

## Rejected probes

- Full-opacity WPF wave geometry improved the whole page only from 3.1927% to 3.1900%; raw Word
  pixels showed the wave core was approximately 33% composited authored color, so the measured
  86/255 opacity replaced it.
- Avalonia registration `-5 DIP` improved the tight header crop from 8.0099% to 7.9967%, but regressed
  the whole page from 3.7796% to 3.7805% and table ROI from 13.0386% to 13.0429%; `-4 DIP` was retained.

## Verification

- Shared `TableCellBorderVisualPlannerTests`: 4/4
- WPF border-planner source guard: 1/1
- Avalonia border-planner source guard: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors
- Fresh Word/WPF/Avalonia renders: 1/1 each

## Process rule

When a serialized border style is preserved but visually downgraded, first recover the host's raw
repeat, amplitude, composited opacity, and physical-edge ownership. Keep geometry shared, keep only
the compositor registration local, and accept only when target ROI and whole page improve while the
changed-pixel envelope remains confined to the authored edge bands.
