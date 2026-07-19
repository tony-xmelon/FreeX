# FreeP Comb Transition Authoring

## Scope

The imported `p:comb` transition already plays through the shared Blinds family. This slice closes the authoring surface by registering `freep.transition.comb` in the shared transition command planner, WPF and Avalonia ribbon definitions, WPF icon registration, and neutral localization resources.

Comb is the PowerPoint transition that reveals the incoming slide with horizontal or vertical bars. The package-level meaning is documented in [OOXML comb semantics](https://ooxml.info/docs/19/19.5/19.5.30/).

## Evidence

- Presentation command planner: 40/40 compile-first and 40/40 no-build.
- Ribbon definition profiles: 18/18 no-build.
- Localization contracts: 11/11 no-build.
- WPF transition/animation registration: 95/95 no-build.
- Command inventory: 146 total, 140 shared, 0 actionable missing WPF, 0 actionable missing Avalonia.

This is a function and authoring-surface slice; no PowerPoint COM raster export was required. Existing visual transition playback evidence remains covered by the shared Blinds-family tests and prior playback parity record.
