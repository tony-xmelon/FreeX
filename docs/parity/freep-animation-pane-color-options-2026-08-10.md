# FreeP Animation Pane Color Options

## Scope

Imported PowerPoint `ColorPulse` and `ColorWave` emphasis animations already retained their native `p:animClr` payload and playback identity, but the shared Animation Pane planner treated them as having no editable effect options. `ColorWave` was also omitted from the writer's native color-behavior emission list.

## Change

- `ColorPulse` and `ColorWave` now expose the same six theme-color choices as other native color effects.
- Selecting a color rewrites the preserved `p:to/a:schemeClr` payload through the existing mutation and undo path.
- Writer emission includes preserved `ColorWave` color behavior, so an edited native payload survives save and reopen.

## Verification

- `FreeP.App.Presentation.Tests` Release build: 0 warnings, 0 errors.
- Filtered Animation Pane and animation preset tests: 170/170.
- Both WPF and Avalonia consume the shared planner result; no host-specific behavior was changed.

## Boundary

This is functional/package parity only. Animation-pane UI and playback visual baselines against PowerPoint remain covered by the broader COM-baseline readiness work.
