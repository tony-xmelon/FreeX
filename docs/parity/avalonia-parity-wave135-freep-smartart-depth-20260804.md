# FreeP Wave 135 SmartArt import depth

Date: 2026-08-04
Branch: `codex/avalonia-parity-wave135-freep-smartart-depth-20260804`

## Selected layout

This slice admits one bounded `increasingCircleProcess` cache grammar through
the shared reader and planner. The checked-in deterministic fixture
`tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide 9,
contains four ordered non-empty ellipse nodes with strictly growing square
diameters on one baseline, equal positive gaps, and three empty line roles.

## Implementation and contracts

`PptxPackageReader` admits only that seven-shape grammar. The existing shared
`SmartArtLayoutEngine.LayoutIncreasingCircleProcess` plan remains the geometry
source, and `SlideCompositor` supplies the same renderer-neutral operations to
WPF and Avalonia. The fixture generator, tool evidence, WPF host tests,
presentation corpus tests, Avalonia headless test, and paired renderer source
contracts cover the slice.

## Cache boundary

Missing or unreadable parts, wrong counts, duplicate or reordered text,
non-growing or non-square nodes, inconsistent gaps or baselines, extra roles,
connectors with text, effects, pictures, and otherwise unproven variants stay
on the preserved cached-drawing path. The existing richer PowerPoint-style
`increasingCircleProcess` cache with background, chord, and rectangle roles is
explicitly rejected by this grammar.

## Before / after

- Checked-in SmartArt fixture: 8 slides before, 9 after.
- FreeP workflow inventory: 106 rows before, 107 after.
- Audited imported increasing-circle grammar: not admitted before, one strict
  seven-shape grammar admitted after.

This is function-first parity evidence. It makes no PowerPoint-identical
geometry, effects, text-fitting, or visual-baseline claim.
