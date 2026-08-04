# FreeP Avalonia/WPF Wave 149: Summary Zoom All-Tile Format Scope

## Gap

Summary Zoom format editing had become per-tile after the tile-properties workflow
was added. The existing shared `SetZoomObjectPropertiesCommand` still supports an
atomic format update across every native `zmPr` tile, but neither desktop dialog
gave users a way to select that scope. A multi-tile Summary Zoom therefore could
not intentionally be normalized from the UI without editing tiles one at a time.

## Change

WPF and Avalonia now expose an explicit **Apply format to all Summary Zoom tiles**
scope in the shared Zoom Format surface. It keeps per-tile editing as the default;
when selected, both hosts route the chosen values through the existing shared
all-tile command, preserving native XML and undo behavior. Tile position/scale
continues to apply only to the selected tile.

Focused coverage includes both host routing contracts and a shared regression that
starts with divergent tile properties, applies the all-tile scope, and verifies one
undo restores the prior native tile state.

No PowerPoint COM or visual-baseline claim is made. Native platform dialog behavior
and PowerPoint-specific preview bitmap generation remain outside this slice.
