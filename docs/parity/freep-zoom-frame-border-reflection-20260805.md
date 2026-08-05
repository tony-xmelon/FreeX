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

## Boundary

The current host implementation paints the authored mirror and opacity fade. It
does not claim independent blur-kernel parity for `blurRad`; that remains a future
renderer-depth item and is intentionally not approximated by a global bitmap blur.
