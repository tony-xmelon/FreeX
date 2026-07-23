# FreeP explicit Surface3D dark-green strip

The authored `25-chart-surface3d-view3d.pptx` WPF-only facet path still
under-covered the narrow dark-green `#91B57C` strip at the rear edge of the
mesh. The replacement was a three-point triangle; PowerPoint owns a longer
thin trapezoid. The exact-camera path now uses the measured 11-point
projected footprint.

The shared mesh, Avalonia rendering, frame, labels, and generic/default
Surface3D routes remain unchanged.

Fresh matching 1280x720 PowerPoint comparisons from the rebuilt Release
consumer, relative to the accepted dark-brown-face artifact:

| Measure | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.7746% | 2.7641% |
| WPF green-strip ROI `(780,120)-(920,190)` | 5.3592% | 4.3772% |
| WPF exact dark-green pixels | 477 | 837 |

PowerPoint contains 947 exact dark-green pixels at `(797,136)-(888,166)`;
the candidate is 837 pixels at `(799,136)-(885,164)`. The remaining edge
error is retained as coupled projected-mesh evidence rather than generalized
to other cameras.

WPF `22`/`26` and Avalonia `25` controls were SHA-256 byte-identical to their
accepted baselines. Focused chart planner/corpus tests passed `224/224` with
compilation and `224/224` with `--no-build`; the consuming `FreeP.RenderCompare`
Release build completed with zero warnings and errors.
