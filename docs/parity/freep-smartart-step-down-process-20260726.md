# FreeP SmartArt Step Down Process

FreeP now exposes the PowerPoint `Step Down Process` SmartArt layout as a function-first authoring route.

- Native layout ID: `urn:microsoft.com/office/officeart/2005/8/layout/StepDownProcess`.
- WPF and Avalonia expose the same shared command and undo path.
- The reader classifies the native layout as a live Process family layout after save/reopen.
- The shared live engine emits ordered staggered process boxes and predecessor connectors. This is deterministic shared editing geometry, not a claim of pixel-identical PowerPoint artwork.
