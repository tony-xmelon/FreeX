# Avalonia parity Wave 32

Date: 2026-07-27

## Scope

Wave 32 advanced one measured Avalonia visual-parity slice in each app:

- FreeX Error Checking now uses the same two-issue fixture on both hosts and
  constrains Avalonia content to the WPF client rectangle.
- FreeW Page Setup now follows the WPF width, tab pane, field columns, footer
  placement, and rendered-button semantics.
- FreeP Reading Order now reserves the WPF-equivalent scrollbar gutter and
  matches the action-button band without changing the WPF authority.

## Evidence

### FreeX

- Fresh WPF and Linux captures both contain the exact two-issue fixture.
- Mean pixel difference improved from 4.3299% to 2.9191%.
- Focused tests passed: planner 3/3, WPF source/fixture 9/9, Avalonia 1/1.
- Detailed evidence:
  `docs/parity/freex-error-checking-wave32-20260727.md`.

### FreeW

- Fresh WPF and Avalonia captures cover initial, populated, and validation
  states at the same 560x600 frame.
- All three states now have matching semantics and nearly identical painted
  bounds; changed-pixel ratios are 13.41%, 13.41%, and 13.51%.
- Focused tests passed: Page Setup/shared chrome 37/37 and harness semantics
  5/5.
- Detailed evidence:
  `docs/parity/freew-page-setup-wave32-20260727.md`.

### FreeP

- Fresh paired evidence captured 28/28 scenarios at 1280x760.
- Reading Order improved from 18.60% / mean 15.40 to 17.18% / mean 13.33.
- The rejected no-spacing variant regressed to 20.00% / mean 17.06 and was
  not integrated.
- Focused source guards passed 3/3; Avalonia and WPF builds completed with
  zero warnings and zero errors.
- Detailed evidence:
  `docs/parity/freep-reading-order-wave32-20260727.md`.

## Residuals

These slices improve measured parity but do not establish whole-product or
pixel-perfect parity. Remaining differences include framework-native control
templates, font rasterization, theme rendering, and unrelated FreeP shell
context. The overall Avalonia parity goal remains active.
