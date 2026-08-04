# FreeP Zoom Frame Border Width

Date: 2026-08-04

## Functional slice

FreeP now preserves and edits the native Zoom frame line width in `p:zmPr/spPr/a:ln/@w`.
The shared model stores the authored value in EMU, both WPF and Avalonia format dialogs expose
it in points, and the WPF compositor converts it to the corresponding DIP stroke width.
Undo/redo, Summary Zoom tile edits, package write/read, and existing solid-color behavior remain
covered by focused contracts.

## Boundary

This slice intentionally supports positive line width plus the existing solid RGB frame color.
Native dash, gradient, pattern, and line-effect payloads remain preserved in raw XML but are not
yet editable or rendered as distinct styles.

## Verification

- Presentation planner/compositor focused tests: 32/32
- WPF host Zoom contracts: 5/5
- Avalonia Zoom authoring contracts: 3/3
- WPF Release build: 0 warnings, 0 errors
- Avalonia Release build: 0 warnings, 0 errors
