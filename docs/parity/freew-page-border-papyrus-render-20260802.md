# FreeW Papyrus page-border parity (2026-08-02)

## Scope

The imported Word `papyrus` page-border art (ArtId 92) previously used the generic
four-line fallback. The shared page-border planner now owns its measured black rails,
white center channels, distributed gray oval cells, black hourglass joints, and isolated
corner ornaments. WPF, Avalonia live rendering, Avalonia PDF export, and the software
fallback consume the same fill-and-polygon plan.

## Matched reference

- Fixture: `papyrus.docx`, SHA-256
  `F8243C3F3B6908835B5A8C9D288D419E723154F0DDC432652E8CBBC7F7118FEB`
- Word COM PNG: 816x1056, SHA-256
  `E60723625C145545E2DADFC5A39B0962931D0AA422C7652CE57C61811BFFE8D2`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `D70AF8A83B6FA802C4CF41247045E44F9FC98E57CAFFC2CB9C4B4F85293DEE53`
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 7.2516% | 2.0234% | -5.2282 pp |
| Top border | 28.0316% | 5.3818% | -22.6498 pp |
| Bottom border | 27.9258% | 8.4169% | -19.5089 pp |
| Left border | 26.9046% | 3.7456% | -23.1590 pp |
| Right border | 26.8120% | 7.5023% | -19.3097 pp |
| Interior control | 0.7070% | 0.7070% | 0.0000 pp |

The raw gray-cell centerline runs align from the first through the last Word cell on
all four edges. Remaining border error is concentrated in antialiasing and the simplified
corner flourish; the body/interior is unchanged.

## Verification

- `PageBorderArtVisualPlannerTests`: 9/9
- WPF decorative-border consumer source contract: 1/1
- Avalonia live/PDF consumer source contract: 1/1
- Papyrus PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF composite render: 1/1 page

## Process note

Measure the raw Word tile before selecting primitives. The first diagonal-lattice
approximation improved the page, but the enlarged source tile proved that Word owns
discrete oval cells on a white channel. Replacing the provisional lattice with that
semantic model improved the whole page again and reduced changed pixels from 40,069 to
31,502. Accept only against the same fixture, dimensions, and render provenance, with all
four edges improving and the interior control unchanged.
