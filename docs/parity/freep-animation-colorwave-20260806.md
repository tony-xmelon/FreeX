# FreeP ColorWave animation preservation - 2026-08-06

PowerPoint-authored ColorWave emphasis uses `presetClass="emph"`
`presetID="20"`. FreeP already preserved unrecognized preset tokens for
lossless package round-trip, but imported ID 20 previously selected the generic
Pulse playback fallback.

The shared reader now selects the existing ColorPulse playback contract for this
color emphasis effect while retaining the native class, ID, and subtype for
writing. ColorWave remains raw-preserved rather than being promoted to a new
authoring enum value until its distinct wave timing semantics are modeled.

This is a functional playback and package-preservation correction; it makes no
claim of pixel-identical PowerPoint timing or raster playback.
