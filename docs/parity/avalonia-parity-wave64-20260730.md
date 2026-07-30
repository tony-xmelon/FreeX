# Avalonia/WPF parity Wave 64

Date: 2026-07-30

## Scope

Wave 64 closed the next workflow-depth slice in each application:

- FreeX: cross-sheet formula-reference grip resizing while formula editing remains active.
- FreeW: nested grouped-child shape text editing.
- FreeP: nested grouped-child rich-text formatting across runs and paragraphs.

## Delivered

### FreeX

WPF and Avalonia now preserve an existing formula edit while switching to a
qualified referenced worksheet. Reference overlays and grips follow the active
reference sheet, resizing preserves the quoted qualifier, and commit still
targets the original formula cell.

Commit: `a648b8f33e`

Detail: `docs/parity/avalonia-parity-wave64-freex-20260730.md`

### FreeW

Shared shape-text commands now resolve direct or nested group-child paths.
Avalonia carries that path through caret hit-testing, selection, insertion,
replacement, paragraph editing, formatting, undo, and redo while preserving
composed group transforms and native DOCX structure. WPF uses the same shared
command semantics.

Commits: `ab323c8ce8`, `dcfafe1753`

Detail: `docs/parity/avalonia-parity-wave64-freew-20260730.md`

### FreeP

WPF and Avalonia now route grouped-child run formatting through the same shared
recursive planner. Cross-run and cross-paragraph selections support Bold,
Italic, Underline, font family, font size, and color while preserving nested
shape bounds and native PPTX text structure.

Commit: `c45a976ed8`

Detail: `docs/parity/avalonia-parity-wave64-freep-grouped-child-formatting-20260730.md`

## Verification

Integrated focused managed tests: 9 passed, 0 failed.

- FreeX Avalonia: 2 passed.
- FreeX WPF: 1 passed.
- FreeW shared model: 2 passed.
- FreeW Avalonia: 1 passed.
- FreeW WPF: 1 passed.
- FreeP Avalonia: 1 passed.
- FreeP WPF: 1 passed.

Linux/X11 physical evidence:

- FreeX: 1/1 passed. The quoted cross-sheet formula was resized, committed to
  its original cell, calculated as 15, and saved cleanly.
- FreeW: 4/4 passed. The nested child was edited and saved as `Nested leaf!`,
  then reopened with both group transforms unchanged.
- FreeP: 5/5 passed. Grouped-child formatting, native PPTX persistence, and
  three-step undo/redo passed at 1280x820 and 96 DPI.

Repository-wide gates:

- Repository preflight: passed.
- Full `FreeX.slnx` Release build: 0 warnings, 0 errors.
- Serialized default non-UI suite: 33,561 passed, 0 failed, 133 skipped.

The first full build invocation used `--no-restore` in the fresh worktree and
reported missing NuGet asset files before compilation. The canonical rerun
with restore enabled completed cleanly.

## Remaining high-value slices

- FreeX: dedicated physical 3-D sheet-range point/grip proof and broader
  cross-sheet formula grammar variants.
- FreeW: nested grouped-child formatting breadth beyond the character routes
  covered here, followed by grouped non-shape object editing depth.
- FreeP: broader grouped-child caret navigation, keyboard selection, and
  multi-paragraph point-mode physical coverage.
- Cross-app: continue visual fidelity work after functional workflow-depth
  gaps, especially known FreeW dialog-family mismatches.
