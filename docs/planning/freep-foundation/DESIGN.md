# FreeP Foundation — PowerPoint Parity, Wave 1

Status: in progress (2026-06-25). Owner: FreeP parity session (orchestrator).
Branch: `freep/foundation`. Integrates to `main` slice-by-slice.

## Goal

Turn FreeP from a stub shell into a faithful PowerPoint app. Wave 1 builds the
**foundation that all parity work depends on**: a real presentation domain model,
`.pptx` (PresentationML) import/export, and faithful slide rendering — measured
against real Microsoft PowerPoint (installed on this machine) the same way FreeX
and FreeW parity were driven.

Decisions (orchestrator, fidelity-first playbook):
- **`.pptx` is the primary read/write format.** The legacy `.fxp` JSON stub is frozen
  (kept readable for existing tests, no longer the focus).
- **Ground truth = real PowerPoint** via COM automation (export slides to PNG/PDF,
  read shape geometry/text), mirroring `tools/FreeX.ChartInteropCompare` /
  `tools/FreeW.RenderCompare`.
- **No collision with active FreeX shape work.** The shared geometry engine is
  *ported* into a new shared project, not moved out of `src/FreeX.App.Presentation`.

## Reuse map (from architecture survey)

100% reusable as-is: ribbon framework, shell chrome, Backstage/File, theming,
command-bus base, PDF export (`PortablePdfWriter`), DrawingML unit conversions
(`shared/Free.Shared.Opc/DrawingMlUnits.cs`), app host/startup pattern.

Port into shared (new code, FreeX untouched): the framework-free geometry engine
currently in `src/FreeX.App.Presentation/Shapes/` — `ShapeGeometry`,
`ShapeContour`, `ShapeSegment`, `ShapeGeometryBuilder` (44 presets), `LayoutRect`,
and the `DrawingShapeKind` enum from `src/FreeX.Core.Model`.

Reference patterns (read, adapt — do not depend on FreeX assemblies): the XLSX
DrawingML stack in `src/FreeX.Core.IO/Xlsx*Drawing*.cs` (color/theme reader,
anchor applier, schema normalizer, shape writer). PresentationML swaps `xdr:`
for `p:` and keeps the `a:` (DrawingML) vocabulary.

## Architecture

```
shared/Free.Shared.Drawing            (NEW) framework-free geometry + shape kinds
   DrawingShapeKind, ShapeGeometry/Contour/Segment, ShapeGeometryBuilder, LayoutRect

freep/FreeP.Core.Model                 presentation domain (real model)
   Presentation, SlideSize, PresentationTheme (color+font scheme)
   SlideMaster, SlideLayout, Slide, SlideShape, TextBody/Paragraph/Run,
   ShapeFill, ShapeOutline, Placeholder, PictureFill/ImagePart

freep/FreeP.Core.IO                    .pptx import/export (OPC + PresentationML)
   PptxPackageReader / PptxPackageWriter
   slide / slideLayout / slideMaster / presentation / theme part parsers
   (legacy FxpFormat frozen, still present)

freep/FreeP.App.Presentation           (NEW) app-neutral slide compositor
   SlideRenderModel — resolve placeholder inheritance, produce draw ops

freep/FreeP.App.Host                    WPF: real SlideCanvas renderer + ribbon
```

## Model contract (the linchpin — stabilize first)

`SlideShape` (presentation-anchored; EMU absolute, no cell grid):
- `Id` (uint), `Name`
- `Kind`: `DrawingShapeKind` preset OR `Picture | Group | Table | Connector`
- Anchor: `OffsetXEmu, OffsetYEmu, ExtentCxEmu, ExtentCyEmu`, `RotationDeg`, `FlipH/V`
- `Fill`: None | Solid(color) | Gradient(...) — color carries resolved sRGB **and**
  optional `SchemeColor` ref + lumMod/lumOff so theme changes resolve correctly
