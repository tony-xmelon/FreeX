# FreeX Formula Pointing Parity: Wave 55

This slice closes the modifier-aware whole-row/whole-column formula-pointing gap between the WPF and Avalonia worksheet hosts.

- Cell Ctrl-click in WPF and Ctrl/Meta-click in Avalonia already append disjoint areas through `FormulaRangeEntryPlanner`.
- Header Ctrl-click now uses that same append path for whole rows and columns before pending formula edits are committed.
- A1 references use Excel shorthand (`B:B`, `3:3`), including quoted cross-sheet qualifiers; R1C1 keeps the explicit full extent.
- The planner returns the newly appended span so subsequent point-mode drag edits replace only that area.

Covered by shared planner tests, WPF source-routing guards, and an Avalonia headless formula-edit test. Remaining formula-pointing work is keyboard-driven multi-area editing beyond header/cell modifier clicks, including 3D references and modifier-aware multi-area expansion from keyboard selection commands.
