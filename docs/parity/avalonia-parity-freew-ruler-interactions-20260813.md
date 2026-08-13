# FreeW ruler interaction parity — 2026-08-13

## Gap closed

FreeW's WPF ruler supported backed editing while the Avalonia ruler was render-only. Avalonia now
supports the same currently backed ruler operations:

- cycle the new-tab alignment through left, center, right, and decimal;
- click to add a tab stop, drag a tab stop to move it, and drag it outside the strip to remove it;
- drag left, first-line/hanging, and right paragraph indents;
- drag top and bottom page margins with a live preview and the same one-point minimum-content clamp;
- render the current paragraph's indent and tab-stop markers.

The Avalonia host commits paragraph edits through its existing grouped command-bus formatting path
and margin edits through `ApplyPageSettings`, so edits remain undoable and section-aware.

## Shared renderer boundary

`FreeW.App.Presentation.DocumentView.DocumentRulerInteractionPlanner` now owns coordinate/model
conversion, horizontal and vertical hit testing, point snapping, indent planning, tab-stop mutation,
drop-removal policy, and vertical-margin clamping. Both WPF and Avalonia delegate those decisions to
the planner. The renderer-specific code is limited to drawing primitives, pointer capture/cursors, and
calling each host's existing command-bus entry points.

## Verification

- Shared planner tests: 9/9 passed.
- `FreeW.App.Avalonia` Release build: succeeded with 0 warnings and 0 errors.
- `FreeW.App.Host` Release build: succeeded with 0 warnings and 0 errors.
- No UI test lane, application launch, or screenshot capture was run on this machine.

Microsoft Word-authoritative visual comparison remains outside this source/compile slice.