- `Outline`: width (pt), dash, color, or None
- `TextBody`: `List<Paragraph>`; `Paragraph` = align/level/bullet + `List<Run>`;
  `Run` = text + font family/size(pt)/bold/italic/underline/color
- `Placeholder`: type (title/body/ctrTitle/subTitle/...) + idx (for inheritance)
- `Picture`: image part ref (bytes + content type) when `Kind == Picture`
- `Children` when `Kind == Group`

`Slide`: `Id`, `LayoutId`, `List<SlideShape>`, optional `Background`.
`SlideLayout`: name, type, master ref, placeholder shapes (geometry/text-style source).
`SlideMaster`: theme ref, placeholder shapes, color/text-style defaults.
`Presentation`: `SlideSizeEmu (cx,cy)` (default 16:9 = 12192000×6858000),
`Slides`, `Layouts`, `Masters`, `Theme`, `Properties`.

Inheritance for rendering: shape with a Placeholder and no explicit xfrm/text-style
inherits position/size/run-properties from the matching placeholder on its layout,
then master. Resolve in `FreeP.App.Presentation`, not in the renderer.

Round-trip stance for Wave 1: **semantic** round-trip (open → model → save reopens
equivalent), not byte-identical. Byte fidelity is a later wave (keep unmodeled
parts verbatim then).

## Wave 1 work breakdown (agents, non-overlapping write scopes)

- **1A — Shared drawing port + presentation model + keep-green migration.**
  Create `shared/Free.Shared.Drawing` (port geometry). Replace stub
  `FreeP.Core.Model` with the real model above. Migrate `FxpFormat`, host canvas,
  and existing tests so the solution builds and existing tests pass. *Blocking —
  everything else builds on this contract.* Scope: `shared/Free.Shared.Drawing/**`,
  `freep/FreeP.Core.Model/**`, minimal edits to `FreeP.Core.IO/FxpFormat.cs`,
  `FreeP.App.Host` canvas, `FreeP.App.Host.Tests`.

- **1B — `.pptx` reader.** `PptxPackageReader`: OPC unzip → presentation.xml
  (slide size, slide id list, rels), theme (color/font scheme), slideMaster*,
  slideLayout*, slide* → model. Shapes: autoshapes (`p:sp` + `a:prstGeom`),
  textboxes, pictures (`p:pic`), connectors (`p:cxnSp`); fills/outlines via
  DrawingML `a:solidFill`/`a:ln`; placeholder linkage. Scope: `FreeP.Core.IO/Pptx*Read*`.

- **1C — `.pptx` writer.** `PptxPackageWriter`: model → OPC package (content types,
  rels, presentation.xml, slideN.xml, layouts, masters, theme, media). Round-trips
  with 1B (semantic). Scope: `FreeP.Core.IO/Pptx*Write*`.

- **1D — Slide renderer.** `FreeP.App.Presentation` compositor (placeholder
  inheritance → draw ops) + `FreeP.App.Host` `SlideCanvas` WPF renderer using the
  shared geometry engine; wire PDF export to render real shapes. Scope:
  `freep/FreeP.App.Presentation/**`, `FreeP.App.Host` canvas/render only.

- **1E — Interop-compare harness.** `tools/FreeP.RenderCompare`: drive PowerPoint
  COM to export a `.pptx`'s slides to PNG, render the same via FreeP, diff. Plus a
  small generated `.pptx` corpus. Scope: `tools/FreeP.RenderCompare/**`, fixtures.

1B/1C/1D/1E run in parallel after 1A integrates. 1B+1C round-trip together; 1E
validates 1D against PowerPoint.

## Verification

- `dotnet build FreeX.slnx -c Release`
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build` (FreeP tests are in the
  default lane)
- Per-slice: new unit tests (round-trip, parser, render-op) + `FreeP.RenderCompare`
  pixel diff vs PowerPoint on the corpus.
```
```
