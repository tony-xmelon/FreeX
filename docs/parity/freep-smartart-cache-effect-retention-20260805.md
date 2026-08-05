# FreeP SmartArt cache effect retention

Date: 2026-08-05

## Scope

SmartArt edits regenerate the diagram drawing cache from the shared live-layout plan. The regenerated cache must update geometry and text, but it must not discard authored visual effect payloads that PowerPoint stored on a matching cache shape.

## Change

During cache regeneration, source drawing shapes are indexed by their existing `modelId` before stale generated children are removed. Matching generated shapes retain only the authored `a:effectLst`, `a:scene3d`, `a:sp3d`, and `a:extLst` payloads. Generated layout geometry, fill, line, and text remain authoritative for the edit. Unmatched roles do not receive copied payloads.

## Evidence

- `RegenerateSmartArtDrawingCache_PreservesAuthoredEffectsByModelId` proves an authored shadow survives cache regeneration while edited node text is emitted.
- `FreeP.App.Presentation.Tests`: 3746/3746.
- `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a functional package-preservation slice. It does not claim PowerPoint-pixel-identical rendering for unsupported live SmartArt effects.

