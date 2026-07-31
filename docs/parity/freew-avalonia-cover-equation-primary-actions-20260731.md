# FreeW Avalonia cover page and equation primary actions

## Resolved behavior

The WPF Insert ribbon exposes split-button primary actions for Cover Page and
Equation. Clicking the button face inserts the default cover page or default
editable equation; the adjacent menu selects a specific preset.

Avalonia exposed the same command ids and working preset menus, but registered
both primary actions as no-ops. The shared command ids now perform the same
default insertions as WPF:

- `freew.cover-page` inserts `CoverPagePreset.Default`.
- `freew.equation` inserts the default editable equation.

The preset commands and menu shape are unchanged.

## Verification

- Focused primary-action tests: 3/3 passed.
- Insert-depth and command-registry lane: 102/102 passed.
- Tests assert the resulting document model, including the cover-page title
  paragraph and inserted equation run, rather than registration alone.

No Word COM export is required for this command/model behavior slice.
