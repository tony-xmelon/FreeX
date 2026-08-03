# Avalonia parity Wave 133 integration

Date: 2026-08-03

## Scope

Wave 133 advances one bounded parity slice in each application and refreshes the checked-in parity
evidence from the integrated implementations.

### FreeX: Sparkline dialog

- Avalonia now uses the measured WPF content lane, row metrics, label alignment, action spacing,
  button height, and combo-box height while retaining the shared compact dialog chrome.
- A fresh matched `380x280` Linux Docker capture improved triage score from `0.074104` to
  `0.055394`, sample delta from `0.049141` to `0.030052`, luma delta to `0.010391`, and
  non-background delta to `0.014671`.
- Canonical dialog evidence remains complete at 94/94 paired, nonblank surfaces with no logical
  dimension mismatches. The 21 raw dimension mismatches are normalized DPI differences.

### FreeW: AutoCorrect tab

- WPF and Avalonia now present readable, unclipped 1:2 Replace/With columns with matching row and
  table geometry.
- WPF's size-to-content measurement bug, which collapsed both star columns to 20 pixels, was fixed
  with finite-width hosting and a one-shot post-measure update that detaches after valid geometry.
- The canonical changed-pixel ratio improved from `11.8872%` to `10.4863%`; mean delta improved
  from `10.062350` to `8.714455`, with no semantic difference reported.
- Current route inventory, comparison artifacts, and freshness hashes were regenerated and the
  target route was merged into the canonical comparison set.

### FreeP: relationship1 SmartArt live import

- The checked-in SmartArt corpus now includes a real `/relationship1` slide with three ordered
  Audience, Need, and Offer ellipse nodes.
- The shared reader admits only the proven 58%-overlap grammar and emits one renderer-neutral live
  plan consumed by WPF and Avalonia. Malformed, ambiguous, unsupported, or wrong-ratio packages
  retain cached-drawing fallback.
- FreeP command/workflow evidence increases from 104 to 105 rows.

## Integration corrections

- The generated-profile guard now registers `freep.smartart.relationship1-import-ellipses`.
- FreeP relationship1 cache admission requires the horizontal step to match the shared planner's
  58% rule within one EMU, preserving fallback for superficially similar unsupported layouts.
- FreeW's WPF layout handler now unsubscribes after either the loaded pass or a valid later layout
  pass, avoiding a permanently attached no-op handler.
- The first all-up run exposed one stale generated-profile expectation and one clipboard isolation
  failure. The expectation was corrected; the clipboard case passed alone and the clean serialized
  full suite then passed without recurrence.

## Verification

- Repository preflight passed across 10,836 text files, including generated documentation, macOS
  readiness, Linux packaging readiness, 220 JSON files, 260 XML files, 90 PowerShell files, 124
  projects, 91 solution entries, and 22 default-test entries.
- Full serialized `FreeX.slnx` Release build passed with zero warnings and zero errors.
- Generated dialog evidence, FreeW inventory, FreeP command inventory, and cross-app dashboard
  generation/checks passed.
- Focused integrated tests passed for FreeX Sparkline chrome, FreeW WPF/Avalonia AutoCorrect
  parity, FreeP host and presentation relationship contracts, Avalonia renderer contracts, real
  fixture evidence, and generated-profile retention.
- Full `FreeX.DefaultTests.slnx` clean serialized run: 36,353 discovered across 21 projects, 36,219
  executed and passed, 134 not executed, and zero failed.

## Remaining work

- FreeX retains native text and low-level rasterization residuals despite complete paired dialog
  coverage.
- FreeW still has 158 catalogued genuine visual mismatches among 183 paired comparison rows and
  lacks authoritative Microsoft Word PNG baselines on this host.
- FreeP still needs broader SmartArt grammar coverage and PowerPoint-authoritative visual
  baselines beyond the admitted continuous-process, grouped-list, and relationship1 families.

Wave 133 advances the active parity goal but does not claim complete Avalonia/WPF parity.
