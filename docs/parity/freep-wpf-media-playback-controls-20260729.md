# FreeP WPF media playback controls

The slideshow media controller now exposes the same active-media controls as the
Avalonia adapter: seek by shape id and set volume using the shared 0-100 range.
WPF converts the range to `MediaElement.Volume`'s 0-1 representation and rejects
negative seek positions or inactive media without throwing. Existing click
play/pause, overlay layout, caption, and teardown paths are unchanged.

Focused STA coverage verifies shape-id routing, volume conversion, seek state,
and invalid-target/position handling. This is a functional host-parity slice;
it carries no visual-rendering claim.
