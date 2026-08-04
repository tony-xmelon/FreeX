# FreeP Media Caption Cue Semantics

## Scope

The shared transcript planner now retains WebVTT cue-span semantics for speaker
voice tags, language tags, and CSS class tags. Both spaced forms such as
`<v Speaker>` and `<lang en-GB>` and dotted forms such as `<v.Speaker>` and
`<lang.en-GB>` are exposed on each parsed cue span.

The authored `WebVttMarkup` remains the serialization authority, so this slice
does not rewrite caption bytes or claim new PowerPoint visual styling. WPF and
Avalonia continue to render the existing bold/italic/underline subset while
downstream accessibility or caption-style consumers can now inspect the
preserved semantic context.

## Verification

- `PresentationMediaTranscriptPlannerTests`: 18/18 focused, then 3,704/3,704 full presentation suite.
- Nested `<v>`, `<lang>`, and `<c.class>` scopes are covered by the focused fixture.
- No raster or PowerPoint COM claim is made by this functional slice.
