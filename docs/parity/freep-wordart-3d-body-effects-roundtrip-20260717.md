# FreeP WordArt Body 3-D Round-Trip

Date: 2026-07-17

## Scope

The imported WordArt corpus stores 3-D material, bevel, extrusion, and lighting on `a:bodyPr` as sibling `a:scene3d` and `a:sp3d` elements. The general shape-effects reader did not see those nodes because it only inspected `p:spPr`.

This slice adds `TextBody.Text3dEffects`, reads both body-level elements, resolves them onto `ResolvedTextLayout`, preserves them through text-body cloning, and writes them back using the existing schema-aware 3-D serializers.

## Verification

- `WordArtTests` reads both `metal` and `softEdge` corpus samples.
- The round-tripped deck passes the slide-part `OpenXmlValidator` schema check.
- The compositor retains the resolved camera/material data on both text layouts.
- Focused lane: 65 tests passed.
- RenderCompare build: 0 warnings, 0 errors.

## Renderer decision

A first-pass glyph extrusion/bevel overlay was measured and rejected. At 1280x720 on `13-wordart.pptx`, the cleaned current WPF baseline measured `1.7724%` mean diff; bevel-only measured `1.8882%`, extrusion-only `1.7904%`, and both together `1.9025%`. The body-level 3-D state is therefore preserved for future renderer work without shipping a raster regression.
