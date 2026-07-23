# FreeP imported Surface3D blue face ownership - 2026-07-23

The imported `22-chart-baseline-depth.pptx` Surface3D has a canonical 3-by-3,
vary-colors mesh. Its low-left blue face was painted before the neighboring
orange face in the WPF render-only facet list, so the orange face clipped the
blue face at their shared fold. PowerPoint owns the blue fold pixels instead.

The planner now adds a WPF-only replacement for that face when all of the
following match:

- imported `Surface3D`, `varyColors`, three series and three categories;
- values `10/null/18`, `18/22/26`, and `28/24/35`;
- the canonical imported plot frame `360x189` DIP.

The replacement uses the measured PowerPoint polygon and is appended after the
neighboring facets. Shared `RenderFacets` and Avalonia rendering are unchanged.
Tall-frame and authored-`view3D` charts do not enter this path.

Fresh `--avalonia-compare` evidence at 1280x720:

- target WPF whole-slide mean diff: `2.5856% -> 2.4905%`;
- target surface ROI: `6.0167% -> 4.8334%`;
- target blue-face ROI: `9.0277% -> 4.8324%`;
- exact blue pixels: WPF `2761`, bbox `(602,216)-(748,259)` -> `3692`,
  bbox `(604,227)-(763,271)`; PowerPoint has `3881`, bbox
  `(601,226)-(765,272)`;
- Avalonia target PNG: byte-stable;
- tall-frame WPF/Avalonia control: byte-stable, WPF `2.8158%`;
- authored-`view3D` control: WPF `2.9318%`;
- `24-run-baseline-wrap` control: `0.6948%`, unchanged.

Focused `ChartBaselineCorpusTests`: `30/30`. The consuming
`FreeP.RenderCompare` Release build completed with `0` warnings and `0`
errors.
