# Avalonia/WPF Parity Wave 118 Integration

Date: 2026-08-03

## Scope

Wave 118 delivered one bounded, evidence-backed parity slice for each app. All
three changes were reviewed in the integration worktree before repository-wide
verification. Two initial submissions were rejected during review: the first
FreeX WPF capture clipped the authority image, and the first FreeP regression
did not causally exercise the new admission boundary. Both were corrected
before integration.

## Delivered

- **FreeX Zoom:** shared the `300x240` geometry contract, rebuilt the Avalonia
  dialog with the compact dialog chrome, and corrected WPF client-frame capture
  sizing to include content margins. The accepted WPF and Avalonia captures are
  complete at `300x240@96 DPI`; Zoom's generated triage score improved from
  `0.092952` to `0.035278`, with a `2.9664%` mean pixel difference. Page Setup
  is now the highest FreeX dialog triage candidate at `0.09103`.
- **FreeW Customize Theme Colors:** aligned the Avalonia dimensions, row rhythm,
  separator, action buttons, and validation state with WPF. Across three
  `560x600` states, changed pixels improved from `12.9446%` to `9.6440%`, mean
  channel delta from `10.0689` to `7.4631`, and pHash distance from `4` to `1`;
  semantic differences are empty.
- **FreeP cycle2 effects boundary:** kept effect-bearing SmartArt caches on the
  authoritative cached path while preserving the proven effect-free five-node
  cycle2 live path. Tests now use an otherwise-admissible ellipse-and-arrow
  cache and prove both positive admission and effect-bearing rejection through
  composition and save/reopen.

## Integration Verification

Focused parent-owned verification passed 37 tests with zero failures:

- FreeX Zoom planner: 6 passed.
- FreeX WPF Zoom dialog and capture: 10 passed.
- FreeX Avalonia Zoom source contract: 2 passed.
- FreeW Avalonia design-dialog parity: 7 passed.
- FreeP host cycle2/package boundary: 10 passed.
- FreeP presentation cycle2 behavior: 2 passed.

Generated-document, repository-preflight, full Release build, and default-suite
results are recorded by the final integration commit and push gate.

## Honest Residuals

- FreeX Zoom retains small platform text, radio, and border rasterization
  differences; it has no clipping or semantic residual.
- FreeW Customize Theme Colors remains a genuine visual mismatch because of
  native-versus-Avalonia text and control rasterization, despite functional and
  semantic parity.
- FreeP does not yet project SmartArt effects into the live cycle2 planner;
  effect-bearing caches intentionally remain on the lossless cached path.

Next evidence-backed candidates are FreeX Page Setup or Format Cells Alignment,
FreeW Customize Theme Fonts or an adjacent current visual residual, and FreeP
shared effect projection or the next proven layout/chart/media boundary.
