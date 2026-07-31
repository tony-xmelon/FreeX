# Avalonia parity wave 81 integration (2026-07-31)

## Integrated slices

- Shared ribbon: editable combo boxes now clear the duplicate Enter-suppression window after any intervening non-Enter key, preserving later WPF-style commits.
- FreeX: `Ctrl+P` and `Ctrl+Shift+F12` now enter the in-workbook Backstage Print pane, matching WPF, while the native Print Preview command remains direct.
- FreeW: the Avalonia Reviewing Pane now exposes and applies the WPF Sequence, Author, Type, and Date sort choices through a shared presentation planner.
- FreeP: a bounded stateful command comparison found no app-specific functional mismatch in the assigned transition, animation, View, and Review slices.
- Linux harness: the FreeX print-shortcut probe now validates the in-workbook Backstage lifecycle and has a focused `backstage-print` selector.

## Validation

- Repository preflight: passed.
- `FreeX.slnx` Release build: passed with 0 warnings and 0 errors.
- Wave-focused managed checks: 172 passed, 0 failed.
- FreeX Linux physical X11 evidence: 23 unrelated rows passed in the broad lane; the corrected focused Backstage Print row passed 1/1, covering all 24 rows.
- FreeW Linux family evidence: 37/37 passed.
- FreeP Linux family evidence: 24/24 passed.

The full default suite executed 34,541 tests: 34,511 passed and 30 failed, with 133 not executed. All 30 failures were confined to Windows off-screen bitmap assertions in `FreeP.App.Host.Tests` (3) and `FreeX.App.Host.Logic.Tests` (27). A failing FreeP bitmap assertion reproduced unchanged in the pre-wave FreeP agent worktree, where WPF `RenderTargetBitmap` also returned a black image, so this is recorded as a current host graphics-environment exception rather than a Wave 81 regression. The changed functional suites and all Linux physical lanes are green.
