# FreeP Avalonia baseline-script whitespace parity - 2026-07-20

This slice fixes an imported DrawingML baseline-run gap in the Avalonia renderer.
PowerPoint's `24-run-baseline-wrap.pptx` contains separate runs with authored
`a:rPr/@baseline` values (`brown=-25000`, `lazy=30000`). The WPF renderer already
preserved those script offsets, but Avalonia measured each wrapped token with
`FormattedText.Width`, which trims trailing whitespace. That removed the spaces
between independently drawn runs and changed the line breaks.

The Avalonia baseline path now measures trailing-space tokens with a sentinel
glyph and retains the authored whitespace advance for both line wrapping and
run placement. The correction is limited to baseline-aware text; ordinary text
and other render routes are unchanged.

## Fresh PowerPoint gate

All captures used the same Release artifact and a fresh PowerPoint COM export at
1280x720:

| Corpus | WPF before/after | Avalonia before | Avalonia after |
|---|---:|---:|---:|
| `24-run-baseline-wrap` | 0.6948% / 0.6948% | 0.9640% | 0.8769% |
| `23-run-baseline` control | 0.0328% / 0.0328% | 0.0976% | 0.0872% |

The affected slide now preserves visible spaces and script placement in both
hosts. The remaining difference is host glyph rasterization, not missing
baseline semantics.

## Verification

- `SlideCanvasMathBaselineTests`: 2/2 focused baseline tests.
- `FreeP.App.Rendering.Avalonia.Tests`: 149/149.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh COM comparisons: `24-run-baseline-wrap` and `23-run-baseline`.
