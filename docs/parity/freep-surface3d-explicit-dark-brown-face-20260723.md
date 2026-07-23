# FreeP explicit Surface3D dark-brown face

The authored `25-chart-surface3d-view3d.pptx` WPF-only facet path still
under-covered the near-left dark-brown `#B35E24` fold. The replacement was
expanded from the prior five-vertex approximation to the measured projected
edge polygon for the exact authored camera signature. Shared mesh geometry,
Avalonia rendering, chart frame/labels, and all other Surface3D paths remain
unchanged.

Fresh matching 1280x720 PowerPoint comparisons from the rebuilt Release
consumer, relative to the accepted orange-face artifact:

| Measure | Before | After |
| --- | ---: | ---: |
| WPF whole slide | 2.7916% | 2.7746% |
| WPF brown-face ROI `(740,170)-(830,265)` | 4.8025% | 2.9618% |
| WPF exact brown pixels | 2,537 | 2,921 |

PowerPoint contains 3,332 exact brown pixels at `(751,177)-(814,259)`;
the candidate is 2,921 pixels at `(751,185)-(811,259)`. The remaining upper
edge mismatch is coupled to neighboring projected facets and is intentionally
not addressed by a global translation.

WPF `22`/`26` and Avalonia `25` controls were SHA-256 byte-identical to their
accepted baselines. Focused chart planner/corpus tests passed `224/224` with
compilation and `224/224` with `--no-build`; the consuming `FreeP.RenderCompare`
Release build completed with zero warnings and errors.
