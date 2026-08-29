# FreeW Avalonia/WPF Wave 199 Style Evidence

Date: 2026-08-29
Scope: FreeW Style dialog route and the FreeW WPF visual-capture adapter
Authority: fresh FreeW WPF `StyleDialog` captures at the harness logical size
Decision: no Style production correction accepted; capture reliability correction retained

## Selected residual

The selected residual was the paired `style.initial`, `style.populated`, and
`style.validation-error` family. The current-source WPF authority measured a
280 x 389 content region while Avalonia measured 282 x 389. Height and row
cadence were already aligned, so the candidate was limited to Avalonia field
width behavior. This was a conservative, product-owned candidate rather than
a native raster or font substitution.

## Before and candidate evidence

All six captures passed the WPF/Avalonia content gates. The tracked final
recapture uses one WPF manifest for both comparisons. An explicit Avalonia width pin did
not reduce the measured bounds and materially worsened all three target rows,
so it was reverted.

| Scenario | Before changed ratio | Candidate changed ratio | Before mean | Candidate mean | Bounds WPF / Avalonia |
| --- | ---: | ---: | ---: | ---: | --- |
| `style.initial` | 7.6030% | 13.3183% | 6.9487 | 8.5451 | 280x389 / 282x389 |
| `style.populated` | 7.7021% | 13.4134% | 7.1289 | 8.4822 | 280x389 / 282x389 |
| `style.validation-error` | 7.6030% | 13.3183% | 6.9487 | 8.5451 | 280x389 / 282x389 |

The proposed Style production change was rejected because every target gate
failed improvement and the control geometry did not move. No Style or shared
theme production geometry was retained.

The final reverted-source recapture reproduced the baseline metrics exactly
for all three states, with 3/3 Avalonia and 3/3 WPF captures passing content
gates.

## Retained change and boundaries

`freew/tools/FreeW.DialogVisualHarness.Wpf/Program.cs` now polls for a visible
static-prompt window on a 50 ms dispatcher timer, with a 15 second deadline and
cleanup of any owned modal window on timeout. This fixes the race that could
produce an empty WPF authority manifest while preserving the existing dialog
population and capture behavior. A focused source guard covers the retry,
deadline, and cleanup contract.

This wave does not modify the cross-app dashboard, FreeX, FreeP, WPF product
dialogs, or the Avalonia Style dialog. Canonical classification is therefore
unchanged: 291 rows, 141 genuine visual mismatches, 80 passes, and 70
Avalonia extensions.

## Provenance

The machine-readable record is
`freew/docs/parity/evidence/wave199-freew-style-dialog.json`. The exact WPF
authority, final Avalonia capture, rejected candidate capture, comparison JSON
and HTML, full PNGs, target crops, and heatmaps are tracked under
`freew/docs/parity/evidence/wave199-freew-style-dialog-artifacts/` with a
complete SHA-256 manifest.

The capture manifests retain their historical absolute `captureRoot` values
byte-for-byte. Their PNG paths are relative and resolve inside the tracked
bundle; a focused test requires every declared durable path to remain inside
that bundle, verifies traversal rejection, decodes the promoted PNGs, and
independently recomputes the production changed-pixel, mean, percentile, and
heatmap semantics before accepting the recorded metrics. The full inventory
compare reports unrelated uncaptured inventory rows because this wave
intentionally uses a route-local three-state capture; only the three Style rows
above support the decision.
