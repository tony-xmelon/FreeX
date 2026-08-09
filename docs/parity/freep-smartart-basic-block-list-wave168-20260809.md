# FreeP Wave 168: SmartArt Basic Block List

## Scope

`basicBlockList` is now admitted to the shared rectangular block-list layout
plan. Previously, imported or authored Basic Block List diagrams fell through
to the generic rounded SmartArt list approximation even though the shared
vertical block geometry already preserved block shape and bounded hierarchy
indents.

## Shared behavior

- WPF and Avalonia receive the same rectangle `SlideShape` operations from
  `SmartArtLayoutEngine`.
- Level-zero blocks share the frame alignment; nested levels receive a bounded
  left inset while retaining the authored display order.
- Cached SmartArt drawing fallback is still used for empty data or unsupported
  layout families.

Focused `SmartArtLayoutTests` cover compositor selection, rectangular geometry,
and level indentation. PowerPoint-authoritative geometry/effects and broader
SmartArt authoring remain deferred.
