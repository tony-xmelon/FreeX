# FreeW Legal Notices Visual Parity Wave 98

Date: 2026-08-01  
Baseline: `8ef9f0c8ce` (`origin/main`)  
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures  
Scope: FreeW Avalonia Legal Notices initial state and all five notice tabs

## Change

The shared Avalonia classic-tab template forwards the styled tab item's foreground, font
family, and font size through the themed `AccessText` header. This restores the WPF black
tab-label treatment while retaining the shared tab order, automation IDs, focus target,
read-only behavior, scrollbar lane, and default/cancel close semantics.

The deterministic initial-state delta was not rasterization. WPF leaves its document line
box native and its shared TextBox style visually centers a short document. Avalonia had
forced a 16 px line box while pinning the document to the top, placing the first Project
License baseline about 102 px above WPF.

Avalonia now stays top-aligned to avoid the headless layout cycle caused by direct
`VerticalContentAlignment.Center`. After the first realized layout, a shared pure planner
computes a fixed short-document inset from viewport and native document extents. The
handler unsubscribes before applying the padding once, so the inset cannot feed back into
its own plan. Overflow documents receive no inset; a fixed line-count plan retains the
existing 16 px overflow line box only where it is needed to expose the WPF-authority Auto
scrollbar lane. The focused headless route has a 15-second xUnit timeout regression.

## Fresh Six-State Evidence

Both harnesses captured all six paired states. The comparator returned exit code 2 because
all six remain honest `genuine-visual-mismatch` rows; all captures passed their content and
semantic gates. Evidence is retained under `%TEMP%\freex-wave98-legal`:

- `lineheight-wpf/wpf_dialog_capture_manifest.json`
- `final-avalonia/avalonia_dialog_capture_manifest.json`
- `final-compare/freew_dialog_visual_comparison.json`
- `final-compare/heatmaps/`

| State | Before changed | After changed | Delta | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `initial` | 10.5444% | 9.2290% | -1.3153 pp | 12.045 | 9.628 |
| `tab-project-license` | 10.5444% | 9.2290% | -1.3153 pp | 12.045 | 9.628 |
| `tab-legal-notices` | 19.3906% | 19.3911% | +0.0005 pp | 21.271 | 21.311 |
| `tab-privacy-notice` | 16.5629% | 16.5626% | -0.0003 pp | 18.049 | 18.089 |
| `tab-third-party-notices` | 19.6634% | 19.6645% | +0.0011 pp | 22.423 | 22.462 |
| `tab-third-party-license-texts` | 18.6164% | 18.6137% | -0.0027 pp | 20.549 | 20.582 |
| **Average** | **15.8870%** | **15.4483%** | **-0.4387 pp** | **17.730** | **16.950** |

The Project License first and last baselines now align with WPF in the paired capture, and
long states retain their scrollbars and prior ratios. Remaining changed pixels include
cross-framework glyph rasterization and visible one-pixel tab, panel-border, and scrollbar
template differences; no comparator behavior or threshold changed.

## Verification

- Avalonia Legal Notices and common dialog chrome: 24/24 passed in 1 second. The formerly
  spinning focused route completed in 1 second under its 15-second test timeout and the
  runner's 20-second hang guard.
- WPF FreeW help/legal authority tests: 9/9 passed in 4 seconds.
- WPF capture: 6/6; Avalonia capture: 6/6; comparator: six genuine visual mismatches.

All test and capture commands used Release, `--no-restore`, `--disable-build-servers`,
`-p:UseSharedCompilation=false`, `-p:NodeReuse=false`, `/nr:false`, and `-m:1`. Focused
tests used isolated output directories under `%TEMP%\freex-wave98-legal`.
