# Wave161 FreeW Backstage Open visual parity

Date: 2026-08-05

## Scope

This bounded slice rechecked the eligible `backstage-open.open` route using the
current WPF authority and Avalonia realization. Legal Notices and About were
excluded. No all-route harness was run.

## Fresh paired evidence

The route-local WPF capture completed 1/1 and the Avalonia capture completed 1/1;
both images passed the rendered-content gate at 560x600. The filtered comparison
reported one genuine visual mismatch:

| Metric | Fresh Wave161 pair |
| --- | ---: |
| Changed pixels | 36,603 / 336,000 |
| Changed-pixel ratio | 10.89375% |
| Mean absolute channel delta | 9.3069702381 |
| P95 absolute channel delta | 88 |
| Perceptual hash distance | 6 |
| Semantic difference | null |

The paired bounds and route structure remain aligned. The remaining difference is
consistent with cross-toolkit text rasterization and control-template rendering,
not a proved Backstage layout or template discrepancy. A trial Avalonia action-row
alignment change produced byte-identical before/after pixels and was removed.

## Verification

- Focused `BackstageViewTests`: **40/40 passed**.
- Route-local WPF capture: **1/1 captured**.
- Route-local Avalonia capture: **1/1 captured**.
- Route-local comparison: **1 genuine visual mismatch; semantic difference null**.
- No production correction or focused test change was retained because the fresh
  evidence did not prove an actionable structural mismatch.
- No thresholds or classifications were changed.
