# FreeW Legal Notices Parity Wave34

Date: 2026-07-27
Branch: `codex/freew-legal-notices-wave34-20260727`
Authority: WPF `SharedLegalNoticesDialog`; Avalonia uses the same neutral shared metrics and structure.

## Behavior

The packaged notice order is identical in both hosts: Project License, Legal Notices, Privacy Notice, Third-Party Notices, and Third-Party License Texts. WPF authority tests inspect the actual dialog controls and route deterministic key events to the focused read-only `AcceptsTab` text box:

- Plain `Tab` is handled by WPF and focus remains in the text box; plain `Enter` is not handled and does not close the dialog.
- No `Ctrl+Tab` or `Ctrl+Shift+Tab` cycling is implemented because WPF does not establish that behavior for this surface; Avalonia leaves those gestures native and does not intercept them.
- Escape remains native modal cancel behavior. The Close button is `IsDefault` and `IsCancel` in WPF and Avalonia; no host tunnel suppresses that authority.
- Copy/select-all, read-only state, scrolling, focus targets, automation IDs, resizing, and minimum-size assertions remain covered by the focused host tests.

The `+6` text inset and `+3` intro spacing are documented and implemented as Avalonia template compensation only. They are not shared WPF padding or shared dialog geometry.

## Matched Visual Evidence

Harness: 96 DPI, all five relevant tab states, fresh WPF and Avalonia captures after the final source change. `changedRatio` is the harness ratio of pixels exceeding its RGB-delta threshold; it is not a pass percentage.

| Tab | Before changed / mean / p95 | After changed / mean / p95 | Classification |
| --- | --- | --- | --- |
| Project License | 10.112% / 11.033 / 96.000 | 10.112% / 11.033 / 96.000 | genuine-visual-mismatch |
| Legal Notices | 20.078% / 22.369 / 173.000 | 20.078% / 22.369 / 173.000 | genuine-visual-mismatch |
| Privacy Notice | 17.534% / 18.790 / 146.667 | 17.534% / 18.790 / 146.667 | genuine-visual-mismatch |
| Third-Party Notices | 21.509% / 23.534 / 183.667 | 21.509% / 23.534 / 183.667 | genuine-visual-mismatch |
| Third-Party License Texts | 20.576% / 21.824 / 173.000 | 20.573% / 21.817 / 173.000 | genuine-visual-mismatch |

Evidence is under `artifacts/wave34-legal-notices-before/` and `artifacts/wave34-legal-notices-after/`; the paired comparison is `comparison-five-tabs/freew_dialog_visual_comparison.json` and `.html`. The comparison exits with classification status 2 because all five rows are genuine mismatches, not because captures failed. A temporary `Z:` drive was used only to work around the longest OneDrive path and was removed afterward.

## Residuals

This is not a 100% visual match. The remaining pixel differences are host rendering, font, control-template, and action-row differences; four rows also retain the harness `action-button-order` semantic residual. WPF authority behavior is tested directly for plain Tab and Enter plus deterministic default/cancel properties; Avalonia verifies that the shared surface does not add modifier-tab navigation or alter native cancel handling.
