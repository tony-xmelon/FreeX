# Avalonia Parity Wave125: FreeW Legal Notices

Date: 2026-08-03  
Scope: FreeW Legal Notices, four long-document tabs  
Decision: documentation-only closeout; no product source change retained.

## Diagnosis

`SharedLegalNoticesDialog` (WPF) and `AvaloniaLegalNoticesDialog` already use the shared `LegalNoticesDialogMetrics`. The paired captures preserve the same tab behavior, notice text, selection/scrolling surface, and automation state. The remaining mismatch is concentrated in text rasterization and the native text/template registration; content bounds differ by one pixel (`y=19` WPF versus `y=20` Avalonia, with a one-pixel width/height difference).

The WPF shell requests ClearType through its platform text stack. Avalonia's available rendering modes do not expose an equivalent ClearType mode, so the shared chrome and metrics remain unchanged. No other direct Avalonia consumer of the legal-notices dialog component was found; shared dialog chrome was not changed.

## Rejected probes

The canonical pre-probe values were:

| Tab | Before ratio | Before mean | Before p95 | Before pHash | Semantic difference |
| --- | ---: | ---: | ---: | ---: | --- |
| legal-notices | 17.7898% | 18.5351 | 157 | 2 | none |
| privacy-notice | 16.4640% | 18.4793 | 174 | 0 | none |
| third-party-notices | 17.6137% | 19.1270 | 168 | 3 | none |
| third-party-license-texts | 17.9728% | 19.9747 | 180 | 6 | none |

The SubpixelAntialias candidate was rejected because it regressed every measured tab. The supplied measurements were:

| Tab | Candidate ratio | Candidate mean | Ratio delta | Mean delta |
| --- | ---: | ---: | ---: | ---: |
| legal-notices | 18.0078% | 18.7302 | +0.2180 pp | +0.1951 |
| privacy-notice | 16.6820% | 18.6744 | +0.2180 pp | +0.1951 |
| third-party-notices | 17.8317% | 19.1904 | +0.2180 pp | +0.0634 |
| third-party-license-texts | 18.1909% | 20.0279 | +0.2181 pp | +0.0532 |

p95 and pHash did not improve: the candidate remained `157/2`, `174/0`, `168/3`, and `180/6` respectively. Focused geometry/font probes (`UseLayoutRounding`, strong text hinting, and baseline alignment) were also non-improving; no candidate improved all four tabs. All probes were reverted.

## Verification

- Fresh WPF capture: 190/190 scenarios.
- Fresh Avalonia capture: all four requested tab scenarios, 4/4.
- Focused Avalonia legal-notices visual tests: 12/12 passed.
- Focused shared metrics tests: 1/1 passed.
- Release builds for the shared Avalonia shell and Avalonia harness: succeeded with 0 warnings and 0 errors.
- Comparison thresholds and classifications were not changed.

Residuals are the platform text rasterization/template differences and the one-pixel content registration. The source remains at the pre-probe baseline so this lane introduces no visual or behavioral regression.
