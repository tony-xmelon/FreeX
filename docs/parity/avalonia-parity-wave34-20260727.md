# Avalonia parity Wave 34

Date: 2026-07-27

## Scope

Wave 34 advanced one functional-first parity slice in each app:

- FreeX Options > Customize Ribbon now enables Import/Export and routes it
  through an owned, localized deferred-command dialog with keyboard coverage.
- FreeW Legal Notices now uses neutral shared geometry metrics, with the
  remaining Avalonia template compensation isolated in the Avalonia shell.
- FreeP slide-pane thumbnails are display-only in Avalonia, matching WPF input
  ownership so selection, drag, keyboard, and context-menu input stays on the
  surrounding slide item.

The concurrently merged Options iteration-validation fix was also verified:
disabled iterative calculation no longer validates empty disabled bounds, while
enabled calculation continues to reject invalid values in both hosts.

## Evidence

### FreeX

- Fresh WPF and Avalonia Customize Ribbon captures are both `744x521`.
- Changed-pixel difference improved from `2.2170%` to `1.6662%`, a `24.84%`
  reduction, with zero hard comparison regressions.
- Merged verification passed: Avalonia 6/6 and WPF Options 46/46.
- The formerly blocking disabled-iteration test passed, along with 13/13 shared
  calculation parser/command tests and 6/6 Avalonia calculation-options tests.
- Detailed evidence:
  `docs/parity/freex-options-customize-ribbon-wave34-20260727.md`.

### FreeW

- All five Legal Notices tab states were captured in both hosts with no capture
  failures.
- The change removes six Avalonia-named values from shared metrics and keeps
  the required `+6` text inset and `+3` intro spacing as documented Avalonia
  template compensation.
- Merged verification passed: WPF 9/9, Avalonia 2/2, and shared metrics 1/1.
- Visual ratios remained effectively unchanged, ranging from `10.112%` to
  `21.509%`; the slice improves ownership and deduplication, not pixel fidelity.
- Detailed evidence:
  `docs/parity/freew-legal-notices-wave34-20260727.md`.

### FreeP

- Avalonia thumbnail canvases no longer accept hit testing or keyboard focus.
- Merged verification passed: Avalonia 12/12, WPF 23/23, and presentation
  policy 52/52. The Avalonia lane was rerun after the final upstream merge.
- Whole-window evidence remained 33/33 paired with no limitations or
  duplicates. Focused seeded evidence remained 28/28 captured, with four
  unrelated existing visual mismatches.
- The focused slide-pane raster metrics were unchanged because this was an
  input-routing correction.
- Detailed evidence:
  `docs/parity/freep-slide-pane-wave34-20260727.md`.

## Residuals

This wave does not establish whole-product or pixel-perfect parity. FreeW Legal
Notices retains five genuine visual mismatches and four action-button-order
semantic residuals. FreeP still has richer WPF thumbnail rendering and four
unrelated focused-run visual mismatches. Remaining platform text rasterization,
native templates, and surfaces outside these slices continue in later waves.
The overall Avalonia parity goal remains active.
