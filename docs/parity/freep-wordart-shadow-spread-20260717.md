# FreeP WordArt shadow effective spread

Date: 2026-07-17
Branch: `codex/freep-parity-surface3d-shading-next-20260716`
Corpus: `tools/FreeP.RenderCompare/corpus/13-wordart.pptx`

## Finding

The imported `Text Shadow` shape uses a 5pt PowerPoint blur. FreeP renders
blurred text shadows with translated glyph rings because the renderer-neutral
plan has no native blur filter. The authored offset, alpha, color, and core
shadow were already aligned, but the full authored blur radius used as the
outer ring spread made the WPF halo extend beyond the PowerPoint raster.

## Change

The shared `TextRunEffectRenderPlanner` preserves the authored ring geometry
and carries each blur pass's core offset. WPF applies `0.6 * authoredBlur` only
when translating those rings into its glyph drawing context. This affects
blurred text shadows only; ordinary text, fills, outlines, reflections, shape
effects, and Avalonia retain their existing paths.

## Matched COM evidence

At 1280x720 against the persistent PowerPoint COM baseline, with fresh WPF
renders from the rebuilt dependency:

| ROI | Before | After |
| --- | ---: | ---: |
| WordArt whole page | 1.6557% | 1.6544% |
| Text Shadow `(600,75)-(935,135)` | 14.8133% | 14.7665% |
| Gradient `(50,65)-(560,148)` | 9.4383% | 9.4383% |
| Outline `(45,220)-(570,315)` | 9.0188% | 9.0188% |
| Arch `(690,215)-(1130,335)` | 2.7883% | 2.7883% |
| Wave `(460,365)-(800,470)` | 1.5717% | 1.5717% |

The unrelated `08-effects.pptx` WPF control was SHA-256 byte-identical.
The matching Avalonia WordArt render was SHA-256 byte-identical before and
after the WPF-local calibration.

## Verification

- Focused `WordArtTests|RendererNeutralDedupPlannerTests`: 48/48.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh current-compositor WPF renders completed with opaque pixel-diversity
  checks.
- Candidate and baseline render paths used the same WPF compositor; no
  software-fallback path was used.
