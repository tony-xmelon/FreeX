# FreeP Wave197 baseline alignment probe

Date: 2026-08-29

## Candidate

The existing fixed-size, single-column, no-autofit, non-bullet 18pt Aptos
fallback route already uses the measured Arial scale, antialiasing, Light
hinting, and unaligned baseline pixels. Wave197 tested the general renderer
semantic of changing only that route's `BaselinePixelAlignment` to `Aligned`.
The font scale, paragraph leading, layout plan, WPF renderer, and all other
Avalonia routes were unchanged.

## Decision

The candidate is rejected. The slide01 control remained byte-identical to the
accepted Avalonia output, but the slide02 target worsened from `2.4820%` to
`2.5116%` against Office. The WPF/Avalonia pair also worsened from `2.8755%`
to `2.9053%`; WPF/Office stayed `3.0587%`. The accepted unaligned baseline
setting is restored.

This rules out baseline pixel alignment as the next general correction for the
residual. Together with the retained leading, font-family, draw-scale, weight,
vertical, and hinting probes, the measured boundary is now the fallback glyph
raster rather than paragraph cadence or placement.

Machine-readable metrics and candidate PNGs are in
[`metrics.json`](./evidence/freep-wave197-deck17-baseline-alignment-20260829/metrics.json)
and the adjacent evidence directory.
