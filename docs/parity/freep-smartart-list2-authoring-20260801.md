# FreeP SmartArt List 2 authoring

PowerPoint's native `list2` SmartArt layout was already admitted as a live List-family
layout for imported packages, and the shared List layout engine already regenerated its
editable nodes. The missing function was authoring: neither Change Layout nor SmartArt
insertion exposed the native `List 2` choice.

FreeP now exposes `List 2` through the shared SmartArt preset, localized WPF/Avalonia
ribbon definitions, and both host command registries. The existing native layout writer,
undo path, and List-family regeneration remain authoritative; no new renderer geometry
was introduced.

Focused planner, WPF, Avalonia, and package-reader source contracts cover the native
`list2` token, host reachability, undo routing, and live editable output. This is a
functional/package parity slice and makes no PowerPoint raster-fidelity claim.
