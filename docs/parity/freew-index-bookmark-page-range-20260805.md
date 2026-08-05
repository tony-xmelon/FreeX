# FreeW index bookmark page-range parity

## Scope

Word uses the XE `\r` switch to associate one index entry with a named bookmark. The generated index
shows the first and last pages enclosed by that bookmark instead of the page containing the XE field.

FreeW now:

- preserves `IndexMark.BookmarkName` and exact XE `\r "name"` package semantics;
- resolves bookmark start/end boundaries across body paragraphs;
- uses the same logical page-label callback as ordinary index entries, including roman-numbered sections;
- emits a single page when both boundaries resolve to the same page, otherwise an en-dash range;
- applies XE bold/italic formatting to the complete generated range label;
- exposes Page range plus the document bookmark list in both WPF and Avalonia Mark Index Entry dialogs;
- keeps page-number formatting available for Current page and Page range, but not Cross-reference; and
- disables and command-guards Mark All for Page range, matching Word's single-range-entry behavior.

An unresolved imported bookmark name remains preserved in the XE field and falls back to the XE field's
own page during FreeW index generation.

## Word control

A fresh Word 16 COM `Indexes.MarkEntry` control used a short `C:\fwir1` path, bookmark `TopicRange`, and
bold plus italic page formatting. Word returned this exact field code before its subsequent SaveAs2 call
stalled:

```text
XE "Alpha" \r "TopicRange" \b \i
```

FreeW canonicalizes switches in that same order. The stalled save produced no admissible package and was
not used as acceptance evidence. Its proven-owned Word process and scratch directory were removed
immediately after recovering the field code.

## Verification

- `DocumentIndexTests`: 20/20.
- `ComplexFieldRoundTripTests`: 18/18.
- `MarkIndexEntryDialogPlannerTests`: 11/11.
- WPF Mark Index dialog contracts: 8/8.
- Avalonia Mark Index dialog contracts: 5/5.

The model test spans bookmark boundaries from logical page `iv` through `vi` and verifies generated text
`Alpha, iv\u2013vi` plus page-label formatting. The package test asserts canonical XE serialization and the
reopened structured mark.

## Remaining index scope

Alternate indexes (`\f`) and configurable Insert Index layout remain separate semantic slices.
