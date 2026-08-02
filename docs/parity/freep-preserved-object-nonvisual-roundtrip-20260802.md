# FreeP Preserved Object Non-Visual Round-Trip - 2026-08-02

## Functional gap

Preserved Zoom, Ink, 3D, and unknown modern objects were read into the shared
`SlideShape` model with editable `cNvPr` state, but the writer only synchronized
their transform and hyperlink fields. Saving after an alt-text, decorative, hidden,
or name edit could therefore restore the original native metadata.

## Fix

`PptxPackageWriter` now synchronizes the model-owned `cNvPr` name, hidden flag,
alternative-text title/description, and decorative extension on preserved payloads.
When a payload is re-emitted through `mc:AlternateContent`, both the choice and
fallback branches receive the same state. Unmodeled native payload content remains
preserved.

## Evidence

- `ModernObjectsRoundTripTests`: 29/29
- `PptxRoundTripTests`: 60/60
- The regression mutates a native Zoom object's non-visual properties, writes the
  package, reopens it, and verifies the edited state.
