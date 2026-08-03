# Avalonia parity Wave118 FreeW Customize Theme Colors - 2026-08-03

## Scope

This wave targeted FreeW's Design > Colors > Customize Colors dialog. The
shared `CustomizeThemeColorsDialogPlanner` was already authoritative for both
hosts, including the 12-slot order, current-theme defaults, normalization,
custom naming, and invalid-slot validation. Fresh same-size evidence therefore
identified a host realization mismatch rather than a planner or functional gap.

## Delivered

- Avalonia now uses the WPF dialog's 440-DIP width, 190-DIP label column,
  120/200-DIP field minimums, and 72-DIP OK/Cancel buttons.
- The color rows use the measured WPF 29.4-DIP rhythm, the WPF separator before
  `Name` is restored, and the validation status remains hidden until a submit
  error occurs.
- OK and Cancel retain visible text plus explicit default/cancel semantics;
  styling remains in the shared Avalonia dialog chrome. The shared row helper
  gained optional row-height and label-margin parameters so other dialogs keep
  their existing defaults.

## Evidence

The pre-change current-source pair was captured at 560x600 for all three
states: `initial`, `populated`, and `validation-error`. The initial state was
12.9446% changed pixels, mean channel delta 10.0689, luminance similarity
0.862323, pHash distance 4, with semantic differences
`default-button,cancel-button`; Avalonia painted content ended at 372 DIPs
versus WPF's 453 DIPs.

The post-change pair was recaptured at the identical 560x600 dimensions for all
three states. Initial and populated each measured 9.6440% changed pixels,
mean channel delta 7.4631, luminance similarity 0.881309, and pHash distance 1;
validation-error measured 9.6390%, 7.4600, 0.881297, and 1. Semantic
differences are now empty. Avalonia painted content is 452 DIPs high versus
WPF's 453 DIPs.

The canonical generated rows were refreshed in
`docs/parity/freew-dialog-harness/`, including the route inventory, comparison
JSON/Markdown/HTML, and freshness manifest. The comparison remains classified
as `genuine-visual-mismatch`: the remaining delta is toolkit text/control
rasterization and small border/layout rendering differences, not an unhandled
theme-color behavior or shell callback gap.

## Verification

- `DesignDialogParityTests`: 7 passed.
- WPF focused capture: 3 of 3 captured and content-gate valid.
- Avalonia focused capture: 3 of 3 captured and content-gate valid.
- Paired comparison: 3 of 3 theme-color states captured at 560x600.

## Residuals

Residual classification is **genuine visual mismatch**, reduced but not closed.
The dialog's functional parity is covered; remaining pixel variance is
native-versus-Avalonia control and text rasterization plus approximately one
vertical content pixel. Broader adjacent Backstage surfaces remain separate
Wave118 candidates and were not mixed into this bounded change.
