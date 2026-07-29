# FreeW Wave57: Rich Floating Shape Text

Wave57 keeps floating shape and text-box text in one shared presentation contract:

- `DrawingObjectTextPlan` preserves paragraph, run, formatting, and text-direction semantics.
- `DrawingObjectTextLayoutPlanner` supplies wrapping, paragraph breaks, glyph bounds, and caret stops.
- WPF maps the plan to clipped per-glyph `TextBlock` fragments.
- Avalonia maps the same plan to `FormattedText`, caret hit testing, drag selection, and selection paint.

The adapters own only platform font measurement, drawing primitives, decoration strokes, and the rotated
shape transform. Font family, point size, bold, italic, underline, strike-through, foreground color,
horizontal wrapping, paragraph breaks, and 90/270-degree text all remain plan inputs. Shape geometry,
placement, clipping, movement, editing commands, and undo continue to use their existing paths.

Focused parity tests live in `FreeW.App.Presentation.Tests`, `FreeW.App.Host.Tests`, and
`FreeW.App.Avalonia.Tests`.
