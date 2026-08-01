# FreeP OMML Paragraph Binary Breaks - 2026-08-01

This slice adds shared FreeP support for Office Math paragraph binary-operator
break policies. The parser accepts the standard `m:mathPr` location and the
`m:oMathParaPr` location found in some authored payloads.

## Coverage

- `m:brkBin` is preserved as `before`, `after`, or `repeat` on
  `MathNode.MathParagraph`, defaulting to `before`.
- `m:brkBinSub` is preserved as `--`, `+-`, or `-+`, defaulting to `--`.
- When a paragraph width is available, the shared layout engine wraps top-level
  binary operators using the selected policy.
- Repeated subtraction signs use the selected plus/minus pair before and after
  the break.
- WPF and Avalonia continue to consume the same `MathBox` and
  `MathBoxRenderPlanner` output; no host-specific math policy was added.

## Verification

- `FreeP.App.Presentation.Tests` focused OMML parser and math-layout run:
  254 passed.
- Coverage includes defaults, all supported policy values, the standard
  `m:mathPr` container, before/after wrapping, repeat wrapping, and `+-`
  subtraction repetition.

## Remaining

This is shared structural/render-plan evidence. It does not claim exact
PowerPoint line-breaking heuristics, OfficeMath spacing-table fidelity, or
PowerPoint-authoritative raster baselines. The runtime compositor currently
does not supply an explicit display-equation paragraph width for every text
frame, so the new wrapping policy is applied wherever the shared layout caller
provides one.
