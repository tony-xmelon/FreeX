# FreeP responsive chrome refresh — Wave 221 (2026-08-25)

The established responsive Chrome matrix was stale after the FreeP Slide Master host integration because both `MainWindow` implementations are part of its source-freshness contract.

The matrix has now been recaptured using its supported scenario-isolated route:

- 8 standard top-level tabs: Home, Insert, Design, Transitions, Animations, Slide Show, Review, and View.
- 4 widths: 1280, 1100, 900, and 750 DIPs.
- Both WPF and Avalonia, with client and full-window artifacts for every route.
- 64/64 captures completed; `Capture-FreePResponsiveChrome.ps1 -Check` and `Test-FreePResponsiveChromeEvidence.ps1` both pass.

Visual review of the 1280-DIP View captures confirms that **Slide Master** is present in the Presentation Views group in both hosts alongside Normal, Outline View, Slide Sorter, Notes Page, and Reading View. This refresh validates normal-ribbon discoverability and responsive layout only. It does not claim coverage of the active Slide Master canvas/navigation pane; that is the next evidence scenario to add to the full-window harness.

Ink/Draw behavior and map-chart fidelity remain excluded from this parity stream under [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
