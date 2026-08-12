# FreeW Table of Authorities Shared Geometry, Wave 168

Date: 2026-08-12
Authority: app-owned FreeW WPF dialog harness at 96-DPI logical coordinates

## Gap

The WPF and Avalonia Table of Authorities adapters shared their state and option planner, but
duplicated the dialog width, outer inset, field height, label and control gaps, checkbox margins,
action-row margin, and button width. Avalonia additionally embedded three unexplained local
template offsets. The tracked canonical rows were stale at 11.3580% changed pixels and 4.5137
mean channel delta, with WPF `16,20,513x185` painted bounds versus Avalonia
`16,20,514x184`.

A fresh current-source capture before this slice measured 3.7982% / 2.5506 for initial and
validation, and 3.8815% / 2.6335 for populated. That established the real baseline after earlier
chrome work while confirming the remaining one-pixel height and action-row placement gap.

## Change

`TableOfAuthoritiesDialogPlanner.VisualMetrics` now owns the WPF-authority dialog geometry. Both
renderer adapters consume the shared width, inset, label/control spacing, 24-DIP authority field
height, action margin, and button width. The same contract records the measured Avalonia template
compensations: its combo template paints the compact authority field two pixels shorter, its
content requires one extra right inset, and its action row requires one extra top pixel.

Avalonia also consumes the measured 14-DIP effective WPF action gap. WPF obtains that gap from its
shared dialog resources (the OK right margin plus the Cancel left margin); keeping the effective
value in the planner prevents the Avalonia renderer from reverting to its generic 8-DIP gap.

## Evidence

All six final route captures passed the full and target pixel-content gates. Semantics match and
perceptual hash distance is zero in every state.

| State | Tracked before ratio / mean | Fresh source before | Final ratio / mean | Final bounds (WPF / Avalonia) |
| --- | ---: | ---: | ---: | --- |
| initial | 11.3580% / 4.5137 | 3.7982% / 2.5506 | **3.6512% / 2.4129** | `16,20,513x185` / `16,20,513x185` |
| populated | 11.3580% / 4.5137 | 3.8815% / 2.6335 | **3.7345% / 2.4958** | `16,20,513x185` / `16,20,513x185` |
| validation-error | 11.3580% / 4.5137 | 3.7982% / 2.5506 | **3.6512% / 2.4129** | `16,20,513x185` / `16,20,513x185` |

The remaining delta is native framework typography and control rasterization. All three rows
remain `genuine-visual-mismatch`; the evidence does not promote them to passes.

## Verification

- Shared planner tests: 8/8 focused tests passed.
- Avalonia live dialog and state tests: 5/5 focused tests passed.
- WPF dialog and cross-renderer source-boundary tests: 9/9 focused tests passed.
- WPF route captures: 3/3 captured and content-gated.
- Avalonia route captures: 3/3 captured and content-gated.
- Canonical route refresh retained 295 rows: 159 genuine mismatches, 24 passes, 105 Avalonia
  extensions, and 7 state-not-applicable rows.
- FreeW evidence consistency, cross-app dashboard, and generated-document checks passed.
- Repository preflight passed.
- Full `FreeX.slnx` Release build passed with zero warnings and zero errors.
