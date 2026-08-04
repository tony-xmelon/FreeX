# Avalonia Parity Wave 138: FreeW Table of Authorities

Date: 2026-08-04

## Scope

This slice targets the paired FreeW WPF/Avalonia Table of Authorities dialog
family at the harness contract: `table-of-authorities.initial`,
`table-of-authorities.populated`, and `table-of-authorities.validation-error`.
The planner, option flow, validation behavior, focus, default/cancel actions,
and accessibility behavior remain unchanged.

## Change

Avalonia now follows the WPF dialog authority locally: 380-DIP runtime width,
22-DIP combo boxes, 18-DIP compact checkboxes, WPF label/control margins,
80-DIP action buttons, and the neutral white three-pixel-radius button surface.
The existing shared Avalonia chrome and shared planner defaults were not
changed.

## Fresh evidence and metrics

All three fresh Avalonia captures were `captured` and passed the full and target
pixel-content gates at 560x600 and 96 DPI. The local WPF harness attempt was
rejected by the same content gate as blank (`0.00%` opaque, `100.00%`
near-black, no meaningful painted bounds), so it was not promoted. The
committed WPF authority metadata remains in the canonical comparison rows.

| Metric | Previous canonical | Fresh Avalonia evidence | Change |
| --- | ---: | ---: | ---: |
| Avalonia painted content ratio | 0.0884673 | 0.0728839 | -0.0155833 |
| Avalonia content bounds | 514x206 at 16,20 | 514x184 at 16,20 | -22 px height |
| Paired changed ratio | 0.1135804 | retained | WPF raster unavailable |
| Paired mean channel delta | 4.5137143 | retained | WPF raster unavailable |

The family remains classified `genuine-visual-mismatch`. The comparison JSON,
Markdown, and HTML rows were limited to this scenario family; the paired diff
numbers are intentionally retained rather than recomputed from a blank WPF
frame.

## Verification

- Focused `FreeW.App.Avalonia.Tests` Table of Authorities parity tests: 2/2 passed.
- Fresh Avalonia harness captures: 3/3 captured and content-gated.
- Fresh WPF harness attempt: rejected as blank and not used as authority.
