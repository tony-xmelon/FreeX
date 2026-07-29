# Avalonia Both-Sides Square Wrap

## Scope

The exact `wordart-watermark-stress.docx` package contains a green floating text
box with `wp:wrapSquare wrapText="bothSides"`. Word places part of an ordinary
body line in the narrow left gap and continues that same line in the right gap.

Avalonia previously chose only the larger free side. The shared layout planner
now exposes a two-fragment line plan for one active square/tight `bothSides`
float. The Avalonia text path consumes it only for plain left-aligned,
tab-free paragraphs; tabs, non-left alignment, indents, and overlapping floats
retain the established one-fragment behavior.

## Matched Evidence

The Word target and Avalonia candidate are the same 816x1056 serialized fixture
and cached manual Word PDF raster. The same-session pre-change artifact was
rebuilt before measuring the candidate.

| Metric | Before | After |
| --- | ---: | ---: |
| Whole page mean RGB difference | 4.9885% | 4.8679% |
| Green square-wrap ROI, (90,275)-(720,360) | 8.9522% | 7.7136% |
| Broader body ROI, (90,300)-(720,430) | 7.5375% | 6.2268% |
| Review Copy ROI, (430,350)-(710,440) | 2.8242% | 2.8236% |

The independent `wordart-picture-watermark-layout.docx` control stayed
SHA-256 identical after a fresh render:
`4F6A48CFBD568A5BDED52B71AA929A2640D58F423920CC6DB839EBDDE2CAFAE7`.

## Verification

- `DocumentViewLayoutPlannerTests`: 29/29 from a fresh build and no-build rerun.
- `DocumentViewWrapExclusionTests`: 14/14 from a fresh build and no-build rerun.
- The new renderer contract verifies that one line contains glyphs before and
  after a centered `bothSides` square float without placing glyphs through it.
