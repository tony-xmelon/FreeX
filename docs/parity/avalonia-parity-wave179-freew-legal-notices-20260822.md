# Avalonia Parity Wave179: FreeW Legal Notices

Date: 2026-08-22
Scope: FreeW Avalonia Legal Notices, the four long-document tab states
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures at 96 DPI

## Baseline

The route-local harness captured all four WPF/Avalonia pairs at 620 x 600 logical
pixels. The rows had matching focus, default/cancel, action order, tab selection,
content, and automation metadata; each was correctly classified as a genuine visual
mismatch. The residual was concentrated in Avalonia/Skia's colored subpixel text
fringes against WPF's grayscale-looking ClearType authority, with the existing tab
and scrollbar template differences preserved.

## Change

The renderer-neutral FreeW presentation now opts into a route-local grayscale text
policy. The shared Avalonia Legal Notices renderer maps that policy to
`TextRenderingMode.Antialias` on the dialog and realized legal-document
controls/presenters, preserving the thin FreeW platform wrapper. Shared dialog chrome,
shared metrics, WPF authority, notice content, and all other routes are unchanged. The
focused visual test locks the realized route-local policy by automation ID and rendering
mode; the shared ownership guard locks the renderer boundary.

## Fresh route-local evidence

Raw captures and comparison output are retained outside the repository under
`%TEMP%\FreeW-Wave179-Legal-20260822-baseline`, `%TEMP%\FreeW-Wave179-Legal-20260822-final`,
and `%TEMP%\FreeW-Wave179-Legal-20260822-final-compare`.

| State | Before changed | After changed | Delta | Before mean | After mean | pHash after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `tab-legal-notices` | 18.9164% | 18.2040% | -0.7124 pp | 18.731 | 18.836 | 3 |
| `tab-privacy-notice` | 16.6406% | 15.8863% | -0.7543 pp | 17.767 | 17.933 | 5 |
| `tab-third-party-license-texts` | 17.9546% | 17.1739% | -0.7807 pp | 19.033 | 19.164 | 5 |
| `tab-third-party-notices` | 17.9161% | 17.1532% | -0.7629 pp | 18.794 | 18.919 | 5 |

All four final rows remained `genuine-visual-mismatch` with no semantic difference.
The changed-pixel ratio improved in every state without changing comparator thresholds
or classifications. Mean channel delta increased by 0.105-0.132 and p95 increased by
2.33-13.00, so this is reported as a bounded changed-pixel improvement rather than
full raster parity. Remaining differences are irreducible cross-framework glyph
metrics, ClearType-versus-Skia antialiasing, native tab borders, scrollbar painting,
and focus/chrome pixels; the pHash values did not improve.

## Verification

- Avalonia focused Legal Notices tests: `14/14` passed.
- WPF route-local authority capture: `4/4` captured and content-gated.
- Avalonia final route-local capture: `4/4` captured and content-gated.
- Route-local comparison: `4` genuine visual mismatches, `0` semantic differences
  (expected comparator exit code `1` for the remaining genuine mismatches).
- WPF and Avalonia harness Release builds: `0` warnings, `0` errors.
