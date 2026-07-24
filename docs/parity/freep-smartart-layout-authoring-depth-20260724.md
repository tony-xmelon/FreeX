# FreeP SmartArt Layout Authoring Depth - 2026-07-24

This slice connects the specialized SmartArt geometry already implemented by the shared
`SmartArtLayoutEngine` to real authoring commands in both FreeP hosts.

## Added authoring routes

- Alternating Process
- Arrow Ribbon
- Circle Process
- Funnel Process
- Vertical Process
- Descending Block List
- Radial Venn
- Target List
- Stacked Venn

Each command updates the native `dgm:layoutDef/@uniqueId`, the shared `SmartArtData`
family/layout state, clears stale fallback shapes, and is committed through the existing
editing-session command bus so undo/redo remains one semantic operation.

## Verification

- Presentation planner: 50/50 focused tests.
- WPF SmartArt/package tests: 126/126.
- Avalonia SmartArt command-route tests: 2/2.
- Ribbon profile/key-tip tests: 22/22.
- Localization tests: 11/11.
- Generated command inventory: 223 total, 221 shared, zero actionable host gaps.

This is a function/package slice. It does not claim PowerPoint-COM visual equivalence for
the new layouts; that requires the matching PowerPoint baseline corpus.
