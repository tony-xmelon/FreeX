# FreeP explicit Surface3D view boundary

The canonical imported `25-chart-surface3d-view3d.pptx` still had a coupled
projected-mesh error after the accepted light-orange, dark-brown, and
dark-green facet corrections. The WPF-only exact authored Surface3D guard now
uses the measured left boundary of the dark-brown face and the right boundary
of the light-orange face. The shared mesh, Avalonia path, generic Surface3D
routes, and camera-independent paths remain unchanged.

The WPF polygons changed as follows:

- `#DB742C`: `(39,99),(165,53),(200,58),(283,133),(263,154)` to
  `(32,104),(165,50),(200,58),(283,133),(263,154)`;
- `#EB7C30`: the fifth point `(196,72)` to `(205,72)`.

Fresh matching 1280x720 PowerPoint evidence from the rebuilt Release
consumer, relative to the accepted dark-green artifact:

| Measure | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.7641% | 2.7614% |
| Surface ROI `(560,70)-(1030,330)` | 5.3800% | 5.3596% |
| Orange ROI `(600,150)-(830,240)` | 6.7970% | 6.6777% |
| Brown ROI `(740,170)-(830,265)` | 2.9618% | 2.8873% |
| Green ROI `(780,120)-(920,190)` | 4.3772% | 4.3772% |
| Paired mesh ROI `(620,150)-(900,270)` | 6.9135% | 6.8392% |

Exact-color masks after the correction versus PowerPoint:

- `#DB742C`: PowerPoint `2720 px`, bbox `(635,158)-(835,259)`; WPF
  `2915 px`, bbox `(631,157)-(877,257)`;
- `#EB7C30`: PowerPoint `2498 px`, bbox `(635,175)-(783,210)`; WPF
  `2420 px`, bbox `(635,175)-(775,210)`;
- `#B35E24`: PowerPoint `3332 px`, bbox `(751,177)-(814,259)`; WPF
  `2921 px`, bbox `(751,185)-(811,259)`;
- `#91B57C`: PowerPoint `947 px`, bbox `(797,136)-(888,166)`; WPF
  `837 px`, bbox `(799,136)-(885,164)`.

The exact authored target improves without a coupled-material ROI regression.
Fresh WPF `22`/`26` and Avalonia `25` controls are SHA-256 byte-identical to
detached same-commit controls:

```text
22  05EE990EBDD9382091AA1BEB815FE529C7210E210BA280A400D2C1E53000858C
26  160D3F12DB4371EF5118414BCF1CE52E81F89F23A3454AE22F14092C7334E076
av25 38B7115D1319B6CFEC560013A2F7A9E73C44AD7159EBF3682B871731A28119E9
```

Focused `ChartBaselineCorpusTests` passed `31/31` with compilation and
`31/31` with `--no-build`. The consuming `FreeP.RenderCompare` Release build
completed with `0` warnings and `0` errors.
