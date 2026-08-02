# FreeP Native Zoom Format Properties

FreeP now models the PowerPoint `CT_ZoomObjectProperties` attributes shared by Slide Zoom,
Section Zoom, and Summary Zoom: `returnToParent`, `imageType`, `transitionDur`, and `showBg`.
The reader projects authored values into the shared model; the writer continues to preserve the
raw native payload and any unmodeled child content.

Both WPF and Avalonia expose a Links-tab **Zoom Format** command. With one Zoom selected, the
dialog edits those properties through `SetZoomObjectPropertiesCommand`, including one undo/redo
step. Summary Zoom applies the mutation to every tile's `zmPr` node so the collection cannot drift
into mixed formatting.

Evidence:

- `SummaryZoomInsertionPlannerTests`: native mutation and undo/redo across all summary tiles.
- `ModernObjectsRoundTripTests`: authored preview properties survive package reopen.
- `FreePRibbonDefinitionProfileTests`: WPF/Avalonia command inventory remains symmetric.
- Release builds for WPF Host, Avalonia, Presentation, and Ribbon Definitions: 0 warnings/errors.

PowerPoint-exact cover-image authoring and preview styling remain separate work; `imageType="cover"`
is now preserved and editable, but the UI does not yet create a custom cover bitmap.
