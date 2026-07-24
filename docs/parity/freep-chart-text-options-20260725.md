# FreeP chart text and 3-D view authoring

FreeP now exposes two chart authoring surfaces in both WPF and Avalonia:

- **Text Options** edits the chart-wide default font family, size, bold/italic state, and text
  color. Blank values remove the authored `c:chartSpace/c:txPr` override and restore automatic
  chart/theme defaults.
- **3-D View** edits the already-modeled camera elevation, rotation, perspective, height/depth,
  right-angle axes, and explicit Surface3D wireframe state.

Each dialog commits through one shared undo command. The existing chart reader/writer and render
planners remain the source of truth for the serialized and rendered semantics; the host dialogs
only edit typed working copies.
