# Avalonia parity Wave 54

## Functional slices

- **FreeX** preserves the formula source while modifier sheet-tab navigation changes
  the pointed sheet or grouped-tab state. Ctrl/Meta pointing appends a qualified
  disjoint reference. WPF and Avalonia now share the disjoint-reference edit plan.
- **FreeW** places the floating text-box caret from a pointer click for horizontal
  text boxes, resolving the nearest paragraph, run, and offset while preserving run
  formatting during subsequent typing.
- **FreeP** exposes the shared slide-section accessible name, including item count
  and expanded/collapsed state, on the live Avalonia section header.

## Verification

- Repository preflight: passed.
- `dotnet build FreeX.slnx --configuration Release`: 0 warnings, 0 errors.
- Default non-UI lane: 33,096 passed, 0 failed, 133 skipped/other across 19
  test assemblies.
- Focused FreeX: 24 WPF/shared-planner tests, 4 service tests, and 2 Avalonia
  headless tests passed.
- Focused FreeW: 21 Avalonia floating-shape tests and 12 model shape tests passed.
- Focused FreeP: 13 slide-pane tests passed; the post-rebase accessibility test and
  source guard also passed 2/2.

## Linux Docker evidence

All family lanes used a 1280x820 desktop at 96 DPI and stopped only their own
harness container.

- FreeX physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-interactive/freex/interaction-validation/20260729T122212Z/`.
- FreeW family physical X11 lane: 37/37 passed.
  Evidence: `artifacts/linux-family-interactive/freew/sessions/20260729T122834858Z/family-validation/`.
- FreeP family physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-family-interactive/freep/sessions/20260729T123100504Z/family-validation/`.

These family contracts prove broad physical-input regression safety. They do not
claim feature-specific physical proof for floating text-box caret placement or
automation metadata, and they are not Microsoft Office pixel baselines.

## Remaining work

- FreeX: keyboard-created disjoint references, 3-D sheet references, and
  modifier-aware whole-row/whole-column multi-area pointing.
- FreeW: rotated text-box pointer mapping and drag selection within shape text.
- FreeP: broader live accessibility depth and PowerPoint-authoritative visual
  baselines.
- Cross-app: retain feature-specific Linux interaction evidence for new workflows
  and continue human visual review where Microsoft Office baselines are available.
