# FreeW WPF Mail Merge Label Insertion Ownership

## Gap

The WPF Labels command populated `Model.Blocks[^1]` after inserting a table at the caret. When the
caret was in the middle of a document, the new label grid was not the final block, so population could
target an existing trailing table or do nothing. Recipient rendering also began only after the grid had
mutated the template document.

## Resolution

- `DocumentView.InsertTable` returns the exact inserted block index while preserving all existing calls.
- Labels commits and renders recipient cell paragraphs before mutating the document.
- The returned insertion index owns every cell write, independent of trailing tables or paragraphs.
- Rich run formatting, skipped-recipient cadence, page geometry, and blank excess cells are preserved.

## Verification

- Focused WPF host tests cover a mid-document insertion with an existing trailing table and paragraph,
  ordered rich recipient content, exact page setup, and a skipped recipient that does not consume a cell.
