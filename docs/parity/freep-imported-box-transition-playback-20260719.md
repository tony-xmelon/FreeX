# FreeP imported Box transition playback - 2026-07-19

## Scope

PowerPoint `p:box` transitions were preserved by PPTX IO but were routed
through the generic fade fallback during slideshow playback. Box now has a
dedicated renderer-neutral action. The shared planner uses the same center-box
direction convention as shape animations: `dir="in"` expands from the center,
`dir="out"` contracts toward it, and an omitted direction defaults to expand.

## Host behavior

WPF and Avalonia place the incoming slide above the captured prior slide and
animate a centered rectangular clip. The shared mask planner owns the box
geometry and each host uses its native rectangle animation API; the prior slide
remains visible underneath until the incoming clip completes.

## Verification

- Shared presentation planner, host planner, and mask tests: `106/106`
  compile-first and no-build.
- WPF transition/package/source-contract tests: `122/122` compile-first and
  no-build.
- Avalonia host source-contract tests: `3/3` compile-first and no-build.
- Affected Presentation, WPF, and Avalonia projects built with `0` warnings
  and `0` errors in the focused commands.

PowerPoint-authoritative frame captures were not added in this slice, so exact
3-D box perspective, easing, timing, and frame-by-frame raster parity remain an
evidence follow-up rather than a claim.
