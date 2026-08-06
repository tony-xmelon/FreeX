# FreeP ColorWave animation preservation - 2026-08-06

PowerPoint-authored ColorWave emphasis uses `presetClass="emph"`
`presetID="20"`. FreeP now preserves that identity as a distinct
`AnimationPreset` through import, authoring, save/reopen, and the shared
WPF/Avalonia ribbon command plans.

The shared playback planner now exposes a distinct ColorWave effect kind. WPF
and Avalonia consume a repeated from/to/from color-wave frame contract for
authored color behavior, while the native class, ID, and authored subtype
remain package authority.

This is a bounded functional playback correction. It does not claim
pixel-identical PowerPoint timing or raster playback.
