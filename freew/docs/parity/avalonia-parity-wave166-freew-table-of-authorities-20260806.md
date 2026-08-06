# Avalonia Parity Wave 166: FreeW Table of Authorities

Date: 2026-08-06

## Scope

This slice covers the canonical `table-of-authorities` dialog in the shared
`initial`, `populated`, and `validation-error` evidence states at 560x600 and
96 DPI. WPF/shared planners remain the authority. No thresholds, fixtures,
masks, crops, or classifications were changed.

## Fresh baseline

All six current-source captures were fresh and content-gated before the edit:
WPF `3/3`, Avalonia `3/3`. The state contract matched in every pair: default
buttons `OK`/`Cancel`, initial and validation-error as `(All)`, both checkboxes
unchecked, and populated as `Statutes`, both checkboxes checked, and `Dashes`.

| State | Changed pixels | Mean channel delta | WPF content bounds | Avalonia content bounds |
| --- | ---: | ---: | --- | --- |
| initial | 4.6952% | 2.9547 | 513x185 at 16,20 | 513x184 at 16,20 |
| populated | 4.7810% | 3.0410 | 513x185 at 16,20 | 513x184 at 16,20 |
| validation-error | 4.6952% | 2.9547 | 513x185 at 16,20 | 513x184 at 16,20 |

The prior committed `11.3580%` / `4.5137` values were not used as fresh
evidence.

## Correction

Avalonia's default OK button was receiving the blue default-button border from
the shared chrome even while resting. WPF renders both resting action buttons
with the neutral gray border in this capture contract. The TOA dialog now uses
the shared neutral border brush for its local default-button chrome. Default,
cancel, keyboard, and option behavior remain unchanged.

## After evidence

Fresh post-edit captures were again WPF `3/3` and Avalonia `3/3`, all
content-gated. Every state improved and no state regressed:

| State | Before changed | After changed | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: |
| initial | 4.6952% | 4.6932% | 2.9547 | 2.9029 |
| populated | 4.7810% | 4.7789% | 3.0410 | 2.9891 |
| validation-error | 4.6952% | 4.6932% | 2.9547 | 2.9029 |

The rows remain honestly classified as `genuine-visual-mismatch`; no semantic
difference is reported. The native residual is the one-pixel content-height
delta (`184` Avalonia versus `185` WPF) and platform-native text/control
rasterization. After correction, Avalonia still has fewer raster colors than
WPF (`29` versus `258` in initial/validation-error and `41` versus `285` in
populated), so pixel identity is not claimed.

## Verification and attempts

- Controlled WPF harness build: 0 warnings, 0 errors.
- Controlled Avalonia harness build: 0 warnings, 0 errors.
- Avalonia TOA visual parity tests: `5/5` passed.
- WPF TOA behavior tests: `7/7` passed.
- Shared TOA planner tests: `7/7` passed.
- Fresh current-source capture: six of six states captured and content-gated
  before the edit; six of six after the edit.
- The first WPF run attempt timed out without output; its owned PID was
  terminated by PID only. The subsequent controlled build and captures passed.
- Initial no-restore Avalonia/test attempts reported missing project assets;
  foreground restores resolved those setup blockers.
