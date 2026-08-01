# FreeW Bookmark Run Remapping (2026-08-01)

## Gap

The bookmark-range package slice stored exact run-relative boundaries, but model operations that split or
regenerated runs could leave those indices attached to the wrong text. The highest-risk paths were comment
anchoring, revision range marking, document comparison, and two-reviewer document combine.

## Slice

- `BookmarkBoundaryMapper` captures each boundary as a text offset plus its ordinal among adjacent zero-width
  runs, then restores a real run boundary after an operation rebuilds the paragraph.
- Comment insertion remaps boundaries after splitting runs and restores the exact original metadata on undo.
  Comment deletion remaps around removed reference runs and restores exact boundaries on undo.
- Revision range marking and tracked deletion remap retained ranges after their run reconstruction.
- Compare maps revised-document boundaries through visible output text; original-only deleted runs do not
  advance the revised bookmark offset.
- Combine records every reviewer-B source run boundary against the merged output index, so interleaved
  reviewer-A deletions and reviewer-B insertions cannot leave stale indices.
- Mapping splits a generated text run when a retained boundary lands inside it, preserving an exact package
  boundary instead of rounding to the containing token.

## Verification

- Focused remapping contracts: 4/4.
- Full `FreeW.Core.Model.Tests`: 1550/1550.

The focused contracts force a split before a bookmark and assert index movement from `1/2` to `3/4`, assert
compare keeps a bookmark exactly around surviving text after a word replacement, and assert combine maps a
reviewer bookmark around the intended merged run.

## Residual

Insertion exactly on a bookmark boundary needs an explicit Word-compatible inside/outside caret-affinity
policy. Exact marker ordering inside expanded complex/simple field payloads and against comment-range XML is
also a separate package-owner problem; this slice does not infer those semantics from text offsets.
