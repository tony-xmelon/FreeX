# Avalonia parity Wave 60

Date: 2026-07-30

## Functional and physical evidence slices

- **FreeX grid drag** now has a focused physical Linux/X11 lane for autofill,
  selection-border move, and Ctrl-drag copy. The final run passed 3/3 with
  exact persisted values and calibrated destination-selection geometry.
- **FreeW Table Properties** now has standalone physical Linux/X11 coverage
  for the real four-page dialog. The probe visits Table, Row, Column, and Cell,
  edits `IndentFromLeftPt` to `12`, activates the real OK button, and verifies
  the exact applied 2x2 table model.
- **FreeP internal-slide hyperlinks** now have end-to-end physical Linux/X11
  coverage. The real Insert Hyperlink dialog authors the seeded slide-2 ID on
  a visible shape; the probe transforms that shape's slide-space center into
  the discovered slideshow window and physically activates it. The authored,
  activated, and seeded target IDs match, and the slideshow reaches index 1.

## Production changes

- FreeX restores and redraws the complete destination range after the generic
  Ctrl-drag copy command temporarily collapses selection during its edit
  refresh.
- FreeW exposes stable automation IDs on the Table Properties tab headers and
  records validation-only focus/page transitions. Its opt-in startup fixture
  creates and selects a deterministic 2x2 table.
- FreeP adds opt-in deterministic hyperlink fixture and postcondition hooks.
  These hooks are inactive outside the physical validation environment.

## Integration review

- The first FreeX physical attempt passed autofill and move but exposed a
  stale source marquee after Ctrl-copy. The final production fix and rerun
  selected the copied destination and passed 3/3.
- FreeW probe development initially showed that synthetic `Ctrl+Tab` did not
  switch Avalonia pages and an extra Tab selected Cancel. The final lane uses
  real tab-header pointer input, records all four page transitions, and ends
  with `TablePropertiesOkButton`.
- FreeP's first attempt failed before startup because its result directory did
  not exist. A later calibration clicked slideshow background and advanced
  normally, which correctly failed because no hyperlink activation
  postcondition was emitted. The final lane uses explicit nonzero shape bounds
  and a geometry-derived click, proving true hyperlink activation.

## Focused verification

- FreeX Avalonia host/source regressions: 2 passed.
- FreeX shared grid-selection move planner: 7 passed.
- FreeX physical X11 grid-drag selector: 3 passed.
- FreeW Avalonia focused dialog tests: 21 passed.
- FreeW WPF authority focused tests: 3 passed.
- FreeW physical X11 Table Properties workflow: 1 passed.
- FreeP shared presentation hyperlink tests: 32 passed.
- FreeP WPF authority hyperlink tests: 19 passed.
- FreeP Avalonia hyperlink/slideshow tests: 10 passed.
- FreeP fixture source test: 1 passed.
- FreeP physical X11 internal-slide hyperlink workflow: 1 passed.

Repository preflight required one deterministic refresh of the FreeP
whole-window visual-evidence source hashes after integration. The refreshed
manifest covers 170 artifacts.

## Remaining work

- Physical evidence is still intentionally sampled rather than exhaustive.
  Continue with the highest-risk workflows not yet represented by exact
  Linux/X11 input and model postconditions.
- FreeW's canonical visual comparison still contains the broad visual residual
  set reported by Wave 59; this wave adds dialog behavior evidence rather than
  claiming those pixel mismatches are resolved.
- Authoritative Office application baselines are unavailable on this host.
  WPF remains the local platform authority where Office-level evidence cannot
  be captured.
