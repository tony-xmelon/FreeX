# Avalonia parity Wave 33

Date: 2026-07-27

## Scope

Wave 33 advanced one locally reproducible dialog-parity slice in each app:

- FreeX Options > Trust Center now matches WPF control availability, persistence,
  button geometry, diagnostics wrapping, and deferred Settings behavior.
- FreeW Paragraph now matches WPF explicit widow-control-off semantics and keeps
  inline validation visible after applying shared dialog chrome.
- FreeP Insert Hyperlink now more closely matches WPF geometry, radio and field
  chrome, validation occupancy, action buttons, tab order, and result lifecycle.

The generated command inventories remained at zero actionable Avalonia binding
gaps before this wave, so the selected work focused on measured dialog fidelity
and workflow depth rather than adding duplicate command routes.

## Evidence

### FreeX

- Fresh WPF and Avalonia captures are both `744x521`.
- Changed-pixel difference improved from `3.8874%` to `3.6452%`, a `6.23%`
  reduction.
- Focused verification passed: services 36/36, Avalonia parity 4/4, WPF Options
  45/45, and the WPF build completed with zero warnings and errors.
- Detailed evidence:
  `docs/parity/freex-options-trust-center-wave33-20260727.md`.

### FreeW

- Fresh matched evidence covers five Paragraph states.
- The Wave 33 changes are behavioral; measured visual ratios were unchanged:
  `14.9497%` for the main tab, `8.4782%` for Line and Page Breaks, and
  `15.7902%` for validation.
- Focused verification passed: Avalonia 34/34, presentation 29/29, host 67/67,
  and the FreeW build completed with zero warnings and errors.
- Detailed evidence:
  `docs/parity/freew-paragraph-wave33-20260727.md`.

### FreeP

- Fresh WPF and Avalonia captures cover initial, populated, and validation states
  at `406x216`.
- Changed-pixel differences improved from `19.1480%`, `20.6646%`, and
  `21.0922%` to `7.5899%`, `9.0837%`, and `10.3448%`.
- Focused verification passed: Avalonia 7/7, WPF 3/3, planner 18/18, and the
  Avalonia build completed with zero warnings and errors.
- The final paired runner captured 28/28 scenarios; all Hyperlink rows passed,
  while four unrelated existing visual mismatches remain.
- Detailed evidence and 18 checked-in before/after/diff images:
  `docs/parity/freep-hyperlink-dialog-wave33-20260727.md`.

## Residuals

This wave does not establish whole-product or pixel-perfect parity. Remaining
differences include platform text rasterization and native control templates,
the documented FreeW Paragraph visual residuals, four unrelated FreeP dialog
runner mismatches, and other surfaces outside these three slices. The overall
Avalonia parity goal remains active.
