# FreeX Wave 96 Group/Outline Physical Parity

## Gap Confirmed

FreeX already shared the row/column outline commands and Avalonia had headless tests for
`WorksheetOutlineOverlay` and its `+/-` buttons. The Linux X11 contract nevertheless had no
Group/Outline selector or physical evidence. Its existing Data-tab tour was screenshot-only and
did not prove row selection, Group command routing, the visible outline gutter, collapse/expand, or
restoration of the worksheet values.

## Slice Added

`tools/LinuxInteractiveDocker/run-freex-input-probes.sh` now exposes the focused
`outline-group` selector. It:

1. Seeds three distinct values through the production inline editor.
2. Uses real X11 `Shift+Space` and `Shift+Down` input to select rows 2:4.
3. Uses the production Data ribbon keytip path `Alt+A`, `G`, `G` to Group.
4. Captures the rendered outline gutter and verifies its green bracket/control pixels.
5. Physically clicks the visible row-group toggle to collapse and then expand the group.
6. Reads all three values back through the production formula editor and records the postcondition.

The PowerShell runner requires `outline-group-physical` for both the focused selector and the
default `all` physical lane, and the source test guards the selector, real gestures, visual
evidence, restoration fields, and default-lane dispatch. Parent integration Docker execution
passed the focused selector 1/1 before the default-lane wiring was finalized.

## Remaining Nearby Coverage

This slice covers single-level row and column groups. Nested groups, filtered-range scope,
save/reopen persistence, and WPF-paired screenshots remain separate physical evidence work.
