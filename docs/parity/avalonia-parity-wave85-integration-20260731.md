# Avalonia parity Wave 85 integration

Date: 2026-07-31

## Integrated slices

- **FreeX:** the visible Avalonia formula-bar Cancel button now uses the full edit-cancellation lifecycle, restoring the source cell, committed value, worksheet focus, and clearing point/range-entry state like WPF and Escape.
- **FreeW:** Avalonia PDF export now emits laid-out inline PNG/JPEG images, preserving crop, transparency, and rotation where supported and raster-baking effect paths when needed.
- **FreeP:** WPF and Avalonia canvas gestures now share capture-loss cancellation semantics, clearing pending resize/move state, previews, and guides.
- **Shared ribbon:** Avalonia split-button dropdown zones match WPF metrics and enablement, and collapsed groups receive derived keytips. A stale FreeX assertion was aligned with the shared WPF contract: command-only actions disable when unregistered, while real menu hosts remain reachable.

## Verification

- FreeX formula Cancel paired runtime evidence: **2/2 passed**.
- FreeW Avalonia PDF export tests: **5/5 passed**.
- FreeP capture-loss paired runtime evidence: **2/2 passed**.
- Shared Avalonia/WPF split-button tests: **19/19 passed**.
- Ribbon UI lane: **35/35 passed**.
- Linux Docker interaction validation: **85/85 passed** (FreeX 24, FreeW 37, FreeP 24).
- Repository preflight: **passed**.
- Full Release build: **passed**, 0 warnings and 0 errors.
- Default lane raw result: **34,557 passed, 33 failed, 133 skipped**. The new stale ribbon assertion and three contention-sensitive tests all passed on isolated rerun. The remaining **29 failures** are the established WPF off-screen renderer baseline: 26 FreeX print/render tests and 3 FreeP host-render tests.

## Remaining depth

- FreeX formula workflows still need broader edit/point-mode combinations and cross-sheet lifecycle evidence.
- FreeW PDF parity still lacks floating images, drawings/charts, watermarks, line numbers, and several decoration/effect details.
- FreeP still does not cancel active canvas drags with Escape in either host; capture-loss parity is complete.
- Shared ribbon adaptive and visual depth remains an ongoing parity area beyond the split-button and collapsed-keytip behavior covered here.
