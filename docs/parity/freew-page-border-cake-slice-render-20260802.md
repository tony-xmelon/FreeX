# FreeW Cake Slice page-border parity (2026-08-02)

## Scope

The imported Word `cakeSlice` page-border art (ArtId 3) previously used the generic
four-line fallback. The shared planner now owns the repeated upright cake tile: a black
outer silhouette with cream `#FFEECA` cake layers and pink `#FF99C2` icing. WPF,
Avalonia live rendering, Avalonia PDF export, and the software fallback consume the
same polygon plan.

## Matched reference

- Fixture: `cake.docx`, SHA-256
  `231DAD262FD53AFE77BC7F45B4BB350B42DDCDB3A43C896AA8E450D94FB990F1`
- Word COM PNG: 816x1056, SHA-256
  `008CBD94193BB6E47C89DEAE7B8447FE51BB2CF5BACF56CFFAFB74F4B453E579`
- Before WPF composite PNG: 816x1056, SHA-256
  `E6F0B9BAF3A9162D49ED668C72A4A595A97766BF76C2A1F60573D7DCEB493127`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `75C27447FC9FD28CED0FF068376C6FD599B411CE2DF34D8000CAC900D58FBA67`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.5484% | 4.3274% | -2.2210 pp |
| Top border | 24.2386% | 15.5948% | -8.6438 pp |
| Bottom border | 26.0357% | 14.9520% | -11.0837 pp |
| Left border | 24.4023% | 15.8219% | -8.5804 pp |
| Right border | 23.6272% | 15.8028% | -7.8244 pp |
| Interior control | 0.7168% | 0.7168% | 0.0000 pp |

The new path restores the missing cake object, Word cadence, upright orientation, and
dominant layer colors on every edge. Remaining error is concentrated in the detailed
black separators, tilted crust geometry, and Word's antialiasing; body content is stable.

## Verification

- `PageBorderArtVisualPlannerTests`: 12/12
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Cake Slice PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page
- Fresh WPF composite render: 1/1 page

## Process note

The source mask contained 6,219 exact black pixels in the top ROI while the first
candidate contained 3,406. Adding broad separator and right-crust overlays moved the
candidate to 6,926 black pixels, but regressed whole page from 4.3274% to 4.4948% and
every edge ROI, so that probe was reverted. Exact color counts identify layer ownership;
they do not replace the matched target, whole-page, edge, and interior-control gates.
