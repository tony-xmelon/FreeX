# Avalonia parity Wave 100 integration

Date: 2026-08-01

## Scope

Wave 100 advances a functional or visual parity slice in each app and integrates compatible
upstream work that reached `main` during the wave.

### FreeX: filtered nested-outline physical workflow

- A deterministic XLSX fixture carries a value filter and two row-outline levels.
- The Linux X11 selector `outline-nested-filter-save-reopen` operates the real Avalonia filter
  flyout twice, collapses and expands the nested and outer outline groups, saves, reopens through
  the production Open route, and reads the visible values back through physical selection input.
- Package inspection proves exact outline levels, filter range and value criteria, uncollapsed
  group state, and cell values. Filter-owned visibility is correctly reconstructed from the saved
  criteria rather than serialized as outline/group-owned `hidden` row attributes.
- Startup calibration now accepts the wider row-header gutter of a pre-grouped workbook, and the
  fixture generator uses a bounded staging filename under long validation report paths.

The final Docker/X11 run passed 1/1 at
`artifacts/linux-interactive/freex/interaction-validation/20260801T194053Z/interaction-validation.json`.
The physical sequence observed rows 3 and 6 remain filtered while outline-owned rows restored.

### FreeW: shared About dialog visual alignment

- The shared Avalonia About realization now matches measured WPF content bounds, text inset and
  size, focused input border, and neutral default-button treatment more closely.
- Both `about.initial` and `about.populated` improved from 41,898 to 38,489 changed pixels at
  560x600: 12.4696429% to 11.4550595% (-1.0145833 percentage points).
- Mean channel delta improved from 16.0905804 to 14.0832411; pHash distance remains 2.
- Both scenarios remain honestly classified as genuine visual mismatches because glyph rendering,
  line boxes, and truthful platform text still differ.

### FreeP: production OMML default propagation

- The package reader captures authored defaults only from an actual related settings part and from
  containing `a:graphicData/m:mathPr`; ordinary PPTX packages remain null at that level rather than
  receiving fabricated settings.
- The production compositor now applies property-wise precedence across PowerPoint's Cambria Math
  fallback, package/document defaults, containing graphic defaults, raw wrapper defaults, and
  paragraph/local properties.
- WPF and Avalonia consume the same shared parsed math layout. Model cloning retains containing
  properties, and generated parity inventory evidence points to package, compositor, and renderer
  tests.

The final upstream sync also includes WPF OLE in-place hosting fallback, native SmartArt cache
connector preservation, FreeP nested-table keyboard behavior, and FreeW page-border display,
z-order, and Apples-art rendering. The overlapping default-equation-font work was reconciled with
the authored-default precedence above.

## Verification

- Final repository preflight: passed across 10,305 text files.
- Serialized Release build before the final upstream sync: 98 projects passed with zero warnings
  and zero errors.
- Default non-UI matrix before the final upstream sync: every project passed except one
  order-sensitive `R108_PlainCtrlVMultiAreaFormattingCarryTests` occurrence. The exact test then
  passed 1/1, and its complete Host Logic project passed 1,488 with four expected skips (1,492
  total).
- FreeX focused model, Avalonia guard, and WPF About checks: 2/2, 9/9, and 1/1 passed.
- FreeX Linux physical filtered-outline lane: 1/1 passed.
- FreeW About/shared-dialog and affected Avalonia guards: 80/80 passed; page-border Presentation
  checks passed 8/8 before and 15/15 after the final upstream sync.
- FreeW WPF/Avalonia About captures: each route passed 1/1; paired metrics improved as recorded
  above.
- FreeP pre-sync OMML parser/layout/integration checks: 263/263 passed; WPF and Avalonia parity
  checks passed 3/3 and 1/1.
- Final merged FreeP checks: Presentation 156/156, WPF Host 287/287, and Avalonia parity 1/1 passed.
- Final merged FreeW Avalonia page-layout source/behavior checks: 58/58 passed.

## Remaining work

- FreeX now has physical evidence for combined value filtering, nested row-outline interaction,
  save, and reopen. Broader cross-feature physical workflows and remaining visual fidelity still
  require continued evidence and correction.
- FreeW About remains a genuine visual mismatch, and the canonical dialog report still contains
  167 genuine mismatch rows across the wider app.
- FreeP still needs PowerPoint-authoritative font fallback and exact Cambria Math metrics, plus a
  real authored settings-part corpus if such nonstandard PresentationML packages are encountered.
- Authoritative Microsoft Office PNG baselines remain unavailable in the generated cross-app
  dashboard inputs, so app-owned WPF/Avalonia comparisons cannot establish Office pixel parity.

Wave 100 advances the active parity goal but does not claim complete Avalonia/WPF parity.
