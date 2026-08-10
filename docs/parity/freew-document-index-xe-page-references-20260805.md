# FreeW document Index XE and page-reference parity

## Gap

FreeW stored marked index terms only in a document-level string list. The mark had no body location, did
not serialize as Word's hidden `XE` field, disappeared as semantic data after save/reopen, and generated
Index entries contained no page references. Repeated terms on different pages were collapsed before
their occurrence pages could be known.

## Change

WPF and Avalonia now insert an undoable, textless `XE "term"` complex field at the caret. Duplicate
marks are suppressed only within the same paragraph; the same term may be marked on multiple pages.
The existing generic complex-field reader preserves imported XE marks, while the writer emits Word's
canonical instruction-only `begin / instrText / end` sequence without a result separator.

`DocumentIndex.Build` scans durable body XE fields, groups terms case-insensitively, collects distinct
occurrence page labels, and emits entries such as `Alpha, IV, V`. Host physical placement and the shared
page-label planner provide live logical pages. Authored breaks provide the headless decimal fallback.
Legacy `TextDocument.IndexEntries` remain supported only when no durable body mark exists for that term.

## Verification

- Index, TOC, Table of Figures, and legacy index-command model contracts: 43/43.
- Complete generic complex-field DOCX round-trip controls: 15/15.
- Page-number and header/footer planner controls: 22/22.
- WPF index/generated-reference/cross-reference controls: 14/14.
- Avalonia complete References-tab controls: 64/64.
- Consuming Release test builds: 0 warnings, 0 errors.

The package contract asserts exact XE field ordering (`begin`, `end`), exact instruction text, reopened
field identity, and generated page `1`. Both real-host fixtures number pages `IV, V`, mark `Alpha` on
both pages and `Beta` on the second, then assert refresh produces `Alpha, IV, V` and `Beta, V`. WPF also
proves mark undo/redo and same-paragraph duplicate suppression.

## Evidence boundary

This closes basic single-level XE occurrence and page-list behavior. Word's advanced Index switches and
dialogs, including subentries, cross-references, bookmarks/ranges, and page-number formatting switches,
remain separate functional depth. Ordinary consecutive XE marks intentionally remain separate page
references; Word creates a page range only from an explicit XE `\\r` bookmark. Index typography and
column layout remain visual-comparison work.
