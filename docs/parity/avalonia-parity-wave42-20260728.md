# Avalonia Parity Wave 42

Date: 2026-07-28

## Closed Production Slices

### FreeX

Chart resize interactions now use one FreeX presentation sizing authority in
both WPF and Avalonia. Avalonia previously let a resize preview and commit fall
to the generic `8x8` minimum, while WPF preserves a usable `24x18` chart
surface. The shared rule now clamps both the live Avalonia preview and the
undoable command path while preserving the opposite edge for west and north
handle drags.

### FreeW

Avalonia live typing now applies the shared AutoCorrect and AutoFormat pipeline
used by WPF. Replacements, smart quotes, fractions, ordinal superscript, list
conversion, and hyperlink recognition are dispatched through undoable
paragraph commands and the shared option model. The Linux physical baseline
now includes exact clipboard proof that typing `I teh ` produces `I the `.

### FreeP

Both slideshow hosts now relayout active media and caption overlays when the
canvas changes size. The shared media interaction planner maps overlays by
shape id, and stale-slide resize events tear down obsolete overlays instead of
leaving media at stale letterbox coordinates.

## Verification

- Integrated affected-area tests: **246/246 passed**:
  **65 FreeX**, **124 FreeW**, and **57 FreeP**.
- Linux production-app physical baselines: **FreeX 24/24**, **FreeW 37/37**,
  and **FreeP 22/22**.
- Linux family harness source/contract tests: **9/9 passed**.
- Full Release solution build: **0 warnings, 0 errors**.
- Repository preflight: **passed**, including generated parity artifacts,
  project references, Linux packaging, conflict markers, FreeP dialog/pane
  evidence (**28/28 across 123 PNGs**), and FreeP whole-window evidence
  (**33/33 paired**).
- Default test solution: **32,811 passed, 17 stable baseline failures,
  133 not executed**. One clipboard timing test failed in the all-up run and
  passed immediately in isolation. The 17 stable failures are the existing
  FreeX source-order/portability guard baseline and do not cover the Wave 42
  production changes.

## Current Inventory State

- FreeX: **531** functional commands, **0 Avalonia-missing** and **0 classified
  real binding gaps**; **94** paired WPF/Avalonia screenshot surface ids.
- FreeW: **870** commands, **0 actionable WPF-missing** and **0 actionable
  Avalonia-missing**.
- FreeP: **513** commands, **511 shared-profile**, **0 actionable WPF-missing**
  and **0 actionable Avalonia-missing**; the other two are platform-only.

These generated counts prove catalog, route, and evidence coverage. They do not
establish complete behavioral or pixel-level parity.

## Remaining Work

- Continue real-document compound workflow testing: selection and editing,
  object manipulation, context menus, dialogs, keyboard paths, undo/redo,
  save/reopen, and export/print round trips.
- Run authoritative paired visual comparisons where host rendering remains
  toolkit-owned, especially FreeW output against Word and FreeP output against
  PowerPoint.
- Validate FreeP microphone and camera workflows on real Linux hardware,
  including non-empty locally encoded MP4 output.
- Broaden FreeP SmartArt, OMML, animation, chart-family, media/caption, and
  PowerPoint PDF/PNG baseline coverage.
- Keep FreeX dialog and shell visual review active despite complete paired
  surface ids; capture completeness and DPI-normalized dimensions are not
  pixel-fidelity acceptance.

The broad whole-app parity goal remains active.
