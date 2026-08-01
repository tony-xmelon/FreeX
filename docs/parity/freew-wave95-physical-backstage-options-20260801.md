# FreeW Wave 95 Physical Backstage and Options X11 Expansion

Date: 2026-08-01
Branch: `codex/wave95-freew-physical-expansion-20260801`

## Scope

The reusable family X11 probe now extends the FreeW baseline from thirty-seven
to exactly forty-five result rows. This is a bounded physical-input slice, not
an exhaustive command or visual-parity suite. FreeP remains unchanged at its
exact twenty-four-row contract.

The eight new FreeW rows are:

- `backstage-print-open`
- `backstage-print-dismissal`
- `backstage-export-open`
- `backstage-export-dismissal`
- `options-open`
- `options-tab-navigation`
- `options-focus`
- `options-close`

The probe opens File with the real Alt/F route, clicks the rendered Print or
Export rail entry relative to the live Backstage window geometry, and uses
Escape to prove the owner window and count are restored. The Options route
clicks the real bottom rail entry, invokes the rendered Edit options action with
physical pointer input, verifies that Backstage was replaced by a focused Options window,
sends physical Ctrl+Tab and Tab input, then closes with Escape. Every result
retains state text and screenshots, and every result is gated on the relevant
window, focus, transition, and restoration checks.

## Contracts

`tools/LinuxInteractiveDocker/family-x11-validation.schema.json` and
`tools/Run-FamilyLinuxInteractionValidation.ps1` require exactly forty-five
FreeW rows and the eight IDs above. The probe's runtime failure trap emits all
missing required IDs as failed rows using shared failure evidence, so an early
input or window failure cannot receive implicit credit. The existing physical
evidence level remains `physical-x11-input`, and `coverage.exhaustive` remains
`false`.

No product files, generated dashboards, or global inventories were changed.
The orchestrator owns Docker validation; this slice was verified with focused
foreground source-contract tests only.

## Residuals

The new scenarios are intentionally bounded to pane navigation, tab movement,
focus retention, and close restoration. They do not claim Print or Export
action execution, native printer/file-picker completion, every Options control,
or screenshot-level parity with WPF. The fixed physical click into the
Backstage Options pane is validated by the resulting top-level Options window;
if that window is absent, all four Options rows remain failed rather than being
promoted from partial evidence.
