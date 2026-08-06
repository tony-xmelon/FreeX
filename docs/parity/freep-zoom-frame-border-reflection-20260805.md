# FreeP Zoom Frame Border Reflection

## Scope

Native `a:reflection` on a Zoom frame is now a supported functional property. The
reader, model, undo command, summary-tile path, WPF/Avalonia format dialogs, and
both picture renderers retain and consume the authored reflection state.

The supported fields are the DrawingML reflection opacity (`stA`), distance,
direction, vertical scale, fade end position, and blur radius. The mirror and
fade are rendered at the picture-plan convergence point so live WPF and Avalonia
use the same resolved values. The existing shadow, glow, soft-edge, outline, crop,
and frame-geometry properties remain independent.

## Evidence

- Presentation planner/compositor focused lane: **168/168**.
- WPF host Zoom round-trip/authoring lane: **46/46**.
- Avalonia Zoom authoring lane: **4/4**.
- Full FreeP Presentation lane: **3,770/3,770**.
- Full `FreeP.slnx` Release build: **0 warnings, 0 errors**.

The round-trip contract verifies native XML, undo removal/restoration, and reopened
model values. The compositor contract verifies the resolved reflection alpha,
distance, and vertical scale on a Zoom preview `DrawOp.Picture`.

## Wave166 authoring closure

Before Wave166, `endPos` was already modeled by `ZoomFrameBorderReflection`,
preserved by the package reader/writer, and consumed by the shared picture
compositor, but it was absent from both Zoom Format dialogs. Wave166 adds the
shared formatter/parser and WPF/Avalonia fields and state. The native contract is
`a:reflection/@endPos`, exposed by Open XML SDK as `Reflection.EndPosition`; the
schema defines it as the end position along the alpha-gradient ramp for the end
alpha value and types it as `ST_PositiveFixedPercentage`:
[Microsoft Learn Reflection](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.drawing.reflection?view=openxml-3.0.1).

FreeP authoring uses `0..100%` in the dialogs and stores the fixed-percentage
integer in `0..100000` (`37.5%` becomes `endPos="37500"`). Editing patches only
the modeled reflection attributes, so the existing alpha, blur, distance,
direction, scale, sibling effects, and unsupported reflection attributes remain
intact. Focused evidence passed Presentation `173/173`, WPF/package `46/46`, and
Avalonia `4/4`.

## Boundary

Wave 165 closes the remaining `blurRad` authoring-depth boundary. Both desktop
dialogs now expose Reflection blur, the existing shared command writes the value
to native `a:reflection/@blurRad`, and package reopen reconstructs it. The shared
picture plan now turns the authored radius into deterministic reflection halo
passes consumed by both WPF and Avalonia. This is a bounded renderer projection,
not a claim of PowerPoint pixel identity or an unrelated global bitmap blur.
