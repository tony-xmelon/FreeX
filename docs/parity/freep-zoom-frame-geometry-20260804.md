# FreeP Zoom Frame Geometry

## Scope

FreeP now exposes the native Zoom frame geometry already carried by
`zmPr/spPr/a:prstGeom` for the three frame shapes supported by both desktop
renderers: rectangle (`rect`), rounded rectangle (`roundRect`), and ellipse.

The shared Zoom Format dialog writes the selected geometry through the command
bus, including undo/redo. Summary Zoom tile-local `zmPr` properties use the
same persistence path. The reader projects the native preset into
`ZoomObjectProperties`, while unsupported presets remain preserved in raw XML
and are not presented as editable choices.

The shared compositor forwards the geometry to the existing WPF and Avalonia
picture-frame clipping paths. This is a functional authoring/persistence
slice, not a claim of complete PowerPoint Zoom Style parity: gradients,
effects, and additional preset geometries remain outside this contract.

## Gates

- Presentation planner/compositor focused lane: 174/174
- WPF Zoom authoring and round-trip lane: 5/5
- Avalonia Zoom authoring lane: 4/4
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors
