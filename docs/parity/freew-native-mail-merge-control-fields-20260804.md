# FreeW native mail-merge control fields

Date: 2026-08-04

## Result

Mailings > Rules now inserts Word-compatible complex fields for Next Record, Merge Record #, and Merge Sequence # in both WPF and Avalonia. The serialized instructions are `NEXT`, `MERGEREC`, and `MERGESEQ`; their cached results retain FreeW's familiar guillemet labels until a merge evaluates them.

Rule-aware merging updates the cached result without flattening the field. `NEXT` emits no text and requests the next source record, `MERGEREC` emits the current record index, and `MERGESEQ` emits the current non-skipped sequence number. The legacy guillemet parser remains available for existing FreeW documents.

Avalonia also now permits a complex field to be inserted adjacent to an existing complex field. The narrower field-insertion gate continues to reject paragraphs containing drawings, controls, notes, equations, or simple fields, while ordinary character editing retains its existing stricter protection against flattening field runs.

## Package evidence

The package contract asserts exact `w:instrText` values of ` NEXT `, ` MERGEREC `, and ` MERGESEQ `. Reopening the generated DOCX preserves all three native instructions and their cached display labels.

## Verification

- Core Model focused behavior and mapping: 4/4.
- Core Model full suite: 1657/1657.
- Core IO package round-trip focused test: 1/1.
- Core IO full suite: 1445/1445.
- WPF ribbon command path: 1/1 compile and 1/1 no-build.
- Avalonia ribbon command path: 1/1 compile and 1/1 no-build.

## Process rule

Word-visible labels are not field semantics. For functional parity, assert the native instruction in serialized XML, the reopened structured model, the editor insertion path in both hosts, and the evaluated merge result. Preserve the legacy parser only as a compatibility path; new insertions should use Word's native field representation.
