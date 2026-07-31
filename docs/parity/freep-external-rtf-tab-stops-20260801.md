# FreeP External RTF Tab Stops

## Scope

This slice closes one source-semantic loss in external RTF paste. RTF paragraph tab
controls were previously emitted as text through `\tab`, but authored paragraph stops
were discarded because `\tx` and `\tq*` controls were ignored.

## Implemented behavior

- `\txN` preserves a positive tab position in twips as the shared `TabStop.PositionEmu`.
- `\tql`, `\tqc`, `\tqr`, and `\tqdec` preserve left, center, right, and decimal alignment.
- `\pard` resets the paragraph tab list to match RTF paragraph-format reset semantics.
- Nested RTF groups deep-copy tab-stop state, so a group-local change cannot mutate the
  surrounding paragraph's stops.
- The shared in-canvas visual plan exposes resolved tab stops in DIP, while the existing
  WPF/Avalonia slide compositor remains the rendering authority through `TextLayoutPlanner`.
- Rich clipboard serialization retains the resulting paragraph stops through paste/edit
  round-trip.

## Verification

Focused Presentation tests passed: 57/57, including parser alignment/reset/round-trip and
visual-plan projection coverage. This is a functional/source-semantics slice; it does not
claim PowerPoint-authoritative raster evidence for the rich editor or advanced RTF tab
leaders/provider-specific controls.
