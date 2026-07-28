# FreeP SmartArt Picture Lineup

Date: 2026-07-28

## Scope

FreeP now admits the native SmartArt `pictureLineup` layout through the shared authoring, insertion, package, WPF, and Avalonia command paths.

- Native layout: `urn:microsoft.com/office/officeart/2005/8/layout/pictureLineup`
- Command: `freep.smartart.layout.picture-lineup`
- Family: List
- Payload: one picture payload per SmartArt node, using the existing media relationship and package round-trip path

## Behavior

The live layout places node pictures in a horizontal row with captions below each picture. Nodes without an image retain the existing Add picture placeholder behavior. The layout is available through the SmartArt ribbon gallery and both host command registries.

## Verification

- Presentation focused lane: 418 passed
- Host/package SmartArt and source-contract lane: 193 passed
- Release presentation build: 0 warnings, 0 errors
- Command inventory: 519 commands, 517 shared, 0 actionable WPF/Avalonia gaps

This is a functional and package-admission slice. It does not claim pixel-identical PowerPoint raster output; visual calibration remains a separate evidence-backed workstream.
