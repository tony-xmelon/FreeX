# Avalonia Parity Wave 185 Integration

Date: 2026-08-23

Wave 185 completes three app slices and brings the cumulative processed count to
**555**.

## FreeX

- Added a fail-closed physical Linux X11 AutoFilter sort/save/reopen probe.
- Passed 1/1 with ascending order `East,North,South,West`, the same order after
  reopening, and descending order `West,South,North,East`.
- The saved workbook package recorded the expected ascending and descending
  `sortState` signatures.
- Focused verification passed: 20 Avalonia tests, 8 presentation workflow tests,
  and the production Avalonia Release build.

## FreeW

- Scoped grayscale-like antialiasing to the Avalonia Page Setup dialog family.
- Six-state changed pixels improved from 167,686 to 165,237.
- Average changed ratio improved from 8.317758% to 8.196280%; average mean channel
  delta improved from 5.3475413 to 5.3423633.
- All six states remain genuine visual mismatches under unchanged thresholds.

## FreeP

- Narrowly recalibrated fixed-size, single-column, no-autofit, non-bullet 18pt
  Aptos body text on the Avalonia host.
- Slide 02 Avalonia/Office improved from 3.0055% to 2.5360%; WPF/Avalonia improved
  from 3.0952% to 2.9091%, with WPF/Office unchanged at 3.0587%.
- Corpus averages are now 1.0593% WPF/Office, 1.0271% Avalonia/Office, and 0.6248%
  WPF/Avalonia.
- Focused verification passed: 2 host-policy tests, 56 bullet/autofit tests, and
  the render-compare Release build.

## Remaining

- FreeX: physical text, number, date, color, and multi-column AutoFilter criteria.
- FreeW: 94 of 99 current Word-baseline comparisons remain outside tolerance;
  dialog/control/font raster residuals remain the largest visual tail.
- FreeP: complex SmartArt, text, and 3-D rendering residuals.

