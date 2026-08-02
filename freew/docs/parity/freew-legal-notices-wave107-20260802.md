# FreeW Legal Notices Visual Parity Wave 107

Date: 2026-08-02
Scope: FreeW Avalonia Legal Notices, including the initial state and the four long-document tab states
Authority: `SharedLegalNoticesDialog` WPF implementation and the existing paired harness captures

## Change

The Avalonia read-only notice host now uses one measured 14.6 px document line box for both
short and overflowing notices. Previously, the overflow planner assigned a 16 px line box,
which made the long tabs show fewer rows than WPF and produced a visibly shorter scrollbar
thumb. The 16 px value remains the conservative overflow-planning input used to reserve the
WPF scrollbar lane; only the realized Avalonia line box is corrected.

Tab order, selection, focus, copy/read-only behavior, scroll retention, automation IDs, dialog
geometry, and the 18 px visible scrollbar lane are unchanged.

## Fresh visual evidence

The integrated Wave107 branch recaptured all six Legal Notices states at 96 DPI and refreshed
the route rows in `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`.

| State | Before | After | Improvement |
| --- | ---: | ---: | ---: |
| `legal-notices.initial` | 10.317% | 9.102% | 1.215 pp |
| `legal-notices.tab-project-license` | 10.317% | 9.102% | 1.215 pp |
| `legal-notices.tab-legal-notices` | 21.061% | 19.857% | 1.204 pp |
| `legal-notices.tab-privacy-notice` | 18.393% | 17.567% | 0.826 pp |
| `legal-notices.tab-third-party-notices` | 21.665% | 19.574% | 2.092 pp |
| `legal-notices.tab-third-party-license-texts` | 21.736% | 19.898% | 1.838 pp |

Every paired state improved. The refreshed heatmaps confirm that the corrected line box closes
the cumulative body-height mismatch and gives the long-document scrollbar a closer WPF geometry.

Remaining expected visual limitation after recapture: cross-framework glyph rasterization and
native tab, border, and scrollbar template pixels may remain different even when line count and
content alignment match.

## Verification

- FreeW Avalonia `LegalNoticesDialogVisualParityTests`: **11/11 passed**.
- FreeW WPF `FreeWHelpInfoTests`: **9/9 passed**.
- Fresh WPF captures: **6/6 captured**.
- Fresh Avalonia captures: **6/6 captured**, all passing the pixel-content gate.
- No Docker was run.
- No build-server shutdown was run.
