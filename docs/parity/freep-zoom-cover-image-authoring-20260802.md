# FreeP Zoom cover-image authoring

## Scope

Single-target Slide Zoom and Section Zoom objects now accept a user-selected image through the WPF and Avalonia
hosts. The shared `SetZoomCoverImageCommand` replaces or creates the native `zmPr` `blipFill` image relationship,
sets `imageType="cover"`, persists the media bytes/content type, and participates in the normal undo/redo bus.
Summary Zoom remains intentionally excluded from this command because each tile owns a separate image relationship.

## Evidence

- `SlideZoomInsertionPlannerTests`: cover-image command, native relationship, undo, and redo pass.
- `ModernObjectsRoundTripTests`: cover image survives PPTX write/reopen with `image/png` bytes and an image relationship.
- WPF and Avalonia expose the same shared command through a host-native picture picker.
- Command inventory regenerated: 619 commands, 619 present in both hosts, zero actionable gaps.
- Ribbon definition profile: 23/23.

## Remaining

Summary Zoom needs per-tile cover-image selection rather than a single object-level picker. PowerPoint-exact cover
crop/position styling and transition rendering remain separate parity work.
