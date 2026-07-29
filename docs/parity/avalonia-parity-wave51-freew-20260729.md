# Avalonia/WPF parity wave 51: FreeW drawing format

Date: 2026-07-29

## Authority audit

The WPF drawing-object registry was compared with the Avalonia registry and
portable ribbon definition. WPF registers these shape-format routes:

- `freew.shape-change-rectangle`
- `freew.shape-change-rounded`
- `freew.shape-change-ellipse`
- `freew.shape-fill-gradient-blue`
- `freew.shape-fill-gradient-orange`
- `freew.shape-fill-pattern-diag`
- `freew.shape-effects-none`
- `freew.shape-effect-shadow`
- `freew.shape-effect-glow`
- `freew.shape-effect-soft-edge`
- `freew.shape-effect-reflection`
- `freew.shape-effect-bevel`

The related `shape-edit-*` and `shape-text-*` routes were also checked. The
Avalonia registry already had the shared fill, outline, text-direction, and
shape-style mutations, so those routes were not duplicated.

Grouped-child direct editing is not a WPF capability: WPF renders group
children without selection handlers and routes selection to the group root.
Avalonia has the equivalent behavior, so no speculative child-editing logic
was added.

## Implemented

- Added Avalonia undoable shape-kind handlers for rectangle, rounded rectangle,
  and ellipse through `SetShapeKindCommand`.
- Added Avalonia undoable shape-effects handlers for none, shadow, glow, soft
  edge, reflection, and bevel through `SetShapeEffectsCommand`.
- Exposed the WPF-equivalent Change Shape, Edit Shape, Shape Fill, Shape
  Outline, Shape Effects, and Text Direction menus in the Avalonia Drawing
  Format contextual tab. Existing shared gradient and outline command routes
  are reused.
- Added focused registry, menu-definition, mutation, and undo coverage in
  `PictureDrawingContextualTabTests`.

## Deliberate boundary

WPF also exposes WordArt style and transform menus. Avalonia currently has no
selected-WordArt editing surface or mutation helper, so this slice does not
invent a selection or command path for it. WordArt remains a separate
high-confidence FreeW follow-up once its Avalonia selection contract is
defined.

## Validation

Tests are intentionally pending until the scoped patch is reviewed and the
focused low-resource FreeW test lane is run.
