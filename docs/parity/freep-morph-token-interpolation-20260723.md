# FreeP Morph Token Interpolation

## Scope

The shared Morph planner now exposes ordered word and character correspondences
for matched text shapes. Correspondences are produced with an ordered LCS pass,
preserving source and target offsets and lengths for deterministic playback.

Both WPF and Avalonia consume those matches. Each matched text shape receives a
separate target-shape background overlay, followed by text-only token overlays
that animate from estimated source token bounds to target token bounds. The
token overlays retain the target run's first-run formatting while avoiding a
second fill, outline, or effect paint over the background. Object-level Morph
and ambiguous/no-match fallback behavior remain unchanged.

This is a functional and architectural Morph step, not a claim of exact
PowerPoint raster parity. Token bounds currently use the shared host geometry
estimate; real PowerPoint text layout, group-child matching, and authenticated
PowerPoint frame comparisons remain follow-up work.

## Verification

- `SlideShowPlaybackPlannerTests`: **72/72**.
- Focused WPF Morph/source contracts: **3/3**.
- Focused Avalonia Morph/source/runtime contracts: **4/4**.
- WPF Release host build: **0 warnings, 0 errors**.
- Avalonia Release host build: **0 warnings, 0 errors**.

The runtime checks exercise `byWord` token-overlay playback in both hosts. No
new PowerPoint COM visual frame was captured for this slice, so no raster delta
is attributed to the change.
