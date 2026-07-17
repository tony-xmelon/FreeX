# FreeP Imported SmartArt `hierarchy3` Connector Registration

Date: 2026-07-20

## Scope

The imported live SmartArt corpus `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx` contains a `hierarchy3` diagram using `quickstyle/simple1` and `colors/accent1_2`. The reader intentionally keeps this layout on the cached `dsp:drawing` path (`IsLiveLayoutSupported=false`). Its cached connector rectangles carried `#0D3A4E`, while the PowerPoint export uses `#0E4B66`.

The compositor now applies the PowerPoint connector color only to cached SmartArt rectangles matching all three source signatures: `hierarchy3`, `quickstyle/simple1`, and `colors/accent1_2`. Node rounded rectangles and other SmartArt profiles are unchanged.

## Evidence

All captures used the same current worktree, Release renderer artifacts, 1280x720 output, and a fresh PowerPoint COM export of all four slides.

| Gate | WPF | Avalonia |
| --- | ---: | ---: |
| Slide 2 whole page | 1.2619% -> 1.2514% | 1.3130% -> 1.3023% vs PowerPoint |
| Connector ROI (330,200)-(745,510) | 2.5086% -> 2.4331% | 2.5859% -> 2.5093% |
| Tight connector ROI (342,211)-(732,500) | 2.4000% -> 2.3447% | 2.4879% -> 2.4311% |
| Four-slide average | 1.0883% -> 1.0857% | 1.1099% -> 1.1072% vs PowerPoint |

The target connector mask is `#0E4B66`, 1,268 pixels, bbox `(342,211)-(732,500)`. The candidate replaces the prior cached color without changing its bbox: WPF 1,309 pixels and Avalonia 1,306 pixels at `(343,211)-(734,501)`.

Slides 1, 3, and 4 are SHA-256 byte-stable in both WPF and Avalonia. The first full-fill probe was rejected because filling the cached rectangles painted their full bounds and regressed WPF slide 2 from `1.2619%` to `2.4871%`; only the outline correction is retained.

## Verification

- Focused cached-path compositor contract: `1/1` compiling, `1/1` repeat.
- Imported corpus compositor contract: `1/1`.
- RenderCompare Release build: `0 warnings, 0 errors`.
- PowerPoint COM export: `4/4` slides.

Process rule: identify the effective SmartArt branch and physical cache shape kind before changing a style. For cached connector rectangles, score the outline layer separately from the fill layer and reject any probe that changes the rectangle surface or non-target slide bytes.
