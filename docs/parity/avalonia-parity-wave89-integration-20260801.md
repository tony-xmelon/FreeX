# Avalonia parity Wave 89 integration

Date: 2026-08-01

## Integrated slices

- **FreeX:** external-workbook-qualified formula references are parsed and highlighted as atomic
  tokens in both hosts. They retain the workbook/sheet qualifier during F4 anchor cycling and do
  not project a false selection box onto a same-named local sheet.
- **FreeW:** direct PDF export now carries real two-colour tiled pattern fills through the shared
  PDF operation vocabulary, the portable PDF writer, and the Skia writer. Pattern geometry follows
  shape rotation/flips and preserves existing outline dash metadata.
- **FreeP:** group resize/rotate gestures now show one live preview frame per selected member in
  WPF and Avalonia. Shared rotated-envelope geometry also includes each member's rendered footprint
  in selection chrome.
- **Shared ribbon:** collapsed-group popup geometry, padding, item rhythm, border, shadow, placement,
  and screen-edge policy now come from shared contracts. WPF screen coordinates are normalized from
  device pixels to DIPs before shared placement planning.
- **Physical evidence:** a dedicated FreeP X11 lane now proves two-shape selection, shared-handle
  resize, Shift-constrained rotation, exact persisted geometry, one-step undo, Escape cancellation,
  and capture-loss cancellation. The FreeX sheet-tab setup was hardened to use one real `+` click
  followed by physical `Shift+F11` insertions instead of extrapolating hidden button coordinates.

## Verification

- Focused FreeX WPF external-reference tests: **2/2 passed**.
- Focused FreeX Avalonia external-reference tests: **2/2 passed**.
- FreeW shared PDF tests: **51/51 passed**.
- FreeW Avalonia PDF export tests: **10/10 passed**.
- FreeP planner tests: **16/16 passed**.
- FreeP WPF host tests: **41/41 passed**.
- FreeP Avalonia adorner proof: **1/1 passed**.
- Ribbon UI lane: **38/38 passed**.
- Dedicated FreeP multi-selection physical X11 lane: **9/9 passed**.
- Linux Docker family interaction lanes: **85/85 passed**:
  - FreeX: 24/24.
  - FreeW: 37/37.
  - FreeP: 24/24.
- Repository preflight: **passed**, including generated parity documents and FreeP whole-window
  evidence at 33/33 paired surfaces.
- Full Release build: **passed**, 0 warnings and 0 errors.
- Serialized default lane: **34,723 passed, 0 failed, 133 skipped** across 34,856 tests.

The first final default-lane attempt had one transient Windows clipboard fallback failure. The exact
test passed immediately in isolation, and the complete default lane then passed on an unchanged tree.

## Remaining depth

- FreeX still lacks live cross-workbook point-mode routing: a formula token cannot yet capture a
  pointer gesture from another workbook window or resolve that source window/sheet for grid chrome.
- FreeW PDF export still lacks shape effects, WordArt, grouped drawing objects, charts, SmartArt,
  and Office-authoritative raster baselines for the remaining drawing families.
- FreeP previews are selection-chrome outlines rather than duplicate filled-shape compositor output,
  and the shared group handles remain axis-aligned rather than forming an oriented group frame.
- Ribbon native animation, nested submenu presentation, per-monitor WPF work-area selection, and
  final toolkit-specific raster details remain outside the shared popup contract.

