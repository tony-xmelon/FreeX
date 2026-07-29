# FreeX Avalonia parity Wave 61: multi-area formula editing

## Scope

This slice closes the deep multi-area formula-edit residual after Wave 56's
keyboard-created append path. It edits an already-authored quoted two-area
formula: `F5` is retained, `H7` is changed through a reverse caret selection,
and a plain point click replaces that existing area with `J7`.

WPF preserves the live span through text and caret changes. Avalonia previously
cleared it during the formula-box text path and could also clear it while
reverse-selection properties were reported independently, causing the next
point click to insert a third reference.

## Implementation

- Avalonia no longer unconditionally clears the formula reference span on
  formula-box text changes.
- Reverse selections retain the live span while independent selection property
  notifications settle.
- Ordinary point replacement recovers a trailing authored reference through
  the shared quoted-reference parser when transient input loses tracking.
- The managed test asserts exact formula text, saved formula, result, and the
  selected replacement area.

## Verification

- Avalonia R53 formula-point suite: **9/9 passed**.
- Physical Linux/X11 selector `formula-multi-area-edit`: **1/1 passed**.
- Exact saved formula:
  `=SUM('Revenue Data'!F5,'Revenue Data'!J7)`.
- Exact calculated result: `30`.
- Selection before readback: `Revenue Data!J7`.

Retained evidence:

- `artifacts/linux-interactive/freex/sessions/20260729T224800763Z/x11-validation/`
- `artifacts/linux-interactive/freex/interaction-validation/20260729T224733Z/`

## Residuals

The selector intentionally does not duplicate the Wave 56 F8/Shift+F8 append
workflow. Broader formula grammar, drag-edit, and non-quoted reference variants
remain outside this bounded slice.
