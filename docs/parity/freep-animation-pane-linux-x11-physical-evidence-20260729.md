# FreeP Animation Pane Linux X11 Evidence

This slice adds the first genuine physical Linux proof for the FreeP Animation Pane. The family harness opts into a deterministic startup seed through `FREEP_PHYSICAL_ANIMATION_PANE_SEED=1`; the Avalonia app creates one visible text shape and one WPF-authoritative Fade entrance animation only for that harness run.

The probe then physically clicks the visible Animation Pane command on the real Animations ribbon to open the pane, captures the visible pane and row, clicks the rendered row through X11 pointer input, and uses the same ribbon command to close and reopen the pane. The manifest row `animation-pane-physical-workflow` requires all five observable transitions: pane open, seeded row visible, row selection changed, pane closed, and pane reopened.

Evidence is retained as full-screen screenshots, a geometry calibration file, pane crops, and `animation-pane-physical-workflow-proof.txt`. This is physical Avalonia/X11 interaction evidence; it is not a PowerPoint COM visual baseline and does not claim exact WPF pixel parity.

The FreeP family contract increases from 23 to 24 rows. Existing slide-pane and key-tip evidence remains unchanged. The seed is intentionally opt-in and does not affect normal FreeP launches or saved presentations.
