# FreeP Zoom cover-image authoring

## Scope

Slide Zoom, Section Zoom, and individual Summary Zoom tiles now accept a user-selected image through the WPF and
Avalonia hosts. The shared `SetZoomCoverImageCommand` targets either a single object or a selected Summary tile,
replaces or creates that target's native `zmPr` `blipFill` image relationship, sets `imageType="cover"`, persists
the media bytes/content type, and participates in the normal undo/redo bus. Summary tiles use distinct media paths,
so editing one tile cannot overwrite another tile's image.

## Evidence

- `SlideZoomInsertionPlannerTests`: cover-image command, native relationship, undo, and redo pass.
- `ModernObjectsRoundTripTests`: cover image survives PPTX write/reopen with `image/png` bytes and an image relationship.
- `SummaryZoomInsertionPlannerTests`: two tile images remain independent and undo/redo restores the prior tile state.
- `ModernObjectsRoundTripTests`: two Summary tile images survive PPTX write/reopen with separate relationships and bytes.
- WPF and Avalonia expose the same shared command through a host-native picture picker.
- Command inventory regenerated: 619 commands, 619 present in both hosts, zero actionable gaps.
- Ribbon definition profile: 23/23.

## Remaining

PowerPoint-exact cover crop/position styling and transition rendering remain separate parity work.
