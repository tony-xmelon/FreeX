# FreeP imported Surface3D green topology probe rejected - 2026-07-24

The canonical imported 3-by-3 Surface3D in
`22-chart-baseline-depth.pptx` still has a coupled green-face mismatch after
the accepted blue and orange WPF-only corrections. PowerPoint's exact
`#97BD80` mask contains a small upper component `(737,177)-(787,183)` and a
separate dominant component `(796,177)-(934,221)`, while the current WPF mask
is one oversized connected region `(804,157)-(928,239)`.

The next probe replaced both existing green painter slots together: the
small upper wedge was measured as `(737,177)-(787,183)` and the dominant
right face as `(796,177)-(934,221)`. It preserved the shared logical mesh,
the Avalonia path, and the existing WPF painter order. The focused planner
contract passed `31/31` and the consuming `FreeP.RenderCompare` Release build
completed with `0` warnings and `0` errors.

Fresh WPF scoring against the current PowerPoint reference rejected the
candidate:

- whole slide: `2.4862% -> 2.5570%`;
- baseline was the current accepted orange-face artifact;
- no shared planner or Avalonia change was retained.

The result confirms that matching the two exact-color components is still not
enough. The remaining defect is coupled 3-D topology/material ownership at
shared projected edges, not an independent green polygon. Product code was
reverted; this document is the retained negative evidence for a future probe.
