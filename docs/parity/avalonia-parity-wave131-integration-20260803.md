# Avalonia parity Wave 131 integration

Date: 2026-08-03

## Scope

Wave 131 advances one bounded parity slice in each application.

### FreeX: Accessibility Checker selection chrome

- The Avalonia selected TreeView row now uses the WPF-authoritative pale selection fill on the
  native template's `PART_LayoutRoot`.
- Fresh matched `360x520` captures improved triage score from `0.084354` to `0.066619`, sample
  delta from `0.054555` to `0.044489`, and luma delta from `0.008707` to `0.001039`.
- The canonical FreeX dialog evidence remains 94/94 paired, nonblank, and scale comparable.

### FreeW and FreeX: shared Legal Notices ownership

- FreeX Avalonia now uses the shared `AvaloniaLegalNoticesDialog` host instead of maintaining a
  second local implementation.
- The FreeX adapter retains localized copy and legal documents while the shared component owns
  tabs, automation metadata, keyboard lifecycle, focus, and classic dialog chrome.
- All six fresh FreeW Legal Notices states remain semantically aligned. Their visual mismatch
  classifications remain honest; changed-pixel ratios range from `9.197%` to `18.191%` and are
  dominated by native text, tab, and scrollbar rasterization.

### FreeP: hierarchy3 SmartArt live import

- The real `hierarchy3` fixture now replaces its ten-shape cached drawing with the shared
  six-shape live layout plan.
- Admission is restricted to the validated grammar. Unsupported effects, extra roles, groups,
  pictures, or cache mismatches continue through the existing safe fallback.
- WPF and Avalonia consume the same imported live plan and retain renderer contract coverage.

## Integration corrections

- macOS readiness now follows the shared Legal Notices ownership boundary instead of requiring
  obsolete implementation markers in `MainWindow.cs`.
- Source guards count the shared Legal Notices tab and validate the FreeX adapter plus shared
  automation/chrome implementation.

## Verification

- Repository preflight: passed across 10,815 text files, including generated documentation,
  macOS readiness, and Linux packaging readiness.
- Full serialized `FreeX.slnx` Release build: passed with zero warnings and zero errors.
- Full `FreeX.DefaultTests.slnx` clean rerun: 36,330 discovered, 36,196 executed and passed,
  134 not executed, zero failed.
- The first all-up test run exposed two stale Legal Notices source guards and one transient
  clipboard-isolation failure. Both guards were corrected, the clipboard test passed in isolation,
  and the complete clean rerun passed.
- Worker-focused verification also passed: FreeX Accessibility `4/4` plus WPF `11/11`; FreeW
  Legal Notices `12/12` plus FreeX lifecycle `2/2`; FreeP Presentation `390/390`, WPF host
  `266/266`, and Avalonia renderer contracts `2/2`.

## Remaining work

- FreeX retains low-level native/text rasterization residuals despite complete paired coverage.
- FreeW still has 158 catalogued genuine visual mismatches among 183 paired comparison rows and
  lacks authoritative Microsoft Word PNG baselines on this host.
- FreeP still needs broader SmartArt families and PowerPoint-authoritative visual baselines; this
  wave closes only the proven `hierarchy3` fallback path.

Wave 131 advances the active parity goal but does not claim complete Avalonia/WPF parity.
