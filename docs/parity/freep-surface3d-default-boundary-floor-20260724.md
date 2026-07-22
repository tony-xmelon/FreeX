# FreeP Surface3D default boundary-floor registration

Date: 2026-07-24

## Scope

Imported 3x3 `Surface3D` charts without authored `c:view3D` settings use a
measured Office boundary-face plan. The old path scaled those reference points
from the plot's top edge, which stretched the boundary faces upward when a
chart frame became taller. `BuildImportedSurfaceBoundaryFacets` now preserves
the canonical transform for plots at or below the 360x189-DIP reference and
anchors taller frames to the current plot floor.

The authored-camera path is unchanged. The additional evidence fixture is a
valid OPC copy of `22-chart-baseline-depth.pptx` with only the Surface graphic
frame changed from 360x216pt at (414,36) to 300x240pt at (444,24). Its chart
part still has no `c:view3D`. PowerPoint opened the package and exported the
one-slide reference successfully.

## Fresh matched evidence

All images are 1280x720 and use the same Release RenderCompare artifact and a
fresh PowerPoint COM export.

| Case / region | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| Canonical whole slide | 2.5856% | 2.5856% | 1.0919% | 1.0919% |
| Canonical surface ROI | 4.9386% | 4.9386% | 4.8853% | 4.8853% |
| Tall-frame whole slide | 2.9745% | 2.8158% | 1.0900% | 1.0886% |
| Tall-frame surface ROI | 7.8490% | 6.4349% | 7.7683% | 6.3493% |
| Tall-frame tight mesh ROI | 9.9869% | 8.0642% | 9.8505% | 7.9211% |

The stock control ROI stayed byte-stable. The authored `view3D` control also
remained at 3.8984% WPF and 1.1290% Avalonia, confirming that the correction is
restricted to the imported default-camera boundary path.

Fixture SHA-256: `267079B992F582A0346F95E3A4F3E88613625F38BA055C56328A30657474EC6E`.
PowerPoint reference PNG SHA-256:
`23ACDA983859C92BFE978982E3C749AB96063E039C86665FDBB16245676E0503`.

## Verification

- `ChartRenderPlannerTests` Surface filter: 25/25 passed.
- Presentation test build: 0 warnings, 0 errors.
- RenderCompare Release build: 0 warnings, 0 errors.
- Fresh COM exports: canonical, tall-frame, and authored-view controls, 1/1
  slide each.
