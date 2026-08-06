# FreeP FlashBulb and Flicker animation preservation - 2026-08-06

PowerPoint-authored emphasis effects use `presetID="26"` for FlashBulb and
`presetID="27"` for Flicker. FreeP now preserves those identities as distinct
`AnimationPreset` values through import, authoring, save/reopen, and the shared
WPF/Avalonia ribbon command plans.

The shared playback planner now keeps the identities distinct: FlashBulb uses
a short flash frame contract, while Flicker uses an irregular multi-step
opacity contract. WPF and Avalonia consume the same effect kinds and timing
shape; the native `presetClass`, ID, and authored subtype remain authoritative
in the package.

This is a bounded functional playback correction. It does not claim
pixel-identical PowerPoint timing or raster playback.
