# Avalonia Parity Wave 166: FreeP Zoom Reflection Fade End Position

Date: 2026-08-06

## Selected residual

The existing Zoom frame reflection already had a native `a:reflection/@endPos`
model field, package read/write support, and compositor projection. Both WPF and
Avalonia Zoom Format dialogs omitted the field, so an authored fade endpoint
could be preserved and rendered but not edited.

The current Open XML contract identifies `endPos` as `Reflection.EndPosition`.
It specifies the position along the alpha-gradient ramp where the end-alpha
value is reached, and its schema type is `ST_PositiveFixedPercentage`:
[Microsoft Learn Reflection](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.drawing.reflection?view=openxml-3.0.1).

## Implementation

- Added shared `FormatFrameBorderReflectionEndPosition` and parser validation
  for `0..100%`, normalized to the existing `0..100000` fixed-percent model.
- Added WPF and Avalonia `Reflection fade end (%)` fields, load/state behavior,
  and commit parsing through the existing shared Zoom command and undo route.
- Changed the reflection XML patch to update only modeled attributes. Existing
  reflection siblings and unsupported reflection attributes are retained.
- Kept renderer code unchanged; the existing renderer-neutral `ReflectionEndPos`
  projection is now explicitly tested at `0.25`.

## Evidence

- Presentation planner/compositor lane: **173/173**.
- WPF host and package round-trip lane: **46/46**.
- Avalonia Zoom authoring lane: **4/4**.
- Native XML evidence covers `endPos="25000"`, undo restoration of
  `endPos="37500"`, redo, package reopen, and preservation of `futureAttr` plus
  a sibling `glow` element.

## Boundary

This closes only Zoom frame reflection fade-end authoring. It does not add other
Zoom effects, alter renderer raster tuning, or claim PowerPoint pixel identity.
Unsupported native XML remains preserved rather than being speculatively modeled.
