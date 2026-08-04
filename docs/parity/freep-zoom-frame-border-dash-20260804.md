# FreeP Zoom Frame Dash Pattern

Date: 2026-08-04

## Functional slice

FreeP now preserves and edits the native Zoom frame line dash in `p:zmPr/spPr/a:ln/a:prstDash`.
The shared model maps the supported PowerPoint presets, WPF and Avalonia expose a border-dash
selector, and the shared WPF compositor resolves the authored pattern into `OutlineDash`.
Summary Zoom tile edits use the same command path.

An absent dash remains the native solid default. Unknown native tokens remain in the verbatim raw
XML rather than being guessed into a different pattern.

## Verification

- Presentation planner/compositor focused tests: 36/36
- WPF host Zoom contracts: 5/5
- Avalonia Zoom authoring contracts: 3/3
- Core Model, Core IO, Presentation, WPF, and Avalonia Release builds: 0 warnings, 0 errors
