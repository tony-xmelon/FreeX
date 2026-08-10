# FreeP Authored ColorPulse and ColorWave Options - 2026-08-10

Newly authored `ChangeColor`, `ColorPulse`, and `ColorWave` emphasis animations now receive a
standard native `p:animClr` behavior when created by the shared animation
command planner. This makes the six Animation Pane theme-color choices
available immediately, matching the already-supported imported-payload path.

The behavior remains editable through the shared mutation and undo route and
round-trips through PPTX save/reopen. Imported native color behavior remains
authoritative and is not replaced by this default.

This is a functional authoring/package slice. It makes no visual playback
baseline claim against PowerPoint.
