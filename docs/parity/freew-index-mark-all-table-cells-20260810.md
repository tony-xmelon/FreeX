# FreeW index Mark All table-cell parity

## Gap

Word's Mark All operation inserts XE fields after every matching text instance throughout the
document. FreeW searched only top-level paragraphs, so matching text inside table cells was omitted.
Its insertion target also carried only a top-level block index and could not address a nested cell
paragraph for undoable editing.

## Change

`IndexMarkTarget` now carries an optional recursive table-paragraph address. The shared body-paragraph
walk emits that path for direct and nested table-cell matches. A shared undoable cell-paragraph run
command resolves the same path in WPF and Avalonia, keeping the entire Mark All operation in one undo
group across body and arbitrarily nested preserved table text.

WPF's FlowDocument table cannot directly represent a nested table. Its existing table-cell retention
tag now also carries a deep-cloned nested-table payload through `CommitToModel`, allowing the shared
command to edit the authoritative model without dropping unrendered package content or aliasing the
discarded source graph.

The common run insertion planner now retains tracked-move identity when it splits ordinary text and
keeps ruby annotations intact by placing a hidden XE anchor after the semantic ruby run.

## Verification

- Model tests cover ordered body/direct-cell targets, two-level nested INDEX generation and Mark All,
  and a bookmark range beginning inside a nested table.
- WPF and Avalonia tests cover nested-cell insertion plus one-step undo and redo across body and table
  paragraphs; WPF also recommits the view before undo to prove the retained nested payload survives a
  subsequent model rebuild and remains isolated from the discarded source graph.
- Planner tests cover tracked-move metadata and ruby-safe hidden-field insertion.
- Existing top-level matching, whole-term filtering, duplicate-mark filtering, and INDEX generation
  controls remain in the focused suites.
