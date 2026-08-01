# Avalonia parity Wave 99 integration

Date: 2026-08-01

## Scope

Wave 99 advances one bounded parity slice in each application and integrates two compatible
FreeP changes that reached `main` during the wave.

### FreeX: nested outline persistence

- Filter-owned row visibility remains independent from group-owned visibility. Expanding an outer
  row group does not resurrect rows excluded by an active value filter.
- XLSX save/reopen is exercised twice. Row and column outline levels, collapsed anchors,
  filter-hidden rows, and filter ownership survive both round trips.
- The Linux physical selector `outline-nested-save-reopen` drives the production row and column
  gestures, saves with `Ctrl+S`, inspects the worksheet package, reopens through the production
  Open route, and reads the seeded values back through X11 clipboard interaction.

Physical Docker evidence passed 3/3 at
`artifacts/linux-interactive/freex/interaction-validation/20260801T180602Z/interaction-validation.json`.
The saved package reported exact row levels `10:1,11:2,12:2,13:1,14:1` and column levels
`8:1,9:2,10:2,11:2,12:1`; reopened values also matched exactly.

### FreeW: Backstage Open geometry

- The Avalonia classic Open tab height now matches the measured WPF authority at 22 DIP.
- Paired evidence improved from 63,809 to 61,061 changed pixels and from 18.991% to 18.173%
  changed-pixel ratio. Mean delta improved from 16.754 to 15.781.
- Perceptual hash distance moved from 9 to 12, so the surface remains a genuine visual mismatch
  despite the measured geometry improvement.

### FreeP: OMML inherited math defaults

- The shared OMML model now carries math properties and overlays them property by property.
- The parser inherits `m:mathPr` from containing raw wrappers and accepts caller-supplied document
  defaults while preserving paragraph-local and `oMathParaPr` precedence.
- Inline root wrappers carry inherited font properties into layout.
- The generated FreeP inventory now contains 103 evidence rows.

The upstream integration also includes FreeP RTF interior-row-border preservation, Avalonia
nested inline-table rendering and cell editing, plus FreeW table-cell and page-border rendering.
Their focused tests were rerun after each merge. One stale FreeW source guard was corrected to
assert the retained 1.5-DIP inset expression after its local variable declaration was refactored.

## Verification

- Repository generated-artifact preflight: passed across 10,283 text files after the final upstream
  merge and deterministic manifest/dashboard regeneration.
- Full serialized Release build: passed, 98 projects, zero warnings and zero errors.
- Full `FreeX.DefaultTests.slnx` Release suite before the final upstream sync: passed with no
  failures.
- FreeX focused model, IO, and Avalonia guard tests: 1/1, 1/1, and 9/9 passed.
- FreeX Linux physical nested-outline validation: 3/3 passed.
- FreeW Backstage tests: 35/35 passed; WPF, Avalonia, and paired capture lanes each passed 1/1.
- FreeP OMML tests: Presentation 260/260, WPF host 42/42, Avalonia renderer 43/43 passed.
- FreeP inventory contract: 23/23 passed.
- Integrated FreeP RTF clipboard tests: 52/52 passed.
- Integrated FreeP Avalonia rich-editor tests: 30/30 passed.
- Final upstream FreeP Presentation and Avalonia-renderer suites: 3,306/3,306 and 213/213 passed.
- Final upstream FreeW Presentation suite: 1,095/1,095 passed.
- Final upstream FreeW Host page/table-border classes: 20/20 passed.
- Final upstream FreeW Avalonia page/table-border classes: 52/52 passed.

## Remaining work

- FreeX still needs a physical combined filter-flyout plus outline-retention scenario; the shared
  model and repeated XLSX round trip are authoritative for that behavior today.
- FreeW still has 167 catalogued genuine visual mismatches. Backstage Open retains native chrome,
  text rasterization, and other geometry differences.
- The all-up FreeW Host suite currently has seven unrelated failures in dialog-message, ribbon
  icon/SmartArt, sister-app Backstage, and chart source guards. None belongs to the final upstream
  page/table-border slices; their focused Host tests pass 20/20.
- FreeP still needs PowerPoint-authoritative work on document math defaults, fallback behavior,
  and font metrics. The parser API accepts external defaults, but the production package pipeline
  does not yet supply a document-default corpus.

Wave 99 therefore advances the active parity goal but does not claim complete Avalonia/WPF parity.
