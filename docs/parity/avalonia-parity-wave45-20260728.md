# Avalonia Parity Wave 45 Closure

Date: 2026-07-28

This report closes the Wave 45 implementation slice for FreeX, FreeW, and FreeP. It records the functional evidence available on the integration branch and separates that evidence from the visual and manual work that remains. It is not a claim that Avalonia has reached 100% WPF parity.

## Implemented Slices

### FreeX

- Added worksheet-edge auto-scroll while selecting ranges, dragging the autofill handle, moving or copying a selection, and pointing ranges from the formula editor. See commit [`9372be1aac`](../../commit/9372be1aac).
- Made Quick Analysis validation accept and dismiss the real conditional-format dialog route rather than waiting for an owned dialog that is not present. See commit [`fbe4125274`](../../commit/fbe4125274).
- Changed context-menu validation to observe the actual inline comment/note editors and crop mode. This removed the false expectation that those routes create owned dialogs. See commit [`44f5349546`](../../commit/44f5349546).

### FreeW

- Added WPF-equivalent Avalonia character shading and character border palettes, including explicit `No Color` and `No Border` actions, shared model operations, undo/redo behavior, and DOCX round-trip paths. See [`freew-character-shading-avalonia-wave45-20260728.md`](freew-character-shading-avalonia-wave45-20260728.md) and [`freew-character-border-avalonia-wave46-20260728.md`](freew-character-border-avalonia-wave46-20260728.md).
- Added the WPF-equivalent text highlight palette and clear action through the shared editor operation. See [`freew-highlight-avalonia-wave47-20260728.md`](freew-highlight-avalonia-wave47-20260728.md).
- Reconciled the shared planner, Avalonia picker, WPF palette, direct palette registrations, and source guards so both hosts use the same character-formatting semantics. See commits [`1b2dcb9190`](../../commit/1b2dcb9190), [`54f793ceed`](../../commit/54f793ceed), and [`8016f55ab7`](../../commit/8016f55ab7).

### FreeP

- Exposed chart trendline forward and backward forecast controls through the shared planner and both hosts. See commit [`da9e7f4ea8`](../../commit/da9e7f4ea8).
- Made chart options dialogs scrollable in both hosts. See commit [`2f8145295b`](../../commit/2f8145295b).
- Preserved the pie/doughnut frame for leader-line-only data-label metadata, then completed shared leader-line rendering and maximum-axis data-label behavior. See commits [`3675f4917c`](../../commit/3675f4917c), [`3f4aa85772`](../../commit/3f4aa85772), and [`e7c2379f97`](../../commit/e7c2379f97).
- Added the Phased Process SmartArt authoring and package route and merged the PowerPoint corpus validation work. The SmartArt slice explicitly does not claim native PowerPoint raster equivalence. See [`freep-smartart-phased-process-20260728.md`](freep-smartart-phased-process-20260728.md) and [`freep-powerpoint-com-validation-20260728.md`](freep-powerpoint-com-validation-20260728.md).

## Focused Evidence

The focused Wave 45 runs recorded the following exact results:

- FreeX focused interaction filters covering context menus, Quick Analysis, drag behavior, and grid input: **34/34 passed**.
- FreeW focused Avalonia formatting, palette, and registry lane: **63/63 passed**; the corresponding WPF character-formatting filter: **19/19 passed**.
- FreeP chart corpus coverage: **31/31 passed**; presentation chart coverage: **398/398 passed**; WPF chart coverage: **210/210 passed**; Avalonia chart coverage: **38/38 passed**.

The component reports in this branch provide additional focused checkpoints: FreeW shading **5 passed**, border **7 passed**, and highlight **8 passed**, with zero failures or skips in each report. FreeP's leader-line report records **233 selected presentation tests passed** and successful WPF/Avalonia rendering builds.

## Linux Evidence

The final FreeX Linux artifact is [`interaction-validation.json`](../../artifacts/linux-interactive/freex/interaction-validation/20260728T104959Z/interaction-validation.json). It was produced from source commit `4fe4ad30ec8d8c626123cdff3b95ee1b7af32b79` and reports:

- **16,419 passed**
- **236 skipped**
- **0 failed**
- **16,655 total**

