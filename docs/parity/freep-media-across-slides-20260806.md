# FreeP media across slides

## Functional gap

PowerPoint stores audio that continues across sequential slides as
`p:cMediaNode/@numSld`, with the default omitted value meaning one slide. A
PowerPoint COM control created with `PlayOnEntry`, `LoopUntilStopped`, and
`StopAfterSlides=2` produced `numSld="2"` in the slide timing XML.

FreeP previously had no model field for this value, omitted it on write, and
the slideshow controllers tore down every media session whenever a new slide
was entered.

## Change

- `MediaInfo.StopAfterSlides` preserves the authored count, defaulting to one.
- PPTX reader/writer round-trip `p:cMediaNode/@numSld` and emit timing even
  when the cross-slide count is the only non-default playback option.
- WPF and Avalonia playback retain only non-video media during a sequential
  slide advance, decrementing the remaining count; jumps and non-indexed calls
  retain the existing teardown behavior.
- Both playback panes expose **Stop after slides** and route changes through
  the existing undoable playback-options command.

## Gates

- `Media_StopAfterSlides_RoundTripsNativeAudioTiming`: passed.
- `EditingSessionSelectedMediaPlaybackOptions_UsesUndoBus`: passed with
  apply/undo/redo coverage for the slide count.
- `FreeP.App.Host` Release build: 0 warnings/errors.
- `FreeP.App.Avalonia` Release build: 0 warnings/errors.

The change is functional/package parity evidence; no raster comparison is
needed for this slice.
