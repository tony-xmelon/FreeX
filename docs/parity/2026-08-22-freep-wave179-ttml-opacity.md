# FreeP Wave179: TTML caption opacity

## Finding

FreeP already preserved TTML foreground/background colors, font size, font family,
weight/style, and underline through the shared media transcript planner. An authored
`tts:opacity` value was still discarded by parsing, so playback rendered the span at
full opacity and authoring could not write the value back. This is a concrete caption
styling gap because PowerPoint-style timed-text consumers can preserve translucent
caption text and its authored background.

## Implemented

- Added nullable `PresentationMediaTranscriptCueSpan.Opacity`, normalized to `0..1`.
- Parsed inherited and inline TTML `opacity` values, accepting decimal and percentage
  forms, and emitted the value from authored TTML output.
- Applied the value to foreground and authored background brush alpha in both the WPF
  `SlideShowMediaController` and Avalonia `AvaloniaSlideShowMediaController`.
- Covered a PowerPoint-native TTML package fixture through load, planner projection,
  package round-trip, and reopened planner projection.

## Verification

- `PresentationMediaTranscriptPlannerTests`: 30 passed.
- WPF focused slideshow/media tests: 38 passed.
- Avalonia focused media adapter tests: 14 passed.

## Remaining caption gaps

This closes opacity only. TTML style references, richer text-decoration variants,
text outline/shadow, ruby, bidirectional embedding details, and broader caption
accessibility semantics remain outside this Wave179 slice.
