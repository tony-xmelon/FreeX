# FreeP SmartArt Picture Stack

Date: 2026-07-28

## Scope

FreeP now exposes the native SmartArt `pictureStack` layout through the shared authoring and insertion paths.

- Native layout ID: `urn:microsoft.com/office/officeart/2005/8/layout/pictureStack`
- WPF and Avalonia command ID: `freep.smartart.layout.picture-stack`
- Picture-backed insertion requires an image payload for each live node and preserves node picture relationships through package round-trip.
- The shared live layout emits a stepped picture stack with a caption aligned to each picture; missing pictures retain the existing Add picture placeholder behavior.
- The package reader classifies the layout as a List-family picture-node layout and admits live layout only after node pictures are resolved.

## Verification

- `FreeP.App.Presentation.Tests`: focused SmartArt planner/layout/insertion tests pass.
- `FreeP.App.Host.Tests`: SmartArt package reader, native layout round-trip, and source guards pass.
- Ribbon definitions and Avalonia headless command registration are covered by the existing command completeness lanes.
- Command parity inventory regenerated after adding the two public commands.

This is a functional/package parity slice. It makes no claim that the live geometry is pixel-identical to PowerPoint; visual calibration remains separate.
