# FreeP Animation Pane Linux X11 Evidence

This slice adds the first genuine physical Linux proof for the FreeP Animation Pane. The family harness passes `FREEP_PHYSICAL_ANIMATION_PANE_SEED=1` to the FreeP application container; the Avalonia app creates one visible text shape and one WPF-authoritative Fade entrance animation immediately before the real pane command is invoked, only for that harness run.

The probe then physically clicks the rendered Advanced Animation command and its flyout item on the real Animations ribbon to open the pane, captures the flyout, visible docked pane, and seeded row, clicks the row's order/name area through X11 pointer input, and uses the same physical route to close and reopen the pane. The manifest row `animation-pane-physical-workflow` requires all five observable transitions: pane open, seeded row visible, row selection changed, pane closed, and pane reopened.

Evidence is retained as full-screen screenshots, a geometry calibration file, pane crops, and `animation-pane-physical-workflow-proof.txt`. The proof checks semantic pane pixels in calibrated header and row rectangles: the brick pane header, unselected row fill, selected row fill, and their absence/presence after close/reopen. Reopen accepts the selected fill because the app preserves the selected animation row across that transition. It does not use generic screen-difference or tooltip/hover changes as a pass condition. This is physical Avalonia/X11 interaction evidence; it is not a PowerPoint COM visual baseline and does not claim exact WPF pixel parity.

The FreeP family contract increases from 23 to 24 rows. Existing slide-pane and key-tip evidence remains unchanged. The seed is intentionally opt-in and does not affect normal FreeP launches or saved presentations.
