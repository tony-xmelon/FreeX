# FreeW Shorebird Tracks page-border visual parity (2026-08-01)

## Scope

- Canonical source: `w:pgBorders` with `w:val="shorebirdTracks"`, `w:sz="24"`,
  `w:space="24"`, and `w:offsetFrom="page"`.
- Model signature: `PageBorder.ArtId == 83`, `WidthPt == 3`, and `SpacePt == 24`.
- The shared planner owns the measured 16 horizontal / 20 vertical footprint cadence,
  alternating lateral registration, edge rotation, and four-segment footprint geometry.

## Reference provenance

- Exact source DOCX SHA-256: `EDE8044B57420DCF1A7BA3C6150EF7D19117BB9B1783F53230A19EC254732E25`.
- Microsoft Word PDF SHA-256: `C92443902CE695061DF49FE3503F270C88BC53335B4025410BA40CEBA811AB5D`.
- Poppler 96-DPI PNG SHA-256: `5A467939B492B4566682D779CD2937266948D2E4E517E1172B6CCE310A468B34`.
- Previous FreeW fallback PNG SHA-256: `03F3B7A700C428EF39133E5EE284AF569E395449261FD93476C054A36D537E25`.
- Accepted FreeW candidate PNG SHA-256: `E1A69DF4A602CE216AE05927446BBD91C64CD7769B5D1CD607F559F798C436A8`.
- Reference and FreeW images are both 816 x 1056 pixels.
- Word COM opened the exact short-path package and completed PDF export in 9.75 seconds.

## Measured result

Mean absolute RGB channel difference against the same Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 2.3708% | 0.9287% | -1.4421 pp |
| Perimeter excluding interior | 5.9016% | 1.3651% | -4.5365 pp |
| Top edge | 5.9149% | 1.4384% | -4.4765 pp |
| Left edge | 5.9046% | 1.1780% | -4.7266 pp |
| Right edge | 5.9123% | 1.2234% | -4.6889 pp |
| Bottom edge | 5.9231% | 1.3623% | -4.5608 pp |
| Interior control | 0.7254% | 0.7254% | 0 changed pixels |

Word paints each footprint as four thin flat-cap segments. The footprints advance in edge direction,
rotate clockwise around the page, and alternate by about 6.5 DIPs across the edge centerline. The
shared plan exposes the final physical line segments so WPF, Avalonia, software evidence, and direct
PDF cannot drift into separate geometry.

## Verification and process rule

- Shared planner coverage verifies ArtId 83, counts, registration, rotations, and exact segments.
- WPF live view, print preview, FidelityRender, and software evidence consume the shared plan.
- Avalonia live view and direct PDF consume the same four lines per footprint and omit the rectangular
  fallback.
- The final Release consuming-artifact build and focused page-border lanes are required before merge.

For sparse geometric art, measure connected ink bands and orientation before choosing cadence. Cache
several exact Word exports to rank candidate motifs, skip bitmap-like art when a vector owner is
available, and accept only when every edge plus the whole page improves with an unchanged interior.
