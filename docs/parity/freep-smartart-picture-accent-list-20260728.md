# FreeP SmartArt Picture Accent List

Date: 2026-07-28

## Scope

FreeP now exposes the native SmartArt `pictureAccentList` layout through the shared authoring and insertion paths.

- Native layout ID: `urn:microsoft.com/office/officeart/2005/8/layout/pictureAccentList`
- WPF and Avalonia command ID: `freep.smartart.layout.picture-accent-list`
- Picture-backed insertion requires an image payload and preserves node picture relationships through package round-trip.
- The live shared layout emits one picture, accent bar, and caption per node; missing pictures retain the existing Add picture placeholder behavior.
- The package reader recognizes the layout as a List-family picture-node layout and admits live layout only after node pictures are resolved.

## Verification

- `FreeP.App.Presentation.Tests`: focused SmartArt planner/layout and insertion tests pass.
- `FreeP.App.Host.Tests`: SmartArt package reader, native layout round-trip, and source guards pass.
- Ribbon definitions and Avalonia headless command registration are covered by the existing command completeness lanes.
- Command parity inventory regenerated after adding the two public commands.

This is a functional parity slice. It makes no claim that the live layout is pixel-identical to PowerPoint; visual calibration remains outside this change.
