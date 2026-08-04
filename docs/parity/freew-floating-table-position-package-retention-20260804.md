# FreeW floating-table position package retention

Date: 2026-08-04

## Gap

FreeW reduced Word's complete `w:tblpPr` floating-table payload to a Boolean. Save then replaced every
imported anchor, coordinate, alignment, and text distance with one hard-coded position. The adjacent
`w:tblOverlap` policy was dropped as well.

## Slice

- `TableFloatingPosition` retains horizontal/vertical anchors, signed X/Y offsets, X/Y alignment
  specifications, and all four distances from surrounding text.
- Nullable fields distinguish an absent attribute from an authored zero; non-canonical packages carrying
  both an offset and an alignment specification remain non-destructive.
- `FloatingTableAllowsOverlap` retains `w:tblOverlap` as `overlap`, `never`, or absent.
- The existing `TextWrapping` property remains a compatibility facade. Turning Around on preserves an
  imported position or creates the historical Word-compatible default; turning it off clears floating state.
- Merge, split, compare, and combine clone paths preserve the complete table shell.
- Table Properties undo restores the exact position and overlap payload rather than recreating defaults.

## Package Evidence

The package contract writes margin/page anchors, negative X and positive Y offsets, inside/outside
alignment specifications, four distinct text distances, and `tblOverlap=never`. It asserts exact twip
attributes and `tblPr` child order, then reopens to an equal model payload. The legacy Around path reopens
with the same 9-point side distances and one-twip Y anchor previously emitted by FreeW.

## Verification

- Floating-table package contracts, including Microsoft 365 schema validation: 7/7.
- Focused model, merge, split, compare, and combine contracts: 10/10.
- Shared Table Properties planner/undo contracts: 6/6; consuming project builds: 0 warnings/errors.
- Full FreeW Core.IO package suite: 1452/1452.
- Full FreeW Core.Model suite: 1664/1664.
