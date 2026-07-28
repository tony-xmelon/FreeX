# FreeP WPF/Avalonia Media Layout Resize Parity Wave 42

## Selected functional mismatch

When a slideshow canvas changed size, Avalonia resized only the media overlay
surface. Active video and caption children kept their original letterboxed
coordinates, so a caption or video could remain offset from its slide after a
window or display resize. The WPF media controller already had a relayout path,
but caption geometry was not refreshed there and the slideshow window did not
drive the path from its size event.

## Implementation

- Both media controllers now relayout active media and caption children by
  authored `ShapeId`.
- Both hosts use the shared `SlideShowMediaInteractionPlanner` bounds calculation
  for the resize path, matching slideshow hit-testing.
- WPF and Avalonia slideshow windows invoke media relayout when their canvas size
  changes.
- A resize event for a different slide instance tears down prior overlay slots
  before the new slide is entered.

## Focused coverage

- Shared letterbox bounds after a canvas resize.
- WPF caption overlay position and width after resize.
- Avalonia caption overlay position and width after resize.

## Residuals

Native video surface creation and playback remain host-specific: WPF uses
`MediaElement`, while Avalonia uses its LibVLC adapter. Focused tests assert
caption geometry; headless Avalonia cannot expose a real LibVLC `VideoView`
surface, so native-surface pixels remain a host integration residual.
