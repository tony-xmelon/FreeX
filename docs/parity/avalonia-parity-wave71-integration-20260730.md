# Avalonia parity Wave71 integration

Wave71 closed one functional depth slice in each app and refreshed the
canonical FreeW dialog evidence without weakening comparison policy.

## FreeX

Formula-bar point mode now treats physical column headers, row headers, and
the select-all corner consistently on Avalonia and WPF. Avalonia routes those
inputs through the existing formula range-selection path before any worksheet
selection commit.

Managed coverage passed for the Avalonia and WPF whole-range interactions.
The dedicated Linux X11 selector also passed 3/3 with exact semantic readback:
`=SUM(B:B)`, `=SUM(3:3)`, and active-edit
`=SUM(A1:XFD1048576)` followed by a blank cell after cancellation.

Detailed evidence:
`freex-wave71-formula-whole-range-point-2026-07-30.md`.

## FreeW

Grouped Chart and SmartArt children now participate in rotation and horizontal
or vertical flip commands. The model, shared command path, WPF route,
Avalonia renderer, clone path, and DOCX transform persistence all carry the
same transform state.

Focused managed verification passed 7/7 across model, DOCX, WPF host/ribbon,
source-contract, and Avalonia runtime tests. No physical Linux result is
claimed for this slice because the removed probe lacked an authored fixture
and deterministic semantic readback.

Detailed evidence:
`freew-wave71-grouped-graphic-transform-20260730.md`.

## FreeP

Shared rich-text paragraph selection now includes the following paragraph
marker when WPF does, while retaining marker-free behavior for the final
paragraph. Avalonia triple-click selection uses the shared planner.

The managed contract passed 1/1. Physical Linux pointer validation passed
5/5, including an exact newline-terminated `xclip` paragraph transcript.

Detailed evidence:
`2026-07-30-freep-wave71-pointer-paragraph.md`.

## Visual report refresh

Fresh WPF and Avalonia captures were generated for all ten Font and Paragraph
states and promoted into the canonical FreeW report through route-scoped
baseline refresh:

| Route | Previous changed-pixel average | Current average | Current mean channel delta |
| --- | ---: | ---: | ---: |
| `font` | 16.980% | 8.014% | 7.514 |
| `paragraph` | 16.123% | 8.345% | 9.807 |

All ten states remain classified as `genuine-visual-mismatch`. The canonical
report still contains 170 genuine visual mismatches, 13 passes, 96 Avalonia
extensions, and 4 state-not-applicable rows. These counts are retained
honestly; the refresh changes evidence, not acceptance thresholds.

The cross-app dashboard was regenerated and its schema/evidence aggregation
guard passed.

## Remaining

- Continue FreeW visual alignment for the 170 genuine mismatch rows.
- Add a deterministic authored Linux fixture and semantic readback before
  claiming physical grouped Chart/SmartArt transform evidence.
- Continue functional depth probes beyond generated route and command
  coverage; complete inventory coverage is not a 100% parity claim.
