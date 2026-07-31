# FreeP functional depth Wave 82

## Edit Points state parity

The WPF host previously allowed its initial canvas setup to overwrite the
gesture handler's default-on Edit Points mode with the canvas property's
uninitialized false value. It also recreated the WPF gesture handler during
file/editor rebinds without preserving the selected mode. Avalonia reads the
live canvas mode and retains it when attaching its gesture handler.

The shared `PresentationEditPointsModePlanner` now computes the toggle from
live mode state. WPF and Avalonia stateful ribbon commands use that plan, WPF
initial setup leaves the default-on mode intact, and WPF
`SlideCanvas.AttachEditing` preserves the existing mode when replacing the
gesture handler. This keeps the checked state, hit behavior, and rebind
lifecycle aligned across hosts.

## Verification

- Shared planner: `PresentationEditPointsModePlannerTests`.
- WPF: `SlideCanvas_ReattachEditing_PreservesEditPointsMode` and
  `WpfEditPointsRibbonState_FollowsSharedModePlannerAndCanvas`.
- Avalonia: `Ribbon_edit_points_toggle_uses_shared_mode_planner_and_live_canvas_state`.

This slice excludes the incoming inline OLE and in-canvas rich-text editor
changes, motion-path authoring, and visual-only PowerPoint or physical-device
baselines.
