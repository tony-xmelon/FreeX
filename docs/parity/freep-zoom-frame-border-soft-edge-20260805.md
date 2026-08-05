# FreeP Zoom Frame Soft Edge - 2026-08-05

FreeP now exposes the native PowerPoint DrawingML `a:softEdge` effect on Slide
Zoom, Section Zoom, and Summary Zoom frame properties. The effect is represented
as `ZoomFrameBorderSoftEdge`, retains its EMU radius, and is edited through the
existing shared Zoom Format command in both WPF and Avalonia.

The reader and writer preserve `p:zmPr/spPr/a:effectLst/a:softEdge`, including
the existing shadow and glow siblings. The mutation is undoable and survives a
write/reopen cycle. The shared compositor resolves the native radius into the
existing `ResolvedShapeEffects` soft-edge path, so both desktop renderers consume
the same effect plan.

## Verification

- Release solution build: 0 warnings, 0 errors.
- Presentation planner/compositor focus: 163/163.
- WPF Zoom round-trip and source parity focus: 45/45.
- Avalonia Zoom source parity focus: 4/4.
- Full `FreeP.App.Presentation.Tests`: 3,765/3,765.

This is a functional/package-parity slice. It does not claim a new
PowerPoint-authored raster baseline or complete Zoom effect coverage; reflection,
3-D frame effects, and other native effect families remain separate boundaries.
