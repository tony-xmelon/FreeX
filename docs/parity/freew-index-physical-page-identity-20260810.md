# FreeW index physical-page identity

## Gap

Generated INDEX entries deduplicated XE occurrences by displayed page label. When a later section
restarted numbering, two different physical pages both labelled `1` collapsed to one `1`. The same
string-only comparison also collapsed an explicit bookmark range spanning two restarted pages from
`1-1` to `1`.

## Change

The shared page-number planner now exposes an index-specific resolver carrying both the zero-based
physical page identity and Word-visible label. `DocumentIndex` deduplicates ordinary occurrences by
that physical identity while retaining their authored order and merging bold/italic switches only for
marks on the same page. WPF and Avalonia use the richer resolver for Insert Index and Update Index;
other generated-reference consumers retain the existing string resolver.

Ordinary consecutive XE pages remain separate (`1, 2, 3`). Only an explicit XE `\\r` bookmark creates
a range. A range whose distinct physical endpoints both display `1` is preserved as `1-1`.

## Verification

- DocumentIndex model tests: 27/27.
- Page-number/address planner tests: 10/10.
- WPF index editor tests: 7/7.
- Avalonia References tests: 85/85.

The focused controls cover same-page formatting union, repeated labels across distinct physical pages,
section restart behavior in both hosts, equal-label bookmark ranges, and the existing Roman/decimal
page-list behavior.
