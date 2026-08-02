# FreeP SmartArt 3D quick-style profiles - 2026-08-02

## Functional gap

The SmartArt gallery exposed native `3d1` through `3d9` quick-style identities and the
package reader/writer preserved their quickStyle parts, but the live shared style planner
treated every scene style as the same generic Intense profile. A user could select and save a
different native style while the live WPF and Avalonia diagrams continued to consume the same
renderer-neutral fill, outline, and connector profile.

## Change

`SmartArtStylePlanner` now maps the native scene identities to separate bounded profiles:
Polished, Inset, Cartoon, Powder, Brick Scene, Flat Scene, Metallic Scene, Sunset Scene, and
Bird's Eye Scene. Each profile supplies its own fill transform, outline treatment, outline width,
connector color, and connector width. The raw quickStyle diagram part and the authored native
style identity remain unchanged, so save/reopen continues to use PowerPoint's source payload.

Both desktop hosts consume this shared planner; no host-local SmartArt style switch was added.
This is a functional live-style distinction, not a claim of exact Office 3-D bevel, lighting, or
effect raster parity.

## Verification

- `FreeP.App.Presentation.Tests` SmartArtLayoutTests: 199/199.
- `FreeP.App.Host.Tests` SmartArtTests: 233/233.
- `FreeP.App.Avalonia.Tests` SmartArt filter: 25/25.
- Release builds were completed as part of each focused test command.
