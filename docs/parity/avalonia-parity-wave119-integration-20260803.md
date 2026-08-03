# Avalonia/WPF Parity Wave 119 Integration

Date: 2026-08-03

## Scope

Wave 119 delivered one bounded parity slice for each app. The three agent
commits were reviewed and integrated before parent-owned verification.

## Delivered

- **FreeX Page Setup:** the Avalonia Margins tab now exposes distinct Left,
  Right, Top, Bottom, Header, and Footer fields, matching the WPF structure.
  The shared planner composes the four page-margin values and owns the field
  automation identifiers. Validation and focus now target the individual
  fields. The parity workbook fixture also seeds the same orientation, paper,
  scale, order, print area, repeat ranges, and margin values for both hosts.
- **FreeW Customize Theme Fonts:** WPF and Avalonia now consume shared planner
  geometry for dialog width, labels, fields, separator, row rhythm, and action
  buttons. The Avalonia dialog restores default/cancel semantics. Across all
  three captured states, changed pixels improved from about `5.6%` to about
  `3.1%`, and semantic differences are empty.
- **FreeP SmartArt `/layout/default`:** the exact audited five-slot,
  three-over-two cache in `14-smartart-live.pptx` is admitted to shared live
  layout on both renderers. The fifth empty authoring slot is preserved.
  Geometry, text, count, and effect near misses remain on the cached path.

## Integration Verification

Parent-owned focused verification passed:

- FreeX Page Setup planner: 15 passed.
- FreeX parity workbook fixture: 4 passed.
- FreeX Avalonia source contract: 1 passed.
- FreeX WPF Page Setup contract: 33 passed.
- FreeW shared planner: 11 passed.
- FreeW Avalonia dialog parity: 9 passed.
- FreeW WPF source contract: 2 passed.
- FreeP host default-list boundary: 5 passed.
- FreeP presentation default-list behavior: 2 passed.

The generated cross-app dashboard was regenerated and remained byte-for-byte
current. Generated-document checks and repository preflight passed. Both
`FreeX.slnx` and `FreeX.DefaultTests.slnx` built in Release with zero warnings
and zero errors. The default non-UI suite completed with 36,185 total tests:
36,051 passed, 134 skipped, and zero failed.

## Honest Residuals

- The bounded FreeX Linux Page Setup recapture stalled before producing new
  Avalonia artifacts. The owned container was stopped without touching other
  sessions. Functional structure and deterministic fixture state are covered,
  but fresh paired pixels remain outstanding.
- FreeW retains native toolkit text/control rasterization differences and a
  small one-to-two-pixel content-bound residual.
- FreeP admits only the exact audited `/layout/default` signature. It does not
  claim broad default-layout or PowerPoint pixel parity.

Next candidates are a fresh bounded FreeX Page Setup capture plus Format Cells
Alignment, the next current FreeW dialog residual, and another package-proven
FreeP layout/effect boundary.
