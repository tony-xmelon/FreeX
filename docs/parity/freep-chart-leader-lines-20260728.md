# FreeP Chart Leader-Line Rendering - 2026-07-28

The chart option `ShowLeaderLines` already had shared model, DOCX/PPTX round-trip,
undo, and WPF/Avalonia dialog coverage, but the renderer-neutral chart scene did not
consume it. This slice closes that function path for pie and doughnut charts.

When the option is explicitly enabled and labels are outside the slice, the shared
scene now emits two-segment connectors from the slice edge through a short radial
elbow to the label edge. WPF and Avalonia consume the same line list before painting
label text. Disabled, omitted, inside, center, and non-pie routes emit no connectors.

Verification:

- `ChartRenderPlannerTests`: explicit pie opt-in emits two segments per label;
  disabled and column routes emit none.
- `RendererNeutralDedupPlannerTests`: both host canvases consume the shared line list.
- `FreeP.App.Presentation.Tests`: 233 selected Release tests passed.
- `FreeP.App.Rendering.Wpf`: Release build, 0 warnings/errors.
- `FreeP.App.Rendering.Avalonia`: Release build, 0 warnings/errors.
- The WPF host chart test filter exceeded the bounded 120-second run without a result;
  its owned parent process was reaped and the build-server shutdown completed cleanly.
