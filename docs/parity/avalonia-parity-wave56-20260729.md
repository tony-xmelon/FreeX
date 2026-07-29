# Avalonia parity Wave 56

## Functional slices

- **FreeX** now shares Excel-style `F8`/`Shift+F8` formula point-mode selection
  semantics between WPF and Avalonia. Keyboard-created disjoint areas preserve A1
  or R1C1 notation, cross-sheet qualifiers, the active reference span, and the
  existing Ctrl+Arrow data-boundary behavior.
- **FreeW** now supports pointer drag selection inside horizontal, 90-degree, and
  270-degree floating shape text. Selection paint, replacement, deletion, and
  character-format mutations use undoable model commands and preserve paragraphs
  and formatting outside the selected span.
- **FreeP** now applies the shared slide-thumbnail accessible name to the live WPF
  and Avalonia item containers. Names refresh after title, selection, ordering,
  and section-state changes.

Integration review caught and repaired two FreeW range-formatting issues before
merge. The initial implementation formatted paragraphs outside the selected span,
and a follow-up briefly measured selection highlights with metrics that differed
from the uniform shape-body renderer. The final implementation validates both
selection endpoints, clones out-of-range paragraphs unchanged, and uses the same
9pt layout contract for visible text, caret stops, and highlights.

## Verification

- Generated parity documentation: current.
- Repository preflight: passed.
- `dotnet build FreeX.slnx --configuration Release`: 0 warnings, 0 errors.
- Default non-UI lane rerun: 33,121 passed, 0 failed, 133 skipped or not
  executed across 19 test assemblies.
- The first all-up default run had one transient failure in the unrelated
  `R57_PasteManualCalcNavCacheTests` clipboard/navigation-cache test. It passed
  immediately in isolation, and the complete default lane then passed on rerun.
- Focused FreeX lanes: 8 shared planner tests, 10 Avalonia keyboard tests, and
  1 WPF host test passed.
- Focused FreeW floating-shape lane: 25 passed.
- Focused FreeP lanes: 53 shared planner tests, 22 focused WPF tests, and
  15 Avalonia headless tests passed.

The FreeP whole-window evidence manifest was refreshed for the changed Avalonia
`MainWindow.cs` source hash. Its existing evidence remains 33/33 paired with no
explicit product mismatch or capture limitation.

## Linux Docker evidence

All lanes used a 1280x820 desktop at 96 DPI and stopped only their harness-owned
container.

- FreeX physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-interactive/freex/interaction-validation/20260729T140925Z/`.
- FreeW family physical X11 lane: 37/37 passed.
  Evidence: `artifacts/linux-family-interactive-wave56/freew/sessions/20260729T141550999Z/family-validation/`.
- FreeP family physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-family-interactive-wave56/freep/sessions/20260729T141816220Z/family-validation/`.

These are broad physical-input regression baselines. The new FreeX multi-area
keyboard path, FreeW shape-text drag selection, and FreeP accessibility metadata
also have focused automated coverage; they do not yet have dedicated Linux
feature probes or authoritative Microsoft Office pixel baselines.

## Remaining work

- FreeX: 3-D sheet references and modifier combinations beyond the bounded
  `F8`/`Shift+F8` path.
- FreeW: visible rich per-run shape-text rendering in both hosts, Shift+Arrow
  shape-text extension, drag auto-scroll, and advanced multiline geometry.
- FreeP: adjacent-pane accessibility snapshots and broader live assistive-
  technology evidence.
- Cross-app: continue feature-specific Linux interaction evidence and
  authoritative Microsoft Office visual comparison where baselines are available.
