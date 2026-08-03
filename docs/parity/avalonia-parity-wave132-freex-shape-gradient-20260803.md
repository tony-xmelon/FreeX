# Avalonia Parity Wave132: FreeX Shape Gradient

Date: 2026-08-03

## Scope

This slice covers `dialog.ShapeGradient` at the shared `500x300` logical
capture size. WPF remains the visual authority. Both capture paths now use
`ShapeGradientParityFixture`, which derives its `91,155,213 -> 255,255,255`
seed from `ShapeGradientPlanner` instead of maintaining different hardcoded
fixture colors.

## Before / After

The committed pair was not a valid visual baseline: WPF used the planner
default constructor while Avalonia seeded `31,119,180 -> 180,210,240`. After
matching the fixture, a fresh WPF frame was cropped only at the established
bottom whitespace boundary from `500x333` to the planner's `500x300` evidence
area. Avalonia was then recaptured from the rebuilt current source.

| Metric | Fresh matched baseline | After | Change |
| --- | ---: | ---: | ---: |
| Triage score | 0.062809 | 0.055491 | -0.007318 |
| Sample mean delta | 0.044160 | 0.040534 | -0.003626 |
| Luma delta | 0.006321 | 0.005615 | -0.000706 |
| Non-background delta | 0.011520 | 0.008533 | -0.002987 |
| Raw paired image diff | 5.90% | 3.48% | -2.42 pp |

The previous canonical triage row was `0.082369` with sample `0.055031` and
non-background `0.004160`; it is retained as historical context only because
its fixture state was not matched.

## Implementation

- Added `ShapeGradientParityFixture` in `FreeX.App.Services`; WPF and Avalonia
  parity routes consume the same planner-derived seed values and direction.
- Corrected Avalonia's dialog composition to match measured WPF geometry: the
  group-box content inset, group offset, top content margin, action-row rhythm
  and client-frame right inset, compact action-button height, and gray color
  swatch borders.
- Preserved the existing selected-shape capture, color-picker commands,
  direction selection, validation, focus, automation ids, and cancel/escape
  behavior.

## Residuals

The remaining `0.055491` triage score is a genuine visual mismatch from
native WPF versus Avalonia text/control rasterization and their different
color counts (`406` WPF colors versus `2,086` Avalonia colors). WPF's fresh
capture is `500.202x300.121` logical pixels at approximately 96 DPI versus
Avalonia's `500x300`; the logical difference is within the repository's
0.5-DIP tolerance. No evidence threshold or comparison classification was
changed, and no cross-app dashboard was regenerated.

## Verification

- Focused shared planner/fixture tests: `10 passed`.
- Focused Avalonia Shape Gradient source/lifecycle tests: `3 passed`.
- Focused WPF Shape Gradient appearance tests: `1 passed`.
- WPF and Avalonia Release builds: passed with zero warnings and errors.
- Fresh WPF capture: `115/116` surfaces captured; target nonblank.
- Fresh Avalonia Docker/Xvfb capture: target captured, `app_exit=0`,
  `capture_validated=true`, `500x300` nonblank PNG.
