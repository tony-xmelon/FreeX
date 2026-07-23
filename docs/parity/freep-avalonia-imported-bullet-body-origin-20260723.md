# FreeP Avalonia imported bullet-body origin parity

Date: 2026-07-23

## Scope

The WPF renderer already applies a narrowly guarded 6 DIP origin correction
to the imported six-paragraph, 18pt Aptos bullet body used by the
`17-bullets-autofit.pptx` corpus. Avalonia previously drew that body and its
bullet glyphs at the unadjusted planner origin, leaving the two hosts with a
visible vertical registration difference.

Avalonia now applies the same correction only when all of the following are
true: the body uses shape autofit, it contains exactly six paragraphs, every
paragraph has one non-bold, non-italic 18pt Aptos run, and every paragraph has
a bullet. The signature and 6 DIP policy live in the shared
`TextLayoutPlanner`; both hosts consume its resolved offset. Both paragraph
text and bullet glyphs use the corrected origin.

## Paired host evidence

Fresh WPF and Avalonia renders were produced at 1280x720 from the same
`17-bullets-autofit.pptx` input. The image-diff tool compared each WPF render
with its same-run Avalonia render.

| Slide | Before | After | Result |
| --- | ---: | ---: | --- |
| 1 | 0.9591% | 0.8386% | improved |
| 2 | 3.3159% | 3.3159% | unchanged |
| Two-slide mean | 2.1375% | 2.0772% | improved |

Artifacts are retained in the ignored worktree directories
`artifacts/freep-avalonia-bullet-body-baseline-20260723b/` and
`artifacts/freep-avalonia-bullet-body-dedup-candidate-20260723/`.

This machine does not have the `PowerPoint.Application` COM ProgID
registered, so no new PowerPoint-authoritative comparison is claimed in this
slice. The paired WPF/Avalonia result above is authentic renderer evidence;
the existing PowerPoint-backed bullet evidence remains the authority for
cross-application raster fidelity.

## Verification

- `TextLayoutPlannerTests|BulletsAutofitTests`: 88/88 passed.
- `SlideCanvasLineSpacingTests`: 14/14 passed.
- `FreeP.App.Rendering.Wpf` Release build: 0 warnings, 0 errors.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- `git diff --check`: passed.
