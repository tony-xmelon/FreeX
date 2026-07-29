# Field Page-Count Word Contract

## Scope

`field-page-number-variants` is a four-page visual-evidence fixture. Its
header/footer fields exercise first-page, even-page, and default-page routing.

## Baseline

A fresh Microsoft Word COM export of the exact generated fixture produced four
Letter page PNGs at 816x1056. Word resolved `NUMPAGES` as `4` on every page.

Before this correction, WPF rendered four pages, but the Avalonia
`FreeW.PageLayoutShot` path rendered only three raw 960x1200 viewport captures
and passed a synthetic `pageCount: 3`. The document factory also cached `3` as
the displayed `NUMPAGES` result. That made the two renderer evidence paths
semantically different from the Word fixture.

## Correction

- Capture and expect page four in the Avalonia PageLayoutShot scenario.
- Pass `pageCount: 4` to every field-page-number render.
- Capture the Word-comparable 816x1056 page surface instead of the raw
  960x1200 viewport.
- Align cached `NUMPAGES` field results in the generated fixture to `4`.

## Fresh Evidence

The fresh Word/WPF/Avalonia run has four pages in each output. Both FreeW
renderer manifests resolve the same header/footer signatures:

- Page 1: first header and footer, `PAGE=1`, `NUMPAGES=4`.
- Page 2: even header, `PAGE=2`, `NUMPAGES=4`.
- Page 3: default header/footer, `PAGE=3`, `NUMPAGES=4`.
- Page 4: even header, `PAGE=4`, `NUMPAGES=4`.

The fresh comparison still has visual layout and typography residuals. Mean
channel differences against Word are WPF 14.3982, 14.1728, 14.1918, and 5.7142
for pages 1-4, and Avalonia 13.4273, 23.2573, 23.5860, and 10.7889. These are
remaining visual-parity work, not part of this semantic/capture correction.

## Verification

- `VisualEvidencePlannerTests`: 130 passed.
- `VisualEvidencePageLayoutShotSourceTests`: 5 passed.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- Fresh direct Word COM export completed in about seven seconds.
