# FreeP Connector Obstacle Routing

## Scope

FreeP elbow connectors previously routed only from the two attached endpoint
shapes. When another shape occupied the Manhattan path, moving an endpoint could
leave the connector passing through that shape. The model now supplies the
non-endpoint shape rectangles to an orthogonal visibility graph and keeps the
attached endpoint exit/entry directions authoritative.

The route remains a model-owned `ElbowRoute`, so WPF, Avalonia, and the existing
PDF/export consumers receive the same waypoints. Unobstructed routes retain the
existing compact path and shape moves remain one undoable operation.

## Evidence

- Direct obstacle detour and endpoint-direction contract: `Wave26ConnectorFrameTests`.
- Live reroute after moving an attached shape with an intervening rectangle.
- Undo restores the prior connector bounds and route.
- Focused connector lane: **16/16**.
- Full `FreeP.App.Presentation.Tests`: **3,745/3,745**.
- WPF Release consumer build: **0 warnings, 0 errors**.
- Avalonia Release consumer build: **0 warnings, 0 errors**.

This is functional routing parity evidence, not a PowerPoint raster claim.
