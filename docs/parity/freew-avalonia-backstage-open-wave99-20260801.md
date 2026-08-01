# FreeW Avalonia Backstage Open visual parity Wave 99

Date: 2026-08-01

## Scope

This slice targets the highest-impact remaining paired FreeW row from the current
Backstage evidence: `backstage-open.open`. Wave 94 measured 18.991% changed
pixels and a 16.754 mean absolute channel delta for the 560x600 WPF-authority
pair.

## Change

The Avalonia Open pane now uses a 22-DIP tab header, matching the measured WPF
default header footprint. The previous 24-DIP route header placed the first
recent-file row about two pixels low and compounded the vertical registration
error through the visible recent-file list. The adjustment is scoped to the Open
pane's existing shared classic-tab chrome; content width, tab ownership, search
metrics, scrolling, callbacks, and action semantics are unchanged.

## Fresh paired evidence

Evidence root: `C:\Users\anton\AppData\Local\Temp\freex-wave99-backstage-open`

| Metric | Wave 94 baseline | Wave 99 after | Change |
| --- | ---: | ---: | ---: |
| Changed pixels | 63,809 | 61,061 | -2,748 |
| Changed-pixel ratio | 18.991% | 18.173% | -0.818 pp |
| Mean absolute channel delta | 16.754 | 15.781 | -0.973 |
| pHash distance | 9 | 12 | +3 |

Both fresh captures are 560x600, pass their content gates, and retain the
`genuine-visual-mismatch` classification. The pHash increase is retained as a
residual signal; the accepted improvement is based on the changed-pixel and
mean-delta measures, which both improved after the geometry correction.

## Verification

- Focused `BackstageViewTests`: **35/35 passed**.
- WPF authority capture: **1/1 captured**.
- Avalonia capture: **1/1 captured**.
- Paired comparison: **1/1 captured**, expected comparator exit code 1 because
  the row remains a genuine visual mismatch.

Commands used the Release configuration, no restore after the focused restore,
foreground execution, disabled build servers, single-node MSBuild, and no
machine-wide process termination or build-server shutdown.

## Residuals

The pair still differs in Skia versus WPF text rasterization, native tab and
scrollbar templates, and the intentionally fixed viewport's clipping of long
recent-file paths. The route remains a visual mismatch and no threshold or
comparison behavior was changed.
