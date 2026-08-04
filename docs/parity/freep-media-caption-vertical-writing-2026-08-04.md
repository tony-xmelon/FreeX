# FreeP Media Caption Vertical Writing

## Scope

WebVTT cue settings now preserve `vertical:rl` and `vertical:lr` through the
shared transcript descriptor and authored WebVTT writer. The shared placement
planner swaps the cue's physical dimensions, maps `position` along the vertical
axis, maps `line` to the writing column, and supplies the corresponding quarter
turn. WPF and Avalonia apply that same rotation to their native caption text
surface; ordinary horizontal cues and SRT/TTML tracks remain unchanged.

Invalid or unknown vertical values continue to use the horizontal default. This
is a functional caption playback and package-authoring slice, not a PowerPoint
visual-baseline claim.

## Verification

- Presentation transcript planner: 14/14 focused tests.
- WPF media playback adapter: 2/2 focused vertical/placement tests.
- Avalonia media playback adapter: 1/1 focused vertical test.
- Full FreeP Release solution build is required before integration.
