# FreeP custom connection sites

## Scope

FreeP now preserves authored DrawingML custom geometry connection sites from
`a:custGeom/a:cxnLst` through the presentation model, cloning, undo, and PPTX
read/write. Connector attachment resolves the authored site coordinates before
falling back to the existing path-extrema heuristics.

The model retains raw `x`, `y`, and `ang` tokens so guide expressions and source
metadata survive a save even when the resolver does not recognize a particular
formula. Common edge/center guide tokens are resolved in the authored path
coordinate space; unsupported expressions retain their payload and use the
existing compatibility fallback.

## Verification

- `ConnectorAttachmentTests`, `CustomGeomEffectsTests`, and the custom-shape
  undo contract: 67/67 passed.
- `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a functional/package-parity slice. It does not claim a raster-fidelity
improvement; the goal is to keep authored connector topology and attachment
behavior intact across edit/save/reopen and both host renderers.
