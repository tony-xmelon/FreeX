# FreeP Shape Opacity Render Consumption - 2026-07-13

This follow-up completes the no-COM shape transparency slice after the shared
`ThemeAwareColor.Alpha` model and PDF export path landed.

- `SlideCompositor` now carries solid fill and visible outline alpha into the
  renderer-neutral `ResolvedFill.Solid` and `ResolvedOutline.Visible` draw-op
  contracts.
- WPF and Avalonia slide canvases consume those shared alpha values through
  normal ARGB brushes and pens, without renderer-local opacity policy.
- Custom geometry PDF export now splits fill and stroke paths when their alpha
  values differ, so one opacity group no longer incorrectly controls both.

Focused evidence:

- `SlideCompositorTests` verifies fill and outline alpha survive shared
  composition.
- WPF `SlideCanvasTests` verifies semi-transparent shape fill blends over a
  white background.
- Avalonia `SlideCanvasAvaloniaTests` verifies the same shared alpha path
  renders without host-specific policy.
- `PresentationPdfExporterTests` verifies custom geometry fill/stroke opacity
  remains independent.

PowerPoint-authoritative visual baselines remain deferred to a machine with
registered `PowerPoint.Application` COM.
