# FreeP SmartArt Quick Style Metadata

## Scope

SmartArt Quick Style edits now update the selected style's category and native
style-label metadata as well as its ID and title.

## Behavior

- Simple gallery styles write a `simple` category.
- 3-D gallery styles write a `3D` category.
- A native style definition without labels receives the standard `node0` label.
- The in-memory metadata is refreshed from the edited native definition so the
  next edit and a save/reopen observe the same selection.

## Verification

- `SmartArtEditingPlannerTests`: 136/136 no-build.
- `SmartArtTests`: 225/225 no-build.
- Quick Style focused host round trip: 14/14 compiled and 14/14 no-build.
- Quick Style focused planner tests: 15/15 compiled and 15/15 no-build.

This is a functional/source-state fix; no visual baseline was changed.
