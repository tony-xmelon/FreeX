# Avalonia parity Wave 86 integration

Date: 2026-07-31

## Integrated slices

- **FreeX:** Avalonia formula pointing now honors the persisted GenerateGetPivotData option for PivotTable value cells, using the shared planner to emit `GETPIVOTDATA` while preserving A1 references for ordinary cells and when the option is disabled.
- **FreeW:** Avalonia direct PDF export now emits floating images from shared floating-object snapshots with behind/in-front layering, page geometry, crop, opacity, rotation, original image bytes where possible, and raster fallback for effects.
- **FreeP:** WPF and Avalonia canvas gestures now share Escape cancellation precedence for move, resize, rotate, geometry, and marquee operations; capture, previews, guides, and stale-release commits are cleared consistently.
- **Shared ribbon:** Avalonia collapsed `RibbonComboBox` overflow projections now follow WPF enablement and command behavior instead of being unconditionally disabled.

## Verification

- Focused paired and nearby regression tests: **78/78 passed**.
- Ribbon UI lane: **36/36 passed**.
- Linux Docker interaction validation: **85/85 passed** (FreeX 24, FreeW 37, FreeP 24).
- Repository preflight: **passed**.
- Full Release build: **passed**, 0 warnings and 0 errors.
- Default lane raw result: **34,569 passed, 31 failed, 133 skipped**. The aggregate command reached its 20-minute orchestration timeout after every project except `FreeX.App.Avalonia.Tests` had completed; that remaining project then passed **1,870/1,870** alone. The clipboard and allocation-sensitive failures also passed on isolated rerun. The remaining **29 failures** are the established WPF off-screen renderer baseline: 26 FreeX print/render tests and 3 FreeP host-render tests.

## Remaining depth

- FreeX formula workflows still need broader edit/point-mode combinations and cross-sheet lifecycle evidence beyond the PivotTable reference branch covered here.
- FreeW PDF parity still lacks floating shapes, charts, WordArt, SmartArt, groups, flip, reflection, and several decorative effects.
- FreeP canvas interaction still needs deeper paired coverage for multi-object transforms and complex geometry workflows beyond Escape and capture-loss cancellation.
- Shared ribbon adaptive and visual depth remains ongoing beyond collapsed combo-box overflow enablement.
- The refreshed FreeW visual evidence still records 170 genuine mismatches. The largest repeated dialog families are Legal Notices, Page Setup, Borders and Shading, Options, and Table Properties.
