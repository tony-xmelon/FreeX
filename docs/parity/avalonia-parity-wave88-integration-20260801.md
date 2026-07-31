# Avalonia parity Wave 88 integration

Date: 2026-08-01

## Integrated slices

- **FreeX:** WPF and Avalonia now use the shared formula-reference span recovery path when an
  existing external-workbook-qualified formula enters point mode. Replacement, disjoint append,
  commit, and Escape restoration retain the same edit lifecycle across both hosts.
- **FreeW:** the shared PDF draw-operation vocabulary and both portable writers now carry
  horizontal/vertical shape flips and outline dash patterns. Avalonia direct PDF export maps the
  same three DrawingML dash tokens already supported by the WPF renderer.
- **FreeP:** multi-selection exposes one group resize/rotate box in both hosts. Shared planning
  scales or rotates every selected shape, and one selection-filtered batch command owns undo.
- **Shared ribbon:** collapsed-group popups now share placement, first-enabled focus, wraparound
  Up/Down and Home/End traversal, Escape dismissal, and anchor-focus restoration contracts.
- **Generated evidence:** the FreeP whole-window manifest was refreshed for the changed shared
  Avalonia ribbon renderer fingerprint.

## Verification

- Focused paired planner/host/export/popup tests: **109/109 passed**.
- Complete shared PDF test project: **75/75 passed**.
- Ribbon UI lane: **38/38 passed**.
- Repository preflight: **passed** after regenerating the expected FreeP whole-window source hash.
- Full Release build: **passed**, 0 warnings and 0 errors.
- Serialized default lane: **34,650 passed, 0 failed, 133 skipped** across 34,783 tests.
- Linux Docker physical validation: **85/85 passed**:
  - FreeX: 24/24.
  - FreeW: 37/37.
  - FreeP: 24/24.

The FreeP family baseline proves the broader live Avalonia app and its existing physical input
contract. The new multi-selection resize/rotate handles are proven by paired WPF/Avalonia managed
host tests in this wave; a dedicated X11 group-handle drag probe has not yet been added.

## Remaining depth

- FreeX external workbooks remain cached-link metadata rather than live point-selection surfaces;
  external highlighting/cycling and multi-window source-workbook picking remain open.
- FreeW PDF export still lacks pattern-fill fidelity, shape effects, charts, WordArt, SmartArt,
  groups, watermarks, several page decorations, and Office-authoritative visual baselines.
- FreeP group transforms use axis-aligned union bounds for rotated members, and drag preview shows
  the group box rather than transformed member previews.
- Ribbon popup chrome, shadow, animation, screen-edge repositioning, nested submenu presentation,
  and foreground WPF native focus capture remain toolkit-specific.
- FreeW's existing genuine visual-comparison mismatch queue remains open; this wave changes PDF
  output depth and does not reclassify those dialog comparisons.
