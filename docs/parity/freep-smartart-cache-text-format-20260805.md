# FreeP SmartArt cache text formatting retention

Date: 2026-08-05

## Scope

SmartArt cache regeneration updates node text from the shared model. The generated cache must keep that edited text authoritative without flattening PowerPoint-authored text-body layout and run formatting on the matched role.

## Change

For matching cache shapes identified by `modelId`, regeneration now retains `a:bodyPr`, `a:lstStyle`, paragraph properties, end-paragraph properties, and corresponding run properties from the authored `dsp:txBody`. Text nodes, generated paragraph/run structure, and layout geometry remain owned by the current edit. Unmatched or newly generated roles keep the normal generated defaults.

## Evidence

- `RegenerateSmartArtDrawingCache_PreservesAuthoredEffectsAndTextFormattingByModelId` proves edited text remains current while centered paragraph and bold run formatting survive alongside an authored effect.
- `FreeP.App.Presentation.Tests`: 3746/3746.
- `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a functional package-preservation slice. It does not claim PowerPoint-pixel-identical SmartArt text rasterization.
