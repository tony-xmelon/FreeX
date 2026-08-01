# FreeP functional parity Wave 92: motion-path gallery depth

Date: 2026-08-01

## Selected gap

FreeP already authored straight and arc motion paths in both hosts, but the
motion-path gallery stopped short of several common PowerPoint path families.
The shared animation model and PPTX writer already support arbitrary cubic
segments, so this was an authoring-surface gap rather than a new renderer
requirement.

## Closure

The shared planner now exposes Circle, Loop, S, and Figure Eight motion paths.
Each path is an undoable animation command built from renderer-neutral cubic
segments, and the WPF/Avalonia ribbon definitions, icons, localization, and
host registries expose the same command IDs.

The paths start at the selected object's origin and the closed-loop families
return to that origin, allowing the existing slideshow playback and PPTX
round-trip paths to consume them without host-specific geometry.

## Verification

- Shared planner: additional commands map to typed presets and produce the
  expected cubic segment counts; undo/redo remains covered by the existing
  motion command contract.
- WPF host: all four commands are reachable from the production registry and
  produce the expected paths.
- Avalonia host: all four commands are reachable from the production registry
  and produce the expected paths.
- Package persistence: the existing motion-path writer/reader contracts cover
  cubic segment serialization; the new paths use that same path model.

## Residuals

PowerPoint-authoritative motion-path raster baselines, custom freeform path
editing, and the full native motion-path gallery remain outside this bounded
authoring slice.
