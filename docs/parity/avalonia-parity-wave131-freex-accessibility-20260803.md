# Avalonia Parity Wave131: FreeX Accessibility Checker

This wave makes one bounded visual parity improvement to FreeX `dialog.AccessibilityChecker`. The shared `AccessibilityCheckerDialogPlanner`, `AccessibilityCheckerDialogMetrics`, fixture, actions, automation metadata, and navigation ownership were already shared or correctly separated between WPF and Avalonia. The remaining high-signal product-owned mismatch in the fresh pair was Avalonia's selected TreeView row: the Fluent template's internal `PART_LayoutRoot` still rendered a saturated blue selection despite the existing item-level pale selection style.

## Change

Avalonia now applies the WPF-authoritative pale `#E6F0FA` selection fill and transparent border to the selected TreeView item's `PART_LayoutRoot`. The change is local to Accessibility Checker and does not replace the native TreeView template, expand/collapse behavior, selection behavior, keyboard focus, Go To routing, or shared dialog chrome.

## Fresh evidence

- Base: worker branch `codex/avalonia-parity-wave131-freex-accessibility-20260803` at `45af68c1e6beffe805b5917884f5c901a74da847`, current `origin/main`.
- WPF: `FreeX.App.Host --parity-capture --parity-capture-target dialog.AccessibilityChecker`, current-source targeted direct parity renderer, `360x520` at `96 DPI`, exit `0`.
- Avalonia: `tools/Run-LinuxParityCapture.ps1` from a fresh worker publish in Ubuntu 24.04 Docker/Xvfb, `--parity-capture-surface dialog.AccessibilityChecker`, `360x520` at `96 DPI`, `app_exit=0`, `capture_validated=true`.
- Both promoted PNGs are nonblank, equal in logical and raw dimensions, and pass the expected-size/content gates. Only this dialog's PNGs and manifest rows were promoted. The cross-app dashboard was not regenerated.

## Metrics

| Metric | Before | After | Change |
| --- | ---: | ---: | ---: |
| Triage score | 0.084354 | 0.066619 | -21.02% |
| Sample delta | 0.054555 | 0.044489 | -18.45% |
| Luma delta | 0.008707 | 0.001039 | -88.07% |
| Non-background delta | 0.020812 | 0.020812 | unchanged |

The before values are a fresh matched WPF/Linux pair captured before editing, not stale canonical evidence. The after values are a fresh matched pair after the Avalonia edit. The canonical dialog visual summary was regenerated and its `dialog.AccessibilityChecker` row now reports the after values.

## Residuals

The score is improved, not zero. Remaining differences are primarily native/text rendering: Avalonia's Fluent TreeView disclosure chevrons versus the WPF direct parity renderer's literal `v` glyphs, font and anti-aliasing metrics, and native button surface/text rasterization. The non-background coverage delta is unchanged. This wave does not claim live WPF window capture parity because the WPF authority path is the repository's current planner-backed direct parity renderer used by the canonical evidence contract.

## Focused verification

- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AccessibilityCheckerSourceTests --logger "trx;LogFileName=wave131-accessibility-source.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: passed `4/4`.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Generate-DialogVisualEvidenceSummary.ps1 -Check`: passed after canonical promotion.
