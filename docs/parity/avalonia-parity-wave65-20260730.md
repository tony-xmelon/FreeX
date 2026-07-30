# Avalonia/WPF parity Wave 65

Date: 2026-07-30

## Scope

Wave 65 closed the next workflow-depth residual in each application:

- FreeX: 3-D worksheet-span formula highlighting and grip resizing.
- FreeW: nested grouped-child text direction through the Drawing Format ribbon.
- FreeP: grouped-child logical caret navigation and paragraph-boundary editing.

## Delivered

### FreeX

The shared formula-reference planner now parses quoted, escaped, forward, and
reverse 3-D sheet qualifiers. WPF and Avalonia project the reference onto the
active worksheet using workbook order, preserve the exact qualifier during
grip resizing, and suppress out-of-span scanner leakage.

Commit: `0015f19fbb`

Detail: `docs/parity/freex-wave65-3d-formula-range-grip-20260730.md`

### FreeW

The shared text-direction command resolves root-relative nested child paths.
Both hosts target the same leaf while preserving sibling state and composed
group transforms. Avalonia now refreshes contextual command state when
selection moves from a group to a child without changing the Drawing context.

Commit: `b517f40ae0`

Detail: `docs/parity/2026-07-30-freew-wave65-text-direction.md`

### FreeP

Avalonia uses a renderer-neutral planner for logical caret movement, keyboard
selection, and paragraph-boundary edits in nested in-canvas text. WPF retains
its native `RichTextBox` route, with paired tests over the same logical
contract and grouped-child propagation.

Commit: `e49cfae457`

Detail: `docs/parity/2026-07-30-freep-wave65-caret-navigation.md`

## Verification

Focused managed coverage:

- Integrated focused matrix: 43 passed, 0 failed across 9 serialized project
  invocations.
- FreeX: 18 shared, Avalonia, WPF, and harness-source checks.
- FreeW: shared command, WPF route/round-trip, Avalonia nested selection, and
  shared contextual renderer refresh checks.
- FreeP: 30 shared presentation, 2 Avalonia, and 1 WPF checks.

Linux/X11 physical evidence:

- FreeX: 1/1 passed. A 3-D point selection was resized through a 27-position
  grip matrix, committed as `=SUM(Sheet2:Sheet3!B2:D4)`, calculated as `171`,
  and saved cleanly.
- FreeW: 4/4 passed. Child path `0,1` changed from `Horizontal` to `Rotate90`,
  saved, and reopened with transforms unchanged.
- FreeP: 5/5 passed. Grouped-child navigation, boundary edits, undo/redo, and
  native PPTX inspection passed.

Evidence:

- `artifacts/linux-interactive/freex/interaction-validation/20260730T074255Z/interaction-validation.json`
- `artifacts/freew-wave65-text-direction-20260730-run3/freew-wave65-nested-text-direction-validation.json`
- `artifacts/freep-wave65-grouped-caret-20260730/freep/sessions/20260730T071559192Z/freep-rich-text-shortcut-validation/results.json`

Repository-wide gates:

- Repository preflight: passed after regenerating the expected FreeP
  whole-window source-hash manifest.
- Full `FreeX.slnx` Release build: 0 warnings, 0 errors.
- Serialized default non-UI suite: 33,574 passed, 0 failed, 133 skipped.

## Remaining high-value slices

- FreeX: broaden physical native-workbook formula evidence beyond the bounded
  CSV clean-save route and continue deeper formula-edit grammar workflows.
- FreeW: grouped-child paragraph alignment and formatting breadth, then
  grouped non-shape object editing depth.
- FreeP: renderer-specific vertical visual-line navigation and broader
  multi-paragraph pointer-selection workflows.
- Cross-app: continue visual-fidelity work after functional workflow-depth
  gaps, especially known FreeW dialog-family mismatches.
