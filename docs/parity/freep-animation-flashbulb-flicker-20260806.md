# FreeP FlashBulb and Flicker animation preservation - 2026-08-06

PowerPoint-authored emphasis effects use `presetID="26"` for FlashBulb and
`presetID="27"` for Flicker. FreeP already preserved unrecognized preset tokens
for lossless package round-trip, but imported IDs previously selected the generic
Pulse playback fallback.

The shared reader now selects the existing Blink playback contract for these two
visibility effects while retaining `presetClass="emph"`, the native ID, and the
authored subtype for writing. FlashBulb and Flicker remain raw-preserved rather
than being promoted to new authoring enum values until their distinct PowerPoint
option semantics are modeled.

This is a functional playback and package-preservation correction; it makes no
claim of pixel-identical PowerPoint timing or raster playback.
