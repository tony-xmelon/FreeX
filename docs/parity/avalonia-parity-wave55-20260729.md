# Avalonia parity Wave 55

## Functional slices

- **FreeX** now appends whole-row and whole-column formula-point references through
  the shared planner in both WPF and Avalonia. A1 mode emits Excel shorthand such
  as `B:B` and `3:3`; cross-sheet qualifiers are preserved, and R1C1 retains the
  explicit full extent.
- **FreeW** maps pointer caret placement through the inverse renderer transform for
  90- and 270-degree floating text boxes.
- **FreeP** shares Selection Pane select, rename, visibility, and ordering
  accessibility tooltip metadata between WPF and Avalonia.

During integration, the all-up lane exposed two compatibility issues in the FreeX
slice. The WPF host's old shorthand rewrite could remove a cross-sheet qualifier,
and a new private overload made legacy reflection tests ambiguous. WPF now consumes
the shared formatted span directly, the range path has a distinct method name, and
the legacy shorthand tests target the shared planner contract.

## Verification

- Repository preflight: passed.
- Generated parity documentation: current.
- `dotnet build FreeX.slnx --configuration Release`: 0 warnings, 0 errors.
- Default non-UI lane: 33,103 passed, 0 failed, 133 skipped/non-executed across
  19 test assemblies.
- Focused FreeX repair lanes: 14 legacy R52 host-logic tests, 2 Wave 55 WPF tests,
  and 3 shared planner tests passed.
- Focused FreeW rotated text-box tests: 22 passed.
- Focused FreeP Selection Pane tests: 10 shared planner tests, 2 Avalonia tests,
  and 1 WPF source guard passed.

## Linux Docker evidence

All lanes used a 1280x820 desktop at 96 DPI and stopped only their harness-owned
container.

- FreeX physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-interactive/freex/interaction-validation/20260729T131538Z/`.
- FreeW family physical X11 lane: 37/37 passed.
  Evidence: `artifacts/linux-family-interactive-wave55/freew/sessions/20260729T132223617Z/family-validation/`.
- FreeP family physical X11 lane: 24/24 passed.
  Evidence: `artifacts/linux-family-interactive-wave55/freep/sessions/20260729T132451478Z/family-validation/`.

These family baselines prove broad physical-input regression safety. They are not
feature-specific physical proof for rotated shape-text caret placement or
accessibility metadata, and they are not Microsoft Office pixel baselines.

## Remaining work

- FreeX: keyboard-created multi-area references, 3-D sheet references, and broader
  modifier-aware keyboard selection.
- FreeW: drag selection within shape text and broader renderer fidelity.
- FreeP: explicit live accessible names for slide thumbnail containers, followed by
  notes and adjacent-pane accessibility snapshots.
- Cross-app: continue feature-specific Linux interaction evidence and authoritative
  Microsoft Office visual comparison where those baselines are available.
