# FreeP ColorWave animation preservation - 2026-08-06

PowerPoint-authored ColorWave emphasis uses `presetClass="emph"`
`presetID="20"`. FreeP now preserves that identity as a distinct
`AnimationPreset` through import, authoring, save/reopen, and the shared
WPF/Avalonia ribbon command plans.

ColorWave intentionally uses the existing ColorPulse playback contract until
its distinct wave timing semantics are modeled. The native class, ID, and
authored subtype remain package authority, so this closes functional identity
and authoring parity without claiming pixel-identical PowerPoint timing or
raster playback.

This is a functional playback and package-preservation correction; it makes no
claim of pixel-identical PowerPoint timing or raster playback.
