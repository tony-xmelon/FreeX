# Wave 207 — FreeP Reading View

## Scope

This slice adds the missing PowerPoint-style Reading View command to FreeP's
View ribbon and wires it to both native hosts. It has no external dependency.
Ink/Draw behavior and map-chart fidelity remain outside the active parity
scope.

## Change

Reading View opens the current slide in FreeP's existing slide-show runtime as
a resizable, non-editing browse window. The shared launch plan now carries a
transient browse-window override, so using Reading View does not alter the
presentation's persisted show type or slideshow settings. WPF and Avalonia use
their existing browse-window chrome and playback controls.

## Evidence

The fresh WPF View-ribbon capture is retained at
`artifacts/wave207-freep-reading-view/view-ribbon.png`; it shows Normal,
Outline View, Slide Sorter, Notes Page, and Reading View together in the
Presentation Views group. The generated command inventory now reports 710
commands, all present in both WPF and Avalonia profiles.

## Verification

- `FreeP.App.Presentation` Release build: passed, zero warnings/errors.
- `FreeP.App.Host` Release build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` Release build: passed, zero warnings/errors.
- Focused ribbon, runtime, and launch-coordinator suite: 63 passed, 0 failed.
- `Generate-FreePCommandParityInventory.ps1` and `-Check`: passed.