The artifact covers 124 dialogs, 573 ribbon-command rows, 880 context-menu dispatch rows, keyboard shortcuts, range selection, worksheet editing, Quick Analysis, pointer input, and physical X11 routes. Its category summary includes 124/124 dialog, contract, and inventory rows; 616 ribbon-command rows; 265 shortcut scenarios; 31/31 range-selection rows; 4/4 worksheet-editing rows; 2/2 Quick Analysis rows; and 24/24 X11-input rows. The artifact's source commit and payload fingerprint are retained in [`resume-provenance.json`](../../artifacts/linux-interactive/freex/interaction-validation/20260728T104959Z/resume-provenance.json).

The final physical X11 family artifacts report:

- FreeW: **37/37 passed**, **0 failed**, contract validation passed. Evidence: [`family-x11-results.json`](../../artifacts/linux-family-interactive-wave45-final/freew/sessions/20260728T120541632Z/family-validation/family-x11-results.json).
- FreeP: **22/22 passed**, **0 failed**, contract validation passed. Evidence: [`family-x11-results.json`](../../artifacts/linux-family-interactive-wave45-final/freep/sessions/20260728T120817154Z/family-validation/family-x11-results.json).

These are functional physical-X11 smoke and interaction results. They are not pixel-diff acceptance results.

## Full Build And Default Lane

The recorded Wave 45 full solution build used:

```text
dotnet build FreeX.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

At the synchronized integration head, the result was **0 warnings, 0 errors**.

The final default lane aggregate is **33,076 total**, with **32,943 executed and passed**, **0 failed**, and **133 not executed**. The executed lane is green; the 133 not-executed rows remain explicitly identified coverage limitations rather than failures.

The final parity preflight [`wave45-final-preflight-r5.log`](../../artifacts/wave45-final-preflight-r5.log) passed all repository, project, solution, packaging, and generated-document checks.

Eighteen stale source/portability guards were semantically updated to match the current shared implementation. One real imported `hierarchy3` SmartArt regression was fixed, with focused validation of **201/201 host tests** and **274/274 presentation tests**.

## Current Dashboard Snapshot

The generated dashboard is [`avalonia-wpf-cross-app-dashboard.json`](avalonia-wpf-cross-app-dashboard.json). Its scope boundary explicitly says that generated counts prove routing, manifest coverage, and DPI-normalized size comparability only; they do not prove visual parity, workflow completeness, or pixel equivalence.

| App | Current generated counts |
| --- | --- |
| FreeX | 531 command rows; 473 parity rows; 0 Avalonia-missing rows; 0 real behavior gaps; 57 WPF dialog routes and 57 Avalonia captures; 94 paired visual surface IDs; 0 high-delta triage candidates; highest triage score 0.103523. |
| FreeW | 934 total command profiles; 458 shared; 428 profile-shape-only rows; 43 command ID aliases; 5 platform-only rows; 0 actionable gaps. |
| FreeP | 529 command profiles; 529 shared; 0 actionable gaps; 101 workflow-evidence rows. |

The FreeX dialog evidence has 28 raw PNG dimension mismatches that normalize to matching capture dimensions at the recorded scale. That is a capture-size limitation, not a visual-parity pass.

## Remaining Work

### Functional verification

- The executed default lane is green; the 133 not-executed rows remain a bounded coverage limitation to address as their prerequisites become available.
- Extend physical Linux validation beyond the recorded smoke families to the broader command, dialog, context-menu, keyboard, editing, pointing, and export workflows across all three applications.

### Authoritative visual and manual parity

- FreeX still needs human-reviewed WPF/Avalonia visual baselines at matched size and DPI for the full window, ribbons, backstage surfaces, dialogs, context menus, sheet grid, sheet tabs, formula bar, and footer. The dashboard's zero high-delta triage candidates is only a triage result, not a visual acceptance threshold.
- FreeW still needs real Word-authoritative PNG baselines and broader paired comparisons for WordArt, watermark, tables, page composition, shapes/objects, SmartArt, charts, and other drawing workflows. The current no-Word evidence deliberately makes no authoritative Word raster claim.
- FreeP still needs broader PowerPoint-authoritative visual and workflow evidence for layout/table pickers, rich inline editing, galleries and media, slide-pane operations, notes/PDF/export surfaces, recording and captions, chart families and 3-D rendering, SmartArt families, OMML, ink, comments/review, accessibility/proofing, and animation-pane behavior. Real hardware and COM-capable capture remain required for several of those surfaces.
- Continue calibrating paired visual diff thresholds and retain human review for any surface where normalized dimensions alone cannot establish equivalence.

Wave 45 materially improves functional parity and produces strong Linux evidence, but the overall Avalonia-to-WPF parity goal remains active. Functional coverage, authoritative visual baselines, and manual workflow evidence are not yet complete enough to claim 100% parity.
