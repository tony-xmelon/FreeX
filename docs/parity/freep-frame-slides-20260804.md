# FreeP handout Frame Slides execution

Date: 2026-08-04

## Scope

The shared PowerPoint print request already exposed `FrameSlides`, and the
Backstage planner displayed the option, but the handout PDF compositor always
painted a slide border. The option therefore had no effect on the generated
print package or the native WPF handoff.

Handout rendering now consumes `PresentationPrintPlan.Options.FrameSlides`:

- `true` emits the existing half-point slide frame around each handout slide.
- `false` omits that frame while preserving slide content, notes lines, and
  page geometry.

Notes pages retain their standard slide and notes placeholder borders; this
option is specifically a handout slide-frame setting.

## Verification

- `HandoutPdfRenderPlan_WithoutFrameSlides_OmitsSlideBorders` proves the
  disabled path.
- Existing three- and six-slides-per-page tests explicitly enable the option
  and continue to prove framed handouts.
