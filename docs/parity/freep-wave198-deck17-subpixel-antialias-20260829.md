# FreeP Wave198 deck17 subpixel antialias probe

Date: 2026-08-29
Base revision: `557284b69c`
Corpus: `17-bullets-autofit.pptx`, 1280x720

## Candidate

Wave198 measured Avalonia's renderer-level `SubpixelAntialias` text mode for
the existing fixed-size, single-column, no-autofit, non-bullet 18pt Aptos body
fallback. The candidate changed only the Avalonia `TextOptions.TextRenderingMode`
inside that already scoped route; the shared text layout, Arial fallback,
`0.930` optical scale, Light hinting, paragraph leading, and unaligned baseline
were unchanged. WPF stayed on its existing renderer path.

## Decision

The candidate is rejected. It improves the target's Avalonia/Office mean channel
diff from `2.4820%` to `2.4583%` (`-0.0237` percentage points), but worsens the
target WPF/Avalonia pair from `2.8755%` to `2.8847%` (`+0.0092` points).
WPF/Office remains `3.0587%`. The slide 01 control is byte-identical before
and after the probe (`0.8339%` Avalonia/Office; `0.0000%` before/after).

The accepted grayscale `Antialias` mode remains in production. The candidate's
target improvement is not sufficient to accept a renderer change that moves the
Avalonia output farther from the representative WPF renderer.

## Evidence boundary

Generation linkage is intentionally recorded as `not-independently-proven`.
The note describes the temporary `TextRenderingMode` change and the focused
render commands that were run, but the retained bundle does not contain an
exact candidate-source-byte or patch hash or a captured generation log that
binds those inputs to these PNG bytes. The corpus SHA-256, Office reference
SHA-256, candidate PNG hashes, and heatmap hashes verify the retained inputs
and outputs only; they do not claim that a future machine will reproduce
identical Skia glyph coverage.

Machine-readable metrics, hashes, candidate PNGs, and target heatmaps are in
`docs/parity/evidence/freep-wave198-deck17-subpixel-antialias-20260829/`.

## Remaining hypothesis

The residual remains a renderer-level glyph-coverage difference. Subpixel
coverage is directionally closer to Office for this target but is not a safe
general correction because it increases WPF/Avalonia disagreement. The next
useful probe should measure a supported native Aptos/resource route or an
independently measured host glyph raster implementation, with per-glyph edge
coverage and font availability recorded; no fixture-specific condition is
justified.

## Verification

- Focused `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Candidate Avalonia and WPF renders completed at 1280x720.
- Candidate slide 01/02 Office and WPF/Avalonia diffs completed.
- Candidate slide 01 before/after diff: `0.0000%`, max channel `0`.
- Candidate slide 02 before/after diff: `0.5355%`, max channel `239`.
- Production source restored to grayscale `Antialias`; no Office reference,
  WPF renderer, shared planner, or cross-app file changed.
