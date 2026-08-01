# FreeW page wave border raster (2026-08-01)

## Scope

FreeW preserved WordprocessingML page borders with `w:val="wave"`, but every page-border consumer
painted the style as a solid rectangle. A shared presentation plan now owns Word's measured page-wave
raster: separated three-DIP diagonal segments, an eight-DIP repeat, a four-DIP phase, a one-DIP pen,
and 166/255 composited authored color.

WPF live editing, WPF Print Preview, `FreeW.FidelityRender`, Avalonia page composition, and Avalonia
PDF export consume that plan. Existing single, dashed, dotted, double, and table-cell border paths are
unchanged. PDF uses the same vector segments and precomposes the authored color because the shared
PDF line primitive has RGB color but no stroke alpha.

## Provenance

A temporary package variant was generated from current `table-layout-complex.docx` by adding one
page-relative `w:pgBorders` payload. All four edges use `wave`, 3-point authored width, 24-point page
spacing, and `#1F4E79`. No body, table, fill, text, or page geometry changed.

- Variant DOCX SHA-256: `25F5BE96A6B19488D28B6F38E25D42E3AB08C35DE6B814C442CD3F6F9DB3C52A`
- Word 16 PNG SHA-256: `62CA6B6878D2F9F52DF7FFC1F3F828BFBC42204410F251810BB3CCB675658FE8`
- WPF before / after:
  - `F2E0B21DFED8E54C36065238D1F6B5630127397C8A16BB6F946A7917C35BA14F`
  - `A154C7A3EB5E1495515564035F0B6DBB4C5E7E0AD60FDC479E4ADD6B87EF3EBA`
- Avalonia before / after:
  - `7FEFDBB493388F0193747F41A97EA00BF778A03F5B93AE578A47202BCE90B022`
  - `846E8BB753A0F0BE06E49642D58EEF9D442FDE4D834FBF8BAAF1022A5833FEF8`

Word exported the short-path fixture through an isolated visible COM process and quit cleanly.

## Evidence

Mean absolute RGB channel delta against the matching 816x1056 Word PNG. Avalonia is scored after
extracting its exact 816x1056 page surface from the 960x1800 evidence viewport.

| Host / region | Before | After | Change |
| --- | ---: | ---: | ---: |
| WPF whole page | 4.2191% | 3.2418% | -0.9773 pp |
| WPF four-edge perimeter mean | 18.6042% | 1.2093% | -17.3949 pp |
| WPF top | 18.5418% | 1.0467% | -17.4951 pp |
| WPF bottom | 18.4973% | 1.0538% | -17.4435 pp |
| WPF left | 18.6927% | 1.2595% | -17.4332 pp |
| WPF right | 18.6850% | 1.4773% | -17.2077 pp |
| Avalonia whole page | 4.9752% | 3.9998% | -0.9754 pp |
| Avalonia four-edge perimeter mean | 18.6904% | 1.3103% | -17.3801 pp |
| Avalonia top | 18.7491% | 0.9234% | -17.8257 pp |
| Avalonia bottom | 18.5700% | 1.2009% | -17.3691 pp |
| Avalonia left | 18.7390% | 1.4497% | -17.2893 pp |
| Avalonia right | 18.7033% | 1.6673% | -17.0360 pp |

Candidate-vs-baseline changed-pixel ownership is confined to the authored perimeter bands in both
hosts: WPF changed 14,322 pixels and Avalonia changed 17,380 pixels, with zero changed pixels outside
the four measured edge ROIs.

## Rejected Probe

The first path probe used a connected half-cosine wave. It materially improved WPF whole-page error
to 3.4185% and perimeter error to 4.3746%, proving the renderer branch and frame registration, but raw
Word pixels showed separated one-pixel diagonal strokes rather than a connected curve. The connected
probe was replaced by the measured segment plan before integration.

## Verification

- Shared `PageBorderWaveVisualPlannerTests`: 2/2
- WPF page-border consumer source guard: 1/1
- Avalonia live/PDF page-border tests: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors
- Fresh Word/WPF/Avalonia renders: 1/1 each

## Process Rule

When a preserved border style falls through to a solid frame, inspect raw edge pixels before fitting a
generic curve. Accept a shared geometry only after the actual consuming artifacts are rebuilt, every
edge ROI and the whole page improve in both hosts, and changed pixels remain confined to the authored
border bands.
