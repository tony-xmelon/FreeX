# FreeW Bookmark Range Retention (2026-08-01)

## Gap

FreeW retained only bookmark names. On save it emitted every bookmark start before all paragraph runs
and every end after them, converting partial, zero-width, overlapping, and cross-paragraph Word
bookmarks into whole-paragraph ranges. Word-only `_GoBack` and bookmark table-column metadata were lost.

## Slice

- `Paragraph.BookmarkBoundaries` retains ordered start/end markers at run indices, including paragraph-end
  positions.
- Start metadata preserves `w:name`, `w:colFirst`, `w:colLast`, and `w:displacedByCustomXml`; end metadata
  preserves `w:displacedByCustomXml`.
- Writer pairing is document/story scoped and supports cross-paragraph and overlapping ranges.
- Bookmark markers split hyperlink and revision spans instead of being moved outside them. Markers authored
  inside a run-level content control retain that owner and stay inside one `w:sdtContent` wrapper.
- `_GoBack` stays hidden from the public navigation-name list but remains in package XML.
- Removing an imported public bookmark name suppresses its retained boundaries; newly authored names without
  boundary metadata keep the existing whole-paragraph behavior.
- WPF renders boundaries as zero-size inline anchors. Their positions therefore move with nearby editor text
  before `CommitToModel`, rather than being restored from a stale paragraph snapshot.
- Exact model clone paths, document merge, mail merge, table-header projection, and Avalonia paragraph clones
  retain the metadata. Bookmark-name remapping and `Paragraph.BookmarkName` renames update matching starts.
- Compare/combine paragraphs whose runs are regenerated use explicit visible-text/source-run mapping rather
  than copying raw indices; see `freew-bookmark-run-remapping-20260801.md`.

## Verification

- `MultiBookmarkRoundTripTests`: 14/14.
- Full `FreeW.Core.IO.Tests`: 1178/1178.
- Full `FreeW.Core.Model.Tests`: 1546/1546.
- WPF `DocumentViewRoundTripTests`: 50/50, including a live insertion before a partial-range anchor.
- Avalonia Release build: 0 warnings, 0 errors.

The package tests assert direct-child XML order, regenerated start/end ID pairing, reopened boundary indices,
column/displacement attributes, zero-width ordering, cross-paragraph overlap, `_GoBack`, removal, rename,
hyperlink splitting, and single-wrapper content-control ownership.

The full WPF host test assembly was also attempted. Existing unrelated source-contract and SmartArt/table
oracle failures remain on current main; the complete affected `DocumentViewRoundTripTests` owner class passed.

## Residual

Boundary positions are run-relative in the core model. WPF text edits use live anchors, and comment/revision/
compare/combine regeneration now remaps them. Insertion exactly on a boundary still needs a Word-compatible
caret-affinity policy; boundaries nested inside expanded field payloads and exact ordering against comment
markers also need explicit package ownership. The writer clamps out-of-range indices rather than emitting
malformed XML.
