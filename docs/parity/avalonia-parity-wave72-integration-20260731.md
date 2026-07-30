# Avalonia parity Wave72 integration

Wave72 resumed the functional-first Avalonia parity program after the task-state block was cleared.
The goal remained active throughout; no date or token ceiling was used to stop implementation.

## FreeX

Avalonia now matches WPF double-click precedence inside PivotTables. A value-cell double-click
executes the shared Show Details command before inline editing, while ordinary cells retain inline
edit behavior. A one-shot guard prevents Avalonia's pointer and `DoubleTapped` routes from handling
the same gesture twice.

Managed verification passed 3/3. The dedicated physical Linux/X11 selector passed 1/1 with an exact
clipboard and saved-package transcript for `Detail!A1:C2`.

Detailed evidence:
`freex-wave72-pivottable-doubleclick-2026-07-31.md`.

## FreeW

Table Properties now uses the WPF action-row spacing, neutral default-button border, and checkbox
inset. The Avalonia visual adapter no longer invents populated or validation state after the shared
harness pass, so paired captures represent the same document state.

Focused Avalonia tests passed 24/24 and WPF authority tests passed 3/3. The real Linux Table
Properties workflow passed its physical X11 contract, traversed all four tabs, and applied
`IndentFromLeftPt = 12`.

Fresh paired capture retained one pass and six genuine visual mismatches with no semantic
differences. Average changed pixels improved from 7.3916% to 7.1952%; mean channel delta improved
from 5.5078 to 5.3590. The canonical report still contains 170 genuine visual mismatches, 13 passes,
96 Avalonia extensions, and 4 state-not-applicable rows.

Detailed evidence:
`freew-wave72-table-properties-20260731.md`.

## FreeP

A bounded WPF/Avalonia audit of rich text, objects, animation, review, and math found no reproducible
managed functional gap. The generated command inventory remains 559/559 shared. Avalonia passed
496/496, the focused WPF authority lane passed 155/155, and the paired math baselines passed 41/41
and 40/40. The current physical Linux family baseline passed 24/24, including the seeded
animation-pane workflow.

Detailed evidence:
`freep-wave72-functional-depth-audit-2026-07-31.md`.

## Remaining

- Continue functional depth work beyond complete generated command and route inventories.
- Continue FreeW visual alignment across the 170 genuine mismatch rows without weakening thresholds.
- Broaden physical Linux workflows for FreeP animation, review, rich text, and safe unavailable-OLE
  behavior.
- Keep Microsoft Office-authoritative visual baselines explicitly separate from local WPF/Avalonia
  comparisons until fresh Excel, Word, and PowerPoint artifacts exist.

## Integration verification

- Repository preflight passed end to end.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- The default lane ran 34,063 tests: 33,927 passed and 3 load-sensitive performance budgets failed
  while the assemblies ran concurrently.
- The Text-to-Columns timing test passed alone in 41 ms and the comment indexed-lookup test passed
  alone in 59 ms.
- The affected formula theory passed all 11 cases alone in 688 ms.
- The complete `FreeX.App.Presentation.Tests` assembly then passed with 4,252 passed, 1 skipped, and
  0 failed.
- The complete `FreeX.Core.Formula.Tests` assembly then passed with 4,725 passed, 7 skipped, and
  0 failed.
