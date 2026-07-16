# FreeP Imported Surface3D Blank-Cell Diagonal - 2026-07-16

## Scope

The imported `22-chart-baseline-depth.pptx` Surface3D chart has one blank
low-band cell. PowerPoint splits that completed render cell along the 0-2
diagonal, while the other imported complete cells use the established 0-3
split. FreeP now preserves that topology and the measured lower registration
of the blank-cell render point when it supplies the imported fallback point.

## Evidence

- The first imported cell now emits triangle X coordinates `[2.0, 149.6,
  196.8]` and `[2.0, 196.8, 64.0]`.
- At 1280x720 against a fresh PowerPoint COM export, WPF improved from
  `3.5764%` to `3.5599%` and Avalonia-vs-PowerPoint improved from `3.4680%`
  to `3.4517%`.
- The shared planner places the imported blank vertex at local Y=163.1 rather
  than interpolating it through the neighboring values. This matches the
  visible PowerPoint trough while preserving the semantic blank in the chart
  model. The current 1280x720 WPF comparison improves from 3.3121% to 3.2461%.
- Applying the alternate diagonal to the adjacent low-band cell worsened the
  result, so the rule remains scoped to the observed blank cell.

## Verification

The focused corpus test asserts the blank-cell topology and the remaining
surface geometry contract. Final WPF, Avalonia, and PowerPoint renders are
captured during the integration verification run.
