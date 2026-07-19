# FreeP Advanced Transition Authoring

## Scope

Imported `Gallery`, `Conveyor`, `Pan`, and `Window` transitions already had
package read/write mappings and shared slideshow playback fallback behavior,
but they were absent from the authoring surface. This slice adds typed
`SetKind` command plans, shared WPF/Avalonia transition-ribbon controls, WPF
icon registrations, and neutral localized labels/key tips for all four kinds.

## Evidence

- Presentation transition planner: 44/44 compile-first and 44/44 no-build.
- Ribbon definition profiles: 18/18 compile-first and 18/18 no-build.
- Localization contracts: 11/11 compile-first and 11/11 no-build.
- WPF transition/animation registration: 99/99 compile-first and 99/99 no-build.
- Command inventory: 150 total, 144 shared, 0 actionable missing WPF, 0 actionable missing Avalonia.

The four commands preserve the existing shared transition model and playback
semantics; this is an authoring/function slice and does not claim a new
PowerPoint raster comparison.
