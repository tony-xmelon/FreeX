# Avalonia Parity Wave 46 Closure

Date: 2026-07-28

This report records the Wave 46 implementation and validation slice for FreeX, FreeW, and FreeP. The wave closes three concrete Avalonia functional gaps and one repository test-isolation defect. It does not claim that all Avalonia workflows or visuals have reached 100% WPF parity.

## Implemented Slices

### FreeX

- Added the shared `Secondary Axis Series` chart command and routed it through the Avalonia host.
- Reused `ChartQuickCommandCatalog.SecondaryAxisSeries`, the shared chart quick-command planner, and the existing WPF-compatible chart capability guard.
- Regenerated the command inventory. The shared FreeX ribbon now contains 532 canonical commands, including 474 commands projected by both hosts and no commands classified as Avalonia-missing.

Implementation commit: `8e35aa6d47`.

### FreeW

- Added the Avalonia `Edit Shape`, `Convert to Freeform`, and `Edit Points` routes already available in WPF.
- Added visible vertex handles, pointer capture, point dragging, inverse coordinate mapping for rotation and flipping, grouped undo, Escape cancellation, and state cleanup.
- Strengthened the focused tests so unexpected exceptions are reported rather than silently swallowed.

Implementation commit: `ac7dc70790`.

### FreeP

- Connected the Avalonia Backstage Print layout choices to actual print actions.
- Preserved the selected range and layout, closed Backstage, and invoked the existing native print handoff used by the host.

Implementation commit: `01de3a99c5`.

### Test Isolation

The full default lane exposed WPF clipboard state leaking between seven host tests. Those tests used a reusable STA dispatcher, so queued WPF callbacks could affect later clipboard cases. The affected tests now use a fresh, joined clipboard-isolated STA thread for each run, with dedicated regression coverage.

Test commits: `7beb862a31` and `083199cfc5`.

## Focused Evidence

The focused Wave 46 validation recorded:

- FreeX Avalonia chart quick routes: **4/4 passed**.
- FreeX host/shared ribbon and chart-source tests: **23/23 passed**.
- FreeP Avalonia print tests: **17/17 passed**.
- FreeP shared print-planner tests: **6/6 passed**.
- FreeP WPF print-host tests: **11/11 passed**.
- FreeW Avalonia Edit Points tests: **5/5 passed**.
- FreeW WPF Edit Points tests: **4/4 passed**.
- FreeX host logic after clipboard isolation: **1,443 passed**, **4 skipped**, **0 failed**.
- Focused clipboard sequence and isolation regression: **10/10 passed**.

## Linux Docker Evidence

All Wave 46 Linux runs used the shared `freex-linux-interactive:ubuntu24.04` base image and app images built from the integration source.

### FreeX

- Physical X11 interaction lane: **24 passed**, **0 failed**.
- Targeted managed ribbon lane: **16 passed**, **0 failed**.
- The targeted ribbon batch executed eight commands and eight placement checks, including `Secondary Axis Series`, with evidence level `executed-production-lifecycle`.

Evidence:

- `artifacts/linux-interactive/freex/interaction-validation/20260728T162329Z/interaction-validation.json`
- `artifacts/linux-interactive/wave46-targeted-freex/freex/sessions/20260728T163030196Z/validation/interaction-validation.json`

### FreeW

- Physical X11 family lane: **37 passed**, **0 failed**.

Evidence:

- `artifacts/linux-family-interactive/wave46/freew/freew/sessions/20260728T161920107Z/family-validation/family-x11-results.json`

### FreeP

- Physical X11 family lane: **22 passed**, **0 failed**.
- Native physical-output validation across deterministic CUPS success and failure paths: **16 passed**, **0 failed**, **0 not proven**.

Evidence:

- `artifacts/linux-family-interactive/wave46/freep/freep/sessions/20260728T162250607Z/family-validation/family-x11-results.json`
- `artifacts/freep-physical-linux-wave46/report.json`
- `artifacts/freep-physical-linux-wave46/success/freep/sessions/20260728T162204809Z/physical-validation/freep-physical-linux-wave13b.json`
- `artifacts/freep-physical-linux-wave46/failure/freep/sessions/20260728T162236264Z/physical-validation/freep-physical-linux-wave13b.json`

These runs prove the recorded command and physical-input lifecycles. They are not pixel-diff acceptance evidence.

## Repository Gates

The full Release build completed with **0 warnings and 0 errors**.

The final default test checkpoint recorded:

- **33,081 total**
- **32,948 executed and passed**
- **0 failed**
- **133 not executed**

Repository preflight passed after regenerating the FreeP whole-window evidence manifest, FreeW command inventory, FreeX functional parity inventory and classification, and the shared surface catalog.

## Generated Inventory Changes

- FreeX canonical command count increased from 531 to 532.
- FreeX commands projected by both hosts increased from 473 to 474.
- `Secondary Axis Series` is now classified as `PARITY`.
- FreeW's generated command evidence now records Avalonia registry sources for `Edit Shape`, `Convert to Freeform`, and `Edit Points`.

The generated inventories establish definition, registration, and classification coverage. They do not by themselves prove visual equivalence or exhaustive runtime behavior.

## Remaining Work

### FreeX

- Review and close the remaining legacy WPF chart-axis controls, including label font, label angle, axis line, ticks, number format, and logarithmic-scale workflows.
- Continue distinguishing intentional chart-capability guards from real host gaps with executable evidence.
- Expand matched-size, matched-DPI WPF/Avalonia visual acceptance for the full window, Backstage, ribbons, dialogs, context menus, grid, formula bar, sheet tabs, and footer.

### FreeW

- Close the remaining Page Edit and richer grouped-object editing workflows.
- Extend native-print behavior and physical Linux evidence beyond the current family baseline.
- Add authoritative Word-rendered visual baselines for page composition, drawing objects, tables, charts, SmartArt, WordArt, and watermarks.

### FreeP

- Extend real-printer and native-dialog validation beyond deterministic CUPS paths.
- Expand PowerPoint-authoritative visual baselines and human review across presentation editing, media, charts, SmartArt, comments, proofing, accessibility, recording, captions, animation, and export workflows.

### Cross-App

- Continue replacing host-specific implementations with shared planners, models, resources, themes, and assets where behavior is genuinely common.
- Keep physical Linux interaction evidence separate from authoritative visual acceptance.
- Address the 133 default-lane rows that remain not executed when their platform or external prerequisites are available.

Wave 46 materially advances functional parity and leaves all executed Wave 46 gates green. The overall Avalonia-to-WPF goal remains active because authoritative visual acceptance and several deeper workflows remain incomplete.
