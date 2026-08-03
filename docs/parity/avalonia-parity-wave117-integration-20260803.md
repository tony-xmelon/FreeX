# Avalonia parity Wave117 integration - 2026-08-03

## Scope

Wave117 advanced one evidence-backed parity slice in each desktop app:

- FreeX: current Windows/Linux Find/Replace layout and visual evidence.
- FreeW: Backstage Export content realization and capture geometry.
- FreeP: bounded imported `cycle2` SmartArt live-layout admission.

## Delivered

### FreeX Find/Replace

The shared planner now records the WPF-authoritative natural tab-host heights:
74 DIPs for Find and 108 DIPs for Replace. Avalonia applies the matching height
at construction and whenever the selected tab changes. Fresh WPF and Ubuntu
24.04 Docker/Xvfb captures are all nonblank and dimension-matched at 720x430.
The focused changed-pixel ratios are 1.569230% for Find and 2.277002% for
Replace. The generated 94-surface report has no missing, blank, or scale-aware
dimension mismatch rows; Zoom is now the highest remaining triage candidate at
0.092952.

### FreeW Backstage Export

Avalonia Export action labels now use explicit text content matching WPF button
realization, and the capture harness uses the measured 14-DIP non-client width.
Fresh 560x600 captures report identical 546x563 painted bounds and identical
19-action semantics. Mean channel delta improved from 11.506 to 10.853, with
luminance similarity 0.866073 and pHash distance 12. The surface remains
honestly classified as a genuine visual mismatch because native text and
scrollbar templates still differ.

### FreeP cycle2 SmartArt

Imported `cycle2` diagrams enter the shared live layout only when the complete
PowerPoint cache matches repository evidence: one non-empty ellipse and one
empty right arrow per node, with two through seven nodes and no extra roles.
Richer or malformed caches remain authoritative fallbacks. The real five-node
corpus, negative fallback behavior, and save/reopen identity are covered without
claiming pixel-identical PowerPoint geometry.

## Verification

- Generated documentation and evidence checks passed.
- Parent FreeX focused lanes: 33 service, 8 Avalonia, and 22 WPF tests passed.
- Parent FreeW focused lanes: 39 Avalonia Backstage and 74 shared Backstage tests passed.
- Parent FreeP focused lanes: 8 host/source and 2 presentation cycle2 tests passed.
- Worker FreeP lanes: 204 presentation, 247 WPF/package, and 344 Avalonia tests passed; Release solution build completed with zero warnings or errors.
- Worker FreeX and FreeW Release builds and capture harness builds completed with zero warnings or errors.

## Remaining

- FreeX: Zoom and Page Setup are the next measured dialog candidates; native
  text and control rasterization remain across otherwise aligned pairs.
- FreeW: Backstage Export remains a genuine toolkit-rendering mismatch;
  Customize Theme Colors and adjacent Backstage surfaces remain candidates.
- FreeP: broader evidence-backed SmartArt/effect specialization, chart/media
  depth, and PowerPoint-authoritative visual baselines remain open.
