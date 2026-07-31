# FreeW Avalonia View Command State

Avalonia View commands now report live checked state instead of acting as stateless buttons:

- Print Layout, Web Layout, and Draft are mutually exclusive and follow the active shell view.
- Navigation Pane, Reviewing Pane, and Reveal Formatting follow actual pane visibility.
- compact compatibility ids reuse the canonical stateful command instances.

`MainWindow` supplies state queries that account for Outline and Page Edit overlays, so Print Layout is
not incorrectly reported as active while one of those alternate surfaces owns the workspace. Pane state
queries read the live controls, which also captures keyboard and shell changes made outside the ribbon.
Detached registries retain a direct `DocumentView.ViewMode` fallback for the three normal view modes.

Focused `ViewTabDepthTests` cover command execution, exactly one active normal view, external state
changes, pane visibility, and legacy aliases. Result: 25 passed, 0 failed.
