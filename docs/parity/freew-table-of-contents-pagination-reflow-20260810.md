# FreeW Table of Contents Pagination Reflow

## Word contract

Table of Contents page references describe the final laid-out document. Inserting or replacing the
generated TOC can move its source headings onto later pages, so page references must be recomputed after
the generated region reaches its final size. A second refresh must not change the result.

## Previous gap

Both WPF and Avalonia built TOC entries before changing the generated region. On the bounded eight-heading
WPF fixture, the one-shot insert emitted pages `1,1,1,1,1,2,2,2`, while the final paginated document placed
the headings on pages `2/3`. Refresh also rebuilt against the document with the old TOC removed, so it could
repeat the same stale result instead of converging.

## Implementation

- Both hosts now apply a provisional TOC, relayout, rebuild page references, and replace the generated
  region until its paragraph style/text signature stops changing.
- Stabilization is bounded to eight replacement passes plus a final verification pass.
- All provisional replacements remain inside one undo group. Failure rolls the open group back; commit
  occurs after the rollback-protected region so a post-commit view notification cannot mask an exception.
- WPF insertion is now one undoable edit rather than one history entry per generated paragraph.
- Insert stabilizes only its newly inserted contiguous region, preserving any existing generated or native
  TOC. Refresh retains its existing replace-all-TOC behavior. Source headings are never part of either
  replacement set.

## Verification

- WPF insertion and replacement fixtures stabilize after the first operation; a second refresh is
  text-identical, final references are not earlier than paginator-owned heading pages, and undo removes the
  complete generated region in one step.
- Avalonia insertion and replacement fixtures stabilize after the first operation and no longer retain
  page-1 references after the generated region pushes every source heading to a later page.
- `FreeW.App.Host.Tests`: `NumericCitationEditorTests` passed 9/9.
- `FreeW.App.Avalonia.Tests`: focused TOC/update-fields lane passed 33/33.
- `FreeW.Core.Model.Tests`: `TableOfContentsTests|DocumentCommandBusTests` passed 53/53.
- `tools/Test-RepositoryPreflight.ps1` passed.
- `dotnet build FreeW.slnx --configuration Release` succeeded with 0 warnings and 0 errors.
