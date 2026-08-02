# Avalonia parity Wave 104

Date: 2026-08-02

## Scope

Wave 104 advances one parity slice in each application, removes duplicated
split-pane geometry from the desktop hosts, and strengthens the Linux physical
evidence so focused probes cannot pass on ribbon-only or blank-region changes.

## FreeX

WPF and Avalonia now share `SplitPanePointerPlanner` for divider geometry,
divider targets, mini-scrollbar layout, hit testing, page/track movement, and
wheel ownership. WPF's split-pane chrome delegates to the shared planner rather
than retaining a second scrollbar calculation.

Avalonia now provides real pointer capture for divider/thumb dragging and routes
all permitted split-pane scrolling through the same main viewport authority as
WPF. Vertical wheel input is handled during tunneling so Avalonia's
`ScrollViewer` cannot consume BottomLeft input first. Divider targets are
relative to the current split anchor, independent of the shared main viewport's
current row/column origin.

The focused Linux lane physically opens View > Split at C5 and proves:

- the horizontal divider moves from row 5 to row 6;
- TopRight Shift+wheel moves the shared column band;
- BottomLeft wheel moves the shared row band after crossing the pinned rows; and
- a TopRight mini-scrollbar track click moves the shared column band.

All four physical rows passed at 1280x820 and 96 DPI. The lane validates only
grid crops for split activation, includes row headers in the vertical evidence,
and no longer credits ribbon focus or blank-cell equality.

## FreeW

Backstage Home layout and action order now come from
`BackstagePaneSurfacePlanner`. WPF and Avalonia consume the same heading,
description, recent-document groups, action ordering, typography, and measured
surface geometry.

Fresh paired 560x600 evidence improved the Home comparison:

| Metric | Prior | Wave 104 |
| --- | ---: | ---: |
| Changed-pixel ratio | 16.1482% | 14.2705% |
| Mean channel delta | 13.839 | 11.518 |
| Changed pixels | - | 47,949 / 336,000 |
| Perceptual hash distance | - | 6 |
| Semantic difference | `action-button-order` | none |

Both captures pass their content gates. The row remains a
`genuine-visual-mismatch`; residual text and native-scrollbar rasterization are
not relabeled as visual parity.

## FreeP

The visible SmartArt text pane now refreshes after editor Undo and Redo in both
WPF and Avalonia. The Linux lane was expanded to six physical rows and its stale
Apply/shortcut coordinates were corrected so evidence reaches the real command
strip and shell shortcut route.

The final 6/6 physical result proves visible-pane discovery, Add sibling, Apply
text, Apply then Undo/Redo pane readback, Ctrl+S package persistence, and reopen
in a fresh FreeP process. Package inspection verifies the native SmartArt data
part and cached drawing part rather than accepting only editor text.

The FreeP whole-window evidence manifest was regenerated after the final
upstream merge and contains 173 tracked artifacts.

## Focused verification

- FreeX Avalonia Wave104 split-pane tests: 6 passed.
- FreeX WPF split-pane tests: 118 passed, 2 benchmark tests skipped.
- FreeX Linux source contract: 1 passed.
- FreeX Linux Docker/X11 split-pane pointer lane: 4 passed.
- FreeW presentation Home/shared-surface tests: 18 passed.
- FreeW Avalonia Backstage/source tests: 44 passed.
- FreeW WPF shared Backstage source tests: 3 passed.
- FreeP Avalonia SmartArt source contracts: 3 passed.
- FreeP Avalonia SmartArt focused suite: 25 passed.
- FreeP WPF SmartArt focused suite: 242 passed.
- FreeP Linux Docker/X11 SmartArt authoring lane: 6 passed.

## Repository gates

- Repository preflight passed, including the conflict-marker scan across 10,426
  text files and all generated-evidence freshness checks.
- `dotnet build FreeX.slnx --configuration Release --verbosity minimal`
  passed with 0 warnings and 0 errors.
- The default non-UI lane accounted for all 19 runnable test assemblies:
  35,391 passed, 0 failed, and 133 framework-skipped discoveries out of 35,524.
  The initial run exposed one stale probe-order source assertion; the corrected
  test and its complete 2,564-test assembly both passed on rerun.

## Remaining

The overall parity goal remains active. FreeW Home still has a measurable
14.2705% visual delta, and the generated family dashboards retain other genuine
visual mismatches and deeper workflow candidates. Wave 104 proves these three
slices; it does not claim whole-product parity.
