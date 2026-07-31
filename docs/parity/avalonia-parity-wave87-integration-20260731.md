# Avalonia parity Wave 87 integration

Date: 2026-07-31

## Integrated slices

- **FreeX:** Avalonia now preserves an existing formula edit's 3-D sheet span across sheet-tab navigation and subsequent F2 point mode, matching WPF instead of reducing the reference to the final sheet.
- **FreeW:** Avalonia direct PDF export now emits floating AutoShapes as vector content with shared geometry plans, fills, gradients, strokes, run-aware text, rotation, page placement, and merged image/shape z-order in the behind-text and in-front bands.
- **FreeP:** WPF move, resize, and rotate gestures now use the shared drag-start and commit thresholds already used by Avalonia. Sub-threshold multi-selection moves no longer mutate shapes or create undo entries.
- **Shared ribbon:** Avalonia collapsed-group overflow now omits layout-only separators and row breaks like WPF.
- **Linux harness:** the FreeX exhaustive runner's authoritative ribbon-binding totals were refreshed to the already-tested 631 placement rows and 74 collapsed groups, with a source assertion tying those values to the live ribbon inventory.

## Verification

- Focused paired, PDF, planner, ribbon, and harness tests: **112/112 passed**.
- Ribbon UI lane: **37/37 passed**.
- Linux Docker physical validation: **85/85 passed** (FreeX 24, FreeW 37, FreeP 24). FreeX was rebuilt and rerun after the final `origin/main` merge.
- The exploratory FreeX managed `ribbon-bindings` section produced **705/705 passed** rows. Its wrapper initially rejected the manifest because it still expected the older 616/73 inventory totals; the runner contract and regression assertion are now current.
- Repository preflight after the final `origin/main` merge: **passed**. One earlier run encountered a transient Roslyn `csc.exe` exit `-1` in a temporary generated-inventory project; the foreground rerun passed without source changes.
- Full Release build after the final merge: **passed**, 0 warnings and 0 errors.
- Final default lane, serialized to avoid parallel testhost starvation: **34,636 passed, 0 failed, 133 skipped** across 34,769 tests. Earlier parallel attempts reached their orchestration guards, but retained TRX files and isolated reruns showed only clipboard/allocation contention. The authoritative serialized run completed in 9m49s with no failures; the 29 WPF off-screen renderer failures seen in Waves 85-86 did not reproduce.

## Remaining depth

- FreeX formula workflows still need broader cross-workbook/external-reference point-mode and edit-lifecycle evidence.
- FreeW PDF export still lacks shape flips, pattern-fill fidelity, dashed outlines, effects, charts, WordArt, SmartArt, groups, watermarks, and several page decorations.
- FreeP multi-selection resize and rotate handles remain single-selection-only in both hosts; broader multi-object transform fidelity remains open.
- Shared ribbon popup chrome and focus ownership remain toolkit-native beyond the now-aligned overflow projection contract.
- FreeW retains 170 genuine visual-comparison mismatches; Legal Notices, Page Setup, Borders and Shading, Options, and Table Properties remain the largest repeated dialog families.
