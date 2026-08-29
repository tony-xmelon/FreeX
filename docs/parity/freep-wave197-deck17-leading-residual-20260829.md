# FreeP Wave197 deck17 leading residual

Date: 2026-08-29
Recorded source revision: `a43d86c885`
Corpus: `17-bullets-autofit.pptx`, 1280x720

## Candidate

Wave197 tested the general renderer-level hypothesis that the accepted `0.930`
Avalonia Aptos fallback scale should apply to paragraph leading as well as glyph
size. The target body is a fixed-size, single-column, no-autofit, non-bullet
18pt Aptos layout. The candidate would change its authored `28.8 DIP` leading
to `26.784 DIP`.

## Decision

The candidate is rejected. The retained Office reference and Wave196 Avalonia
render have identical starts for all 16 body ink bands. Applying the scaled
leading would accumulate `30.24 DIP` of baseline drift by the final band, so it
would damage stable paragraph geometry rather than explain the remaining
residual. The renderer now makes this separation explicit: optical glyph scale
does not alter authored paragraph leading.

The Wave196 control remains unchanged: slide 01 Avalonia before/after is
`0.0000%` with maximum channel delta `0`, while slide 02 remains
`2.4820%` Avalonia/Office and `2.8755%` WPF/Avalonia. No production raster
correction is accepted in Wave197.

## Evidence boundary

The recorded source revision is provenance metadata only. The commit-resolution
check proves that `a43d86c885` names a Git commit, while the SHA-256 values in
`imageIntegrity` prove the current tracked bytes of the retained PNGs. Neither
claim proves that those images were generated from that revision. No verifiable
renderer/config/source-tree hashes or deterministic regeneration evidence is
recorded, so generation linkage is not independently proven.

Machine-readable evidence and the retained image/reference provenance are in
[`metrics.json`](./evidence/freep-wave197-deck17-leading-residual-20260829/metrics.json).

## Remaining residual

The remaining slide02 difference is an unresolved text-raster residual. Its
pixel concentration is consistent with small per-glyph edge/row coverage
differences, but the evidence does not identify fallback glyph raster as the
cause. The available general typography probes have now rejected structure,
line spacing, font family substitution, draw-time width/weight, vertical
alignment, and scaled leading. A further improvement needs a supported Aptos
font/resource route or an independently measured host text implementation; no
corpus-specific condition is justified.
