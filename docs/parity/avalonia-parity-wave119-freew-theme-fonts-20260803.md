# Avalonia parity Wave119 FreeW Customize Theme Fonts - 2026-08-03

## Scope

This slice covers FreeW Design > Fonts > Customize Fonts at the existing
dialog-harness target of 560x600 logical pixels. `CustomizeThemeFontsDialogPlanner`
remains the behavior authority for seeded heading/body fonts, common choices,
validation, default naming, and result construction. Geometry is now also
owned by that planner and consumed by both WPF and Avalonia: 380-DIP width,
130-DIP label column, 200-DIP field minimum, 72-DIP action buttons, 4-DIP
row margins, shared separator spacing, and WPF action-row spacing.

## Before / After

Fresh current-source captures were paired at identical 560x600 dimensions for
`initial`, `populated`, and `validation-error`.

| State | Before changed pixels | Before mean delta | After changed pixels | After mean delta | After luminance similarity | pHash | Semantic diff |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| initial | 5.5542% | 3.5946 | 3.0896% | 2.1644 | 0.935799 | 0 | none |
| populated | 5.5542% | 3.5946 | 3.0896% | 2.1644 | 0.935799 | 0 | none |
| validation-error | 5.6170% | 3.6921 | 3.1616% | 2.2732 | 0.933275 | 0 | none |

The baseline painted-content bounds were WPF `517x173` at `y=17` and
Avalonia `518x132` at `y=18`. Final bounds are WPF `517x173` at `y=17` and
Avalonia `518x171` at `y=18`. The remaining one-pixel vertical origin and
two-pixel content-height difference are measurable residuals, not hidden by
the comparator.

## Implementation

- WPF and Avalonia now consume the shared planner geometry constants rather
  than maintaining host-local font-dialog measurements.
- Avalonia uses the shared labeled-row helper with WPF row margins, restores
  the separator before `Name`, and uses the shared dialog separator brush.
- Avalonia action buttons now have explicit default/cancel semantics and the
  shared 72-DIP width.
- WPF keeps its native warning `MessageBox` behavior. Avalonia keeps its
  inline status block and invalid-field focus behavior because those host
  interaction surfaces cannot be safely shared; focused tests cover both
  contracts.

## Provenance

Evidence was produced from the current branch source with the existing
`FreeW.DialogVisualHarness` WPF and Avalonia projects. Each host captured all
three owned states successfully, and the paired comparison classified all
three as `genuine-visual-mismatch` after semantic parity was restored.

Canonical harness evidence was refreshed only through the route-scoped
`--baseline ... --refresh-route customize-theme-fonts` merge. The refreshed
rows live in `docs/parity/freew-dialog-harness/`; the parent-owned
`avalonia-wpf-cross-app-dashboard.*` files were not edited.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~DesignDialogParityTests --no-restore`: **9 passed**.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --filter FullyQualifiedName~DesignDialogParitySourceTests --no-restore`: **2 passed**.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj -c Release --filter FullyQualifiedName~DesignDialogPlannerTests --no-restore`: **11 passed**.
- Focused WPF capture: **3/3 captured**, content gates passed.
- Focused Avalonia capture: **3/3 captured**, content gates passed.
- Harness inventory and route-scoped comparison `--check`: **current**.
- Final PNG inspection at 560x600: no clipping or overlap observed in initial,
  populated, or validation-error captures.

## Residuals

The route remains an honest `genuine-visual-mismatch`: native WPF and
Avalonia control templates/text rasterization still differ, with the small
content-origin and height residuals recorded above. The harness's generic
validation fixture populates the first text field; it does not invoke the
native WPF warning MessageBox or Avalonia submit path. Those behavior paths
are covered by the focused tests, while OS-native dialog presentation remains
outside this renderer-only evidence lane.
