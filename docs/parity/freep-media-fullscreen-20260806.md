# FreeP media full-screen playback

## Scope

PowerPoint stores video full-screen playback on `a:videoFile@fullScrn`. FreeP now preserves that flag through the media model, DOCX package read/write, cloning, and the undoable playback-options command. The editor exposes it in both host playback panes and keeps it video-only.

## Host behavior

During slideshow playback, a flagged video expands to the active slide viewport and its authored rectangle is restored when playback pauses or ends. Captions follow the same viewport bounds while the video is playing. This is host-viewport full-screen behavior; it does not claim OS-window or device-level full-screen control.

## Evidence

- `Media_PlayFullScreen_RoundTripsThroughVideoFile` verifies `a:videoFile@fullScrn="1"` and reopen behavior.
- WPF and Avalonia media-pane tests verify authoring and application of the option.
- `MediaCaptionCommandTests` verifies undo/redo and the video-only command clamp.

The slice is functional/package parity work and makes no raster-fidelity claim.
