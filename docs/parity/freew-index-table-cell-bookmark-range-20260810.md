# FreeW index table-cell entries and bookmark ranges

## Gap

FreeW inspected XE fields and XE `\\r` bookmark boundaries only on top-level body paragraphs. It
therefore omitted index entries authored inside table cells. For a range beginning or ending inside a
cell, it fell back to the legacy bookmark location and collapsed a valid multi-page range to the
containing table's first page.

## Change

Index collection and range resolution now share one body-paragraph walk that includes table cells in
document order. A nested paragraph retains the containing top-level table block index, matching the
existing bookmark and complex-field page-address convention. Boundary pairing remains ordinal and
unchanged.

## Verification

`DocumentIndexTests` covers a table-cell XE field and a range whose start and end are in separate
table blocks. It verifies the entry's page label and the range's first and last logical labels. Existing
valid, restarted-numbering, and broken-bookmark controls remain in the same focused suite.
