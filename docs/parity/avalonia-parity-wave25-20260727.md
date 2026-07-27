# Avalonia parity Wave 25

Date: 2026-07-27

Wave 25 advanced one bounded parity slice in each app and refreshed the
repository-wide generated evidence.

## FreeX

- Rebuilt the Avalonia Go To dialog with the shared compact dialog chrome and
  WPF-aligned star/auto row structure, list, text box, buttons, and initial
  focus behavior.
- Promoted fresh current-source WPF and Linux Docker/Xvfb captures at 420x320.
- Replaced the historical WPF tour screenshot so the active comparison now has
  matching fixture provenance.
- Reduced the `dialog.GoTo` triage score from `0.110485` to `0.065963`, a 40.3%
  improvement.
- The next FreeX visual outlier is `dialog.Options.Save` at `0.105011`.

## FreeW

- Moved direct-label Backstage export action rows into the shared WPF composer
  and used the same button-plus-description structure in Avalonia.
- Preserved shared planner group order, callbacks, XPS capability gating, and
  editable file-type actions.
- Removed the `action-button-order` semantic difference from
  `backstage-export.open`.
- The isolated changed-pixel ratio remains `0.18229464285714286`; the remaining
  difference is honestly classified as a visual mismatch dominated by toolkit
  text rasterization and scrollbar chrome.

## FreeP

- Admitted PowerPoint `hierarchy3` SmartArt into the shared live-layout path.
- Reconstructed omitted DiagramML `parOf` connections, ignored document-root
  connections, and filtered blank template leaves from the visible live plan.
- Routed `hierarchy3` through a shared left-to-right hierarchy layout with
  renderer-neutral connector shapes consumed by WPF and Avalonia.
- Added corpus, reader, editing, layout, and source-contract evidence plus
  generator-backed inventory provenance.
- Exact PowerPoint sizing, connector routing, effects, and authoritative PNG
  comparisons remain external baseline work.

## Verification

- FreeX Avalonia dialog visual source lane: 6 passed.
- FreeX WPF Go To dialog lane: 29 passed.
- A broader FreeX Go To/R1C1 filter passed 38 tests and exposed one unrelated
  existing reflection-harness failure:
  `F4_InInlineEditor_WhenR1C1ModeEnabled_CyclesR1C1Reference` throws
  `TargetParameterCountException`.
- FreeW shared Backstage planner lane: 13 passed.
- FreeW shared WPF Backstage composer lane: 19 passed.
- FreeW Avalonia Backstage lane: 29 passed.
- FreeP presentation suite: 2,689 passed.
- FreeP SmartArt/reader WPF host lane: 169 passed.

## Generated state

- FreeX: 531 functional commands, zero actionable Avalonia command gaps, 57/57
  dialog routes, and 94 paired screenshot surfaces. There are zero nonblank,
  logical-dimension, or expected-size failures.
- FreeW: 870 commands and zero actionable generated command gaps. The
  canonical all-dialog report remains the all-scenario authority; the isolated
  Wave 25 evidence records the Export semantic improvement without replacing
  it with a one-scenario run.
- FreeP: 346 commands, 344 shared, two intentional platform-only, zero
  actionable generated command gaps, and 100 workflow-evidence rows.

Generated command and route coverage is not a claim of complete behavioral or
pixel-level parity. The next bounded local visual work starts with FreeX
`dialog.Options.Save` and the next ranked FreeW canonical mismatch; FreeP still
requires additional unsupported SmartArt layout families, workflow depth, and
PowerPoint-authoritative baseline slices.
