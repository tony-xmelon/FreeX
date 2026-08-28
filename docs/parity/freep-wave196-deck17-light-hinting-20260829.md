# FreeP Wave196 deck17 light-hinting correction

Date: 2026-08-29
Base revision: `ef7c2de4348ee09276f444662d678ce80a03281e`
Corpus: `17-bullets-autofit.pptx`, 1280x720

## Decision

Wave196 retains a renderer-level correction for Avalonia's unavailable-Aptos
fallback. Fixed-size, single-column, no-autofit, non-bullet 18pt Aptos body
text continues to use Arial at the measured `0.930` scale with grayscale
antialiasing and unaligned baseline pixels. Its hinting mode changes from
`None` to Avalonia's `Light` mode.

The gate is based only on resolved presentation semantics. It does not inspect
the fixture name, slide number, text, screenshot hash, or pixel coordinates.
Mixed-font, bullet, autofit, multi-column, non-18pt, and Aptos Display text
remain on their existing routes.

## Measurement

Fresh current-source WPF and Avalonia renders reproduce the retained Wave193
baseline before the correction. The accepted output improves both target
comparisons while leaving slide 01 pixel-identical:

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 01 WPF vs Office | 0.8441% | 0.8441% | 0.0000 pp |
| Slide 01 Avalonia vs Office | 0.8339% | 0.8339% | 0.0000 pp |
| Slide 01 WPF vs Avalonia | 0.8439% | 0.8439% | 0.0000 pp |
| Slide 02 WPF vs Office | 3.0587% | 3.0587% | 0.0000 pp |
| Slide 02 Avalonia vs Office | 2.5360% | **2.4820%** | **-0.0540 pp** |
| Slide 02 WPF vs Avalonia | 2.9091% | **2.8755%** | **-0.0336 pp** |

The slide 01 Avalonia before/after diff is exactly `0.0000%`, maximum channel
delta 0. The slide 02 before/after diff is `0.3998%`, maximum channel delta
223, localized to the body glyph raster.

## Exhausted alternatives

Wave194 topology already rules out structure, autofit, and theme inheritance.
Wave177-Wave193 evidence rejects the WPF Light/width paint policy on Avalonia,
the related width-only path, line spacing `1.21`, Calibri substitution, WPF's
Aptos-to-Arial substitution, and WPF vertical/display/centered-height probes.
The current host has no Aptos font file available to the renderer, so direct
native-face rendering is not an executable correction here.

The machine-readable bundle records those hypotheses, exact metrics, retained
PNG hashes, the accepted Avalonia output, and target heatmaps under
`docs/parity/evidence/freep-wave196-deck17-light-hinting-20260829/`.

## Verification

- Focused `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- `SlideCanvasAptosRasterPolicyTests`: 8/8 passed.
- Wave196 renderer/evidence tests: 10/10 passed in the combined focused lane.
- Wave196 resolved-model guard: 1/1 passed.
- Fresh WPF/Avalonia slide 01/02 renders completed at 1280x720.
- Direct Office and renderer-pair diffs produced the metrics above.
- No Office reference, WPF renderer, shared planner, or cross-app file changed.
