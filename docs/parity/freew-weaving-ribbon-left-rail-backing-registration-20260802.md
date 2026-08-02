# FreeW Weaving Ribbon left-rail backing registration (2026-08-02)

## Scope

After vertical phase registration, exact pixel masks showed that Word's middle-left
`weavingRibbon` rail paints through x=63 while FreeW's 32-DIP black rail ended at
x=62. The motif polygons already terminate at x=63, but without a dark substrate
their antialiased edge blended into the white page. The shared planner now adds one
1-DIP black backing strip at x=63 only from y=128 through y=928.

## Matched reference

- Fixture: `weave.docx`, SHA-256
  `A660307EAAC0F59B0E557817AAC0C7F142AA3ECF53AC0BEF1B9DEDFB8217DF04`
- Fresh Word COM PNG: 816x1056, SHA-256
  `FAA7D440418230B5839C5E913C38AE86C6CB94A08C4B443E33FCCF7C80869658`
- Before WPF composite PNG: 816x1056, SHA-256
  `7D0B387C88435706EACFCF14D56957EA6E155733E1B3F46DADB8FF613081EE2C`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `EA6A69E2E3A4608512831E7D4590D2F0366EFD90CDF2E44C1618908529677CCE`

The regenerated package has a different container hash because of package timestamps,
but both Word and before-candidate PNG hashes exactly match the preceding accepted
slice. The fresh Word COM run completed one document and one page and quit its owned
Word process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.829527% | 5.777113% | -0.052415 pp |
| Top band | 13.349361% | 13.349361% | 0.000000 pp |
| Bottom band | 11.873114% | 11.873114% | 0.000000 pp |
| Left rail | 11.879986% | 11.418737% | -0.461249 pp |
| Right rail | 11.442706% | 11.442706% | 0.000000 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- Focused Weaving Ribbon planner contract: 1/1
- Avalonia live/PDF consumer and Weaving Ribbon PDF raster contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Inspect exact edge columns after phase correction. A polygon can have the correct
endpoint but still rasterize against the wrong substrate. Add backing only to the
measured owner interval, then require the target rail and whole page to improve with
all other edges and the document interior byte-stable.
