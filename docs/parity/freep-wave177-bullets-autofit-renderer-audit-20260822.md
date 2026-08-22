# FreeP Wave177 bullets/autofit renderer audit

Date: 2026-08-22

## Scope

The target is `17-bullets-autofit/slide-02`, the largest current WPF versus Avalonia renderer-pair delta in the PowerPoint recalibration. The fixture is `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx` and the committed Office reference is `tools/FreeP.RenderCompare/corpus/pptx-ref/17-bullets-autofit/slide-02.png`.

The target body contains eight paragraphs, one run per paragraph, with 18pt theme-body text and `a:noAutofit`. It has no authored font scale or line-spacing override. The shared `TextLayoutPlanner` therefore correctly preserves the imported no-autofit semantics; it does not apply runtime shrink or shape growth. The slide is part of the bullets/autofit fixture family, although the target slide itself has no authored bullet glyphs.

## Fresh baseline

Fresh WPF and Avalonia renders were compared with the committed 1280x720 Office reference at the same size:

| slide | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | ---: | ---: | ---: |
| slide-01 | 0.8441% | 0.8537% | 0.8386% |
| slide-02 | 3.0587% | 3.1232% | 3.1323% |

The committed recalibration records the rounded slide-02 pair value as 3.1324%.

## Investigation

- The shared planner and both renderers preserve the same no-autofit paragraph flow and line cadence. The residual heatmap is concentrated on text glyph rasterization rather than a changed text-box geometry.
- Avalonia's existing Aptos to Arial fallback at 0.95 scale is the current best supported fallback in this codebase. Earlier evidence records why it was retained.
- WPF has a narrowly scoped imported-Aptos body paint policy: Light weight plus a 1.016 horizontal draw scale. That policy is host-specific and does not change layout measurement.
- Porting that policy to Avalonia was tested and rejected: slide-02 Avalonia versus Office became 3.6208%, with a 3.3449% WPF/Avalonia pair delta.
- Removing the Light weight but retaining the width scale produced 3.6209%.
- Changing fixed no-autofit line spacing from 1.20 to 1.21 produced 3.5344%.
- Mapping Aptos to Calibri at 1.0 produced 3.9395% on slide-02 and 1.0304% on the slide-01 control.

None of those candidates improved the Office gate, and none changed the model or shared planning semantics.

## Decision

No production correction is shipped in this slice. The evidence supports a residual caused by the unavailable proprietary Aptos font and host-specific text rasterization, not a source-owned bullets/autofit behavior error. A scalar or global pixel calibration would be unsupported and would violate the renderer evidence gate.

## Verification and residuals

- The accepted Avalonia source and its existing focused tests were restored after each candidate experiment.
- `SlideCanvasLineSpacingTests`: 14 passed. `BulletsAutofitTests`: 56 passed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh 1280x720 WPF and Avalonia renders reproduce the baseline above. Direct diffs report WPF slide-02 at 3.0587%, Avalonia slide-02 at 3.1232%, and the renderer pair at 3.1324%.
- PowerPoint COM is unavailable on this machine, so the final run used the committed Office PNGs as the reference. This is a machine prerequisite limitation, not a renderer test failure.
- No generated recalibration artifact is changed because the verified implementation is unchanged.
- A future evidence-backed improvement would require an authoritative Aptos font/resource route or a host-supported font implementation. The slide-02 renderer-pair residual therefore remains at approximately 3.1324%.
