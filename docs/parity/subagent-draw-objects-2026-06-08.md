# Draw Objects Parity Subagent - 2026-06-08

Scope: Draw tab and non-chart drawing-object affordances, with chart-specific contextual tools, proofing/comments, formula UI, data refresh, slicers/timelines, Backstage, Help/Legal, and View/status surfaces left to other workers.

## Findings addressed

- The Draw tab already excludes freehand ink authoring commands (Draw with Touch, Eraser, Lasso Select, Pen/Pencil/Highlighter, Add Pen, Ink to Shape, Ink to Math) and documents those as out of scope/deferred.
- Draw tab crop, gradient, and effects commands had stable UI Automation metadata, but core object commands did not. Added automation names, stable IDs, and help text for Bring Forward, Send Backward, Selection Pane, Rotate Object, Object Size, Shape Fill, and Object Outline.
- Draw tab Object Size and Rotate Object routed only through shape/text-box targets even though the grid supports selected-picture resize/rotation interactively. Updated the transform target resolver and ribbon handlers to honor an explicitly selected picture and dispatch to the existing picture resize/rotate commands.
- Worksheet object context-menu targeting used broad "last visible object" fallback lookups. That could surface a picture/object menu when the context request was for another object or a normal cell. Context targeting now honors the selected object under the request or requires an exact anchor match.

## Remaining gaps

- Ink authoring and ink conversion remain intentionally deferred and unsurfaced in the current ribbon.
- Shape gradients/effects remain partial versus Excel's full galleries; current support is command/dialog based with the modeled presets already listed in the inventory.
- Picture formatting remains split between Format Picture and Draw crop/transform paths. Picture fill/outline styling is not modeled, so Shape Fill/Object Outline remain shape/text-box oriented.
- Selection Pane remains partial versus full Excel visuals, though current model-backed visibility, rename, z-order, grouping propagation, and stable automation coverage are preserved.

## Source-level verification added

- Draw command source tests now guard stable automation metadata for the Draw object buttons and picture-aware size/rotation routing.
- Drawing target resolver tests now cover exact-anchor lookups, selected-picture transform resolution, and exclusion of pictures from shape/text formatting.
- Worksheet context menu source tests now guard selected-object/exact-anchor targeting with no fallback for object context menus.
