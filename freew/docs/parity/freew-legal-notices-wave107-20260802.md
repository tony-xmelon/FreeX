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

## Existing visual evidence

The checked-in comparison report predates this change. Its current paired rows measure:

| State | Changed pixels |
| --- | ---: |
| `legal-notices.tab-legal-notices` | 21.06% |
| `legal-notices.tab-privacy-notice` | 18.39% |
| `legal-notices.tab-third-party-notices` | 21.67% |
| `legal-notices.tab-third-party-license-texts` | 21.74% |

Archived WPF/Avalonia captures and heatmaps show the long Avalonia body ending one or more
rows earlier than WPF, with a shorter scrollbar thumb. The new line-box value addresses that
measured geometry mismatch. A fresh harness capture is still required to quantify the post-
change ratio; this focused implementation slice intentionally did not run the visual harness.

Remaining expected visual limitation after recapture: cross-framework glyph rasterization and
native tab, border, and scrollbar template pixels may remain different even when line count and
content alignment match.

## Verification

- FreeW Avalonia `LegalNoticesDialogVisualParityTests`: **11/11 passed**.
- FreeW WPF `FreeWHelpInfoTests`: **9/9 passed**.
- No Docker was run.
- No build-server shutdown was run.
