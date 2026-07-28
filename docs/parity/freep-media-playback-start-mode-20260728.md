# FreeP media playback start mode

FreeP now preserves the authored PowerPoint media start mode needed by the
slideshow hosts. `MediaInfo.PlaybackStartMode` defaults to `InClickSequence`,
so existing media remains click-driven. A PresentationML `p:video` or `p:audio`
timing node with an `onBegin` condition is read as `Automatically` and is
written back as the same targeted `p:cMediaNode` timing entry.

WPF and Avalonia now consume the shared value: only `Automatically` starts a
media session during slide entry; click-sequence media waits for the existing
hit-tested click route. This closes the prior host mismatch
where Avalonia started every media object immediately while WPF waited for a
click.

Focused evidence covers automatic timing read/write, default click-sequence
behavior, and both-host playback tests. Media loop intent is also preserved
through `repeatCount="indefinite"` timing and forwarded to both native playback
hosts; captions, native decoder availability, and device-specific playback remain
separate concerns.
