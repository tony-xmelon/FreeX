# FreeW index broken-bookmark result

## Gap

An XE entry carrying `\\r "BookmarkName"` asks Word to use that bookmark's first and last pages.
When the bookmark was missing or its case did not match, FreeW silently substituted the XE field's own
page. Word instead exposes `Error! Bookmark not defined.` in the generated index result.

## Change

`DocumentIndex` now treats a non-empty XE range switch as authoritative. A valid bookmark still emits
its one-page or first-to-last-page result. An unresolved bookmark emits the Word-visible error text and
retains the XE page-number bold/italic formatting. It no longer falls through to the ordinary mark page.

Bookmark matching remains case-sensitive, matching Word's index behavior.

## Verification

- DocumentIndex model tests cover a mis-cased bookmark plus formatting retention.
- WPF and Avalonia editor tests refresh an index with a missing range bookmark and assert the error.
- Valid bookmark ranges, physical-page identity, and ordinary page-list controls remain in the focused
  index suites.
