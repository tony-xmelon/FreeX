# Deduplication certification - 2026-08-22

## Checkpoint

- Audited `origin/main` at `b688e47423c6d905ece50ec6d1cbdb4df5eeed81` from the isolated
  `codex/dedup-certification-20260822` worktree.
- Regenerated `dedup-residual-metrics.json` and `dedup-residual-metrics.md` from that exact tree.
- Confirmed that all six candidates carried by the 2026-08-16 restart handoff are closed: measured text
  wrapping, output-stem policy, PDF transform math, atomic Portable PDF output, shared FreeP file-command
  composition, and shared FreeP asset-import port projection.
- This checkpoint is an audit and evidence update. It does not claim that the four newly identified slices
  below have been implemented.

## Current residual measurement

The scanner covers 2,510 production C# files and 576,922 code lines.

| Measure | Current | Previous checked-in report | Delta |
|---|---:|---:|---:|
| Exact duplicate coverage | 1.254589% | 1.161353% | +0.093236 percentage points |
| Normalized duplicate coverage | 1.523430% | 1.353434% | +0.169996 percentage points |
| Exact duplicate LOC | 7,238 | 6,548 | +690 |
| Normalized duplicate LOC | 8,789 | 7,631 | +1,158 |
| Measured code LOC | 576,922 | 563,825 | +13,097 |

The increase is not a reversal of the completed campaign. New product work after the prior checkpoint added
autosave/recovery and proofing implementations with second consumers. The scanner also continues to count
native WPF/Avalonia realization that is intentionally retained.

## Newly actionable scope

Four high-confidence cross-app families should be extracted in the next implementation iteration.

1. **Recovery workflow** - `FreePRecoveryWorkflow` and `FreeWRecoveryWorkflow` share recovery sequencing;
   product name and document noun are the meaningful inputs. Move the workflow to
   `Free.Shared.AppServices` and inject product text.
2. **Autosave session** - `FreePAutosaveSession` and `FreeWAutosaveSession` repeat lifecycle, recovery
   completion, snapshot identity, cleanup, and source adaptation. Share the session with serialization/read
   delegates and interval configuration; retain thin Presentation/Document adapters.
3. **Autosave recovery planner** - `PresentationAutosaveRecoveryPlanner` and `AutosaveRecoveryPlanner`
   repeat candidate preparation, ordering, completion, and disposition. Share the planner with fallback name
   and text descriptors as parameters.
4. **Atomic line-set storage** - `PresentationCustomDictionaryStore` and `CustomDictionaryStore` repeat line
   loading, directory preparation, atomic serialization, filesystem contracts, and physical filesystem
   adapters. Extract a shared atomic line-set store and retain app-specific dictionary operations.

The FreeP/FreeW Avalonia autosave adapters also contain repeated orchestration. Re-audit them after the shared
session/planner extraction: the common lifecycle should collapse naturally, while toolkit scheduling and
product editor/prompt projection remain host code.

## Accepted renderer floor

The remaining leading lexical matches were reviewed rather than accepted from scanner rank alone. They are
native WPF/Avalonia windows, dialogs, control trees, timers, routed/pointer input translation, focus and modal
lifetime, accessibility attachment, canvas drawing, slideshow/media realization, and product-specific text or
command catalogs. Their reusable decisions are already represented by portable planners/controllers in the
current architecture.

Examples include FreeP `MainWindow`, presenter/slideshow windows, `SlideCanvas`, selection adorners, media
controllers, and WPF/Avalonia dialog pairs; FreeW table, references, borders, icon-picker, page-setup, and
find/replace dialogs; and toolkit-native formula-bar key/modifier translation. These remain separate unless a
future behavioral change exposes portable policy inside them.

## FreeX visual evidence

The WPF parity tool built in Release with 0 warnings and 0 errors. A fresh capture was compared with the
preserved 2026-08-15 baseline.

| Check | Result |
|---|---:|
| Baseline manifest entries | 116 |
| Current manifest entries | 116 |
| Current successful captures | 116 |
| Capture failures / missing PNGs / duplicate IDs | 0 / 0 / 0 |
| Surface-ID changes | 0 |
| Pixel-identical surfaces | 92 |
| Changed surfaces reviewed | 24 |

The changed set consists of 16 ribbon/contextual-tab captures, two workbook screens, three Backstage panes,
and three dialogs. The ribbon and workbook differences are the expected newer adaptive ribbon and status-bar
content; workbook cells, selection, formula bar, sheet tabs, and layout remain aligned. The Backstage and
dialog changes are expected feature additions. Direct review found no blank surfaces, clipping, overlap, stale
dialogs, or broken layout.

One intentional dimension change was recorded: `dialog.AutoFilter` grew from 312x475 to 312x481 to include
the newer filter controls. The strict pixel comparer returned a nonzero exit because its zero-tolerance hard
screen gate treats the expected ribbon/status-bar changes in `grid.demo` and `grid.sheetTabsOverflow` as
regressions. Manual comparison confirms both current screens are intact.

Evidence directories:

- Baseline: `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-baseline-20260815`
- Current: `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-current-20260822`
- Report: `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-report-20260822`

## Next iteration

Implement the four newly actionable families as separate, behavior-preserving slices. For each slice, add
shared contract tests plus FreeW/FreeP adoption tests, then regenerate residual metrics. Re-run FreeX visual
capture only if shared shell/ribbon/rendering code changes; the four current candidates are outside FreeX's
renderer path.
