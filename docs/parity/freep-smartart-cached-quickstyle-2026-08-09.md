# FreeP SmartArt Cache-Only Quick Style Refresh - 2026-08-09

## Functional gap

When an imported SmartArt graphic has a native quick-style part but no parsed
`data1.xml` model, `ApplySmartArtQuickStyle` commits the native style metadata
while the compositor continues to paint the cached `dsp:drawing` shapes. The
style changed in the package, but the visible SmartArt stayed stale until
another application regenerated the cache.

## Change

Cache-only Quick Style edits now refresh simple, effect-free, solid-filled
text-bearing `AutoShape` nodes immediately. The shared `SmartArtStylePlanner`
supplies the theme-aware fill, outline, and readable text colors. Effectful,
custom-geometry, picture-backed, and other richer cached nodes remain on the
native-cache fallback path. Live-data SmartArt continues to regenerate through
the existing data/cache pipeline.

The update remains one undoable `ReplaceSmartArtCommand`, and the native
quick-style part and metadata remain authoritative for save/reopen behavior.

## Verification

- Presentation Quick Style cache-only contract: **1/1**
- Presentation SmartArt filter: **401/401**
- WPF SmartArt filter: **316/316**
- Avalonia SmartArt filter: **33/33**
- Full Presentation suite: **3,870/3,870**
- Release solution build: verified on the consuming branch

This is a functional/cache-ownership change; it makes no new PowerPoint PNG
or pixel-diff claim.
