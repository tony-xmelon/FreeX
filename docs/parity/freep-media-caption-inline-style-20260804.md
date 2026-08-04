# FreeP media caption inline styling

## Scope

Native WebVTT cue markup for the basic `<b>`, `<i>`, and `<u>` tags is retained by the shared transcript planner and rendered by both slideshow hosts. Bounded `STYLE` / `::cue(.class)` rules now also apply foreground color, background color, bold, italic, and underline to matching cue spans. The existing plain cue text, positioning, writing direction, SRT behavior, TTML behavior, and package bytes remain unchanged.

Voice, language, and class metadata remain available to consumers, while unsupported CSS declarations and selectors remain source-preserved and text-neutral. This slice does not claim full CSS/WebVTT region styling or PowerPoint-authoritative caption typography.

## Verification

- `PresentationMediaTranscriptPlannerTests`: 19/19, including CSS class parsing and STYLE-block preservation on internal-track replacement.
- Full `FreeP.App.Presentation.Tests`: 3705/3705.
- `SlideShowTests`: WPF caption overlay emits styled runs and brushes, focused filter 2/2.
- `AvaloniaMediaPlaybackAdapterTests`: focused controller filter 10/10.
- Release builds: `FreeP.App.Host` and `FreeP.App.Avalonia` 0 warnings/0 errors.
