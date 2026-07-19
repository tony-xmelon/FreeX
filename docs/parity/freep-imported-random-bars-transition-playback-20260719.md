# FreeP imported Random Bars transition playback

FreeP now plays classic PresentationML `p:randomBar` transitions instead of
falling back to fade. Both hosts use the shared deterministic eight-band order
and the transition planner resolves the horizontal/vertical axis from the
imported direction.

Focused evidence on 2026-07-19:

- Presentation planner/mask contracts: 86/86.
- WPF transition/completeness/source contracts: 119/119.
- Avalonia host source contract: 3/3.
- WPF and Avalonia Release builds: 0 warnings, 0 errors.
