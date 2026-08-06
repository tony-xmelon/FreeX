# FreeP WPF Media Bookmark Seek Readiness

## Scope

WPF slideshow media bookmark seeks could be lost when `TrySeekToBookmark` ran
before `MediaElement.MediaOpened`. WPF can ignore a `Position` assignment while
the source is still opening, so the command returned success without preserving
the requested playback position.

## Functional change

- WPF media elements enable `ScrubbingEnabled` so paused bookmark seeks are
  accepted by the media surface.
- The media slot retains a pending seek request when the natural duration is not
  available yet.
- `MediaOpened` applies that request through the existing trim-window and fade
  policy, then clears it.
- Ordinary seeks and media without a pending request keep their existing path.

## Verification

- `FreeP.App.Host.Tests` affected media, recording, animation, Zoom, and
  SmartArt families: **638/638**.
- `FreeP.App.Host.Tests` media-controller class: **37/37**.
- `FreeP.App.Presentation.Tests` affected media, recording, animation, Zoom,
  SmartArt, and ChartEx families: **746/746**.
- Consuming Release builds completed with **0 warnings, 0 errors**.

This is a functional playback fix; it makes no visual-fidelity claim.
