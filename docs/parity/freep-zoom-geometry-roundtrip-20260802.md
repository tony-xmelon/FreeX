# FreeP Zoom Geometry Round-Trip

## Functional contract

Native Slide Zoom, Section Zoom, and Summary Zoom shapes keep their editable
`SlideShape` transform as the authoring source of truth. Saving a deck now
projects that state into the preserved graphic-frame payload, including:

- position (`a:off`),
- size (`a:ext`),
- rotation (`rot`), and
- horizontal/vertical flips.

Summary Zoom projects the same transform into both the native
`mc:Choice/p:graphicFrame` branch and its fallback `p:sp` branch. Reopening a
saved package restores the transform into the model, so canvas transforms do
not silently revert when PowerPoint or FreeP reopens the deck.

## Verification

- `ZoomGeometryRoundTripTests`: 2/2
- Existing Zoom-focused presentation tests: 47/47
- The test package asserts both serialized Summary Zoom branches and reopened
  model geometry.

This is a functional/package-parity slice; it does not claim a raster-fidelity
change.
