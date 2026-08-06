# FreeP FlashBulb and Flicker animation preservation - 2026-08-06

PowerPoint-authored emphasis effects use `presetID="26"` for FlashBulb and
`presetID="27"` for Flicker. FreeP now preserves those identities as distinct
`AnimationPreset` values through import, authoring, save/reopen, and the shared
WPF/Avalonia ribbon command plans.

Both effects intentionally use the existing Blink playback contract until a
distinct renderer-neutral visual effect is modeled. The native `presetClass`,
ID, and authored subtype remain authoritative in the package; this slice fixes
functional identity and authoring parity without claiming pixel-identical
PowerPoint timing or raster playback.

This is a functional playback and package-preservation correction; it makes no
claim of pixel-identical PowerPoint timing or raster playback.
