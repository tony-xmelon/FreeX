# FreeP Surface3D Explicit Wireframe Parity

## Scope

The authored `25-chart-surface3d-view3d.pptx` fixture contains
`c:surface3DChart/c:wireframe val="0"`, while the default imported Surface3D
fixture omits the token. FreeP previously rendered the default surface mesh and
the internal wall grid for both cases.

The chart model and DOCX-style package path now preserve the authored
`wireframe` value and its presence. The shared planner suppresses the surface
mesh and internal wall grid only when the explicit value is false, retaining the
outer frame and leaving the omitted-token default path unchanged.

## Evidence

Fresh matching PowerPoint export and same-artifact WPF/Avalonia capture at
1280x720:

| Fixture | WPF before | WPF after | Avalonia before | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| `25-chart-surface3d-view3d` | 3.8984% | 3.8269% | 3.7601% | 3.6949% |
| `22-chart-baseline-depth` control | 2.5856% | 2.5856% | 2.2959% | 2.2959% |
| `26-chart-surface3d-default-tall-frame` control | 2.8158% | 2.8158% | 2.6326% | 2.6326% |

The explicit-camera planner contract reads `wireframe=0`, emits no mesh
segments, and emits five outer-frame segments. The controls retain their
existing geometry.

## Verification

- `FreeP.App.Presentation.Tests` explicit-camera corpus test: 1/1 compiled and 1/1 no-build
- `FreeP.App.Host.Tests` explicit wireframe package round-trip: 1/1 compiled and 1/1 no-build
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors
