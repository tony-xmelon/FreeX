# FreeP media caption inline styling

## Scope

Native WebVTT cue markup for the basic `<b>`, `<i>`, and `<u>` tags is now retained by the shared transcript planner and rendered by both slideshow hosts. The existing plain cue text, positioning, writing direction, SRT behavior, TTML behavior, and package bytes remain unchanged.

Unsupported WebVTT voice, language, and class tags remain text-neutral. This slice does not claim full CSS/WebVTT region styling or PowerPoint-authoritative caption typography.

## Verification

- `PresentationMediaTranscriptPlannerTests`: styled WebVTT spans, HTML entity decoding, and plain SRT behavior.
- `SlideShowTests`: WPF caption overlay emits bold, italic, and underlined runs.
- Release builds: `FreeP.App.Presentation`, `FreeP.App.Presentation.Tests`, `FreeP.App.Host`, and `FreeP.App.Avalonia`.
