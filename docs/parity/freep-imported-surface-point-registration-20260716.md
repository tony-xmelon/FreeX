# FreeP imported Surface3D point registration

Date: 2026-07-16

## Evidence

Fresh PowerPoint COM export of `22-chart-baseline-depth.pptx` was compared with
the current WPF and Avalonia renders at `1280x720`. Registration of the
saturated Surface3D face mask showed the FreeP mesh was consistently about
`2` pixels left and `4` pixels below the PowerPoint face geometry. The
surface-mask IoU improved from `0.8186` to `0.8270` for WPF and from `0.8054`
to `0.8132` for Avalonia after applying the measured point correction.

## Change

Imported Surface3D projected points now receive a shared `(x=+2, y=-4)` pixel
registration offset. The offset is limited to imported `Surface3D` points;
authored surfaces and the projected frame keep their existing paths.

## Fresh COM comparison

| Deck | WPF average | Avalonia average | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `22-chart-baseline-depth.pptx` before | `3.5904%` | `0.9776%` | `3.4814%` |
| `22-chart-baseline-depth.pptx` after | `3.5764%` | `0.9772%` | `3.4680%` |

PowerPoint exported the deck successfully with no hang.
