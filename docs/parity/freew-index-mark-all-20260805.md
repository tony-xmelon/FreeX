# FreeW index Mark All parity

## Scope

Word's Mark Index Entry dialog can mark the selected source text everywhere it occurs. FreeW now exposes
the same Mark All command in both WPF and Avalonia and routes both hosts through one model-owned target
planner.

The planner:

- matches every whole-term occurrence case-insensitively, including repeated occurrences in one paragraph;
- excludes partial words such as `alphabet` when the selected source is `Alpha`;
- skips generated index rows;
- avoids duplicating an equivalent XE mark already attached at the same text offset; and
- preserves the edited main entry, subentry, cross-reference, bold, and italic payload for every new mark.

Each host applies all target insertions through one composite command. Undo removes the complete Mark All
operation and redo restores every hidden XE run with its structured metadata.

## Word authority

Microsoft's Word object model defines `Indexes.MarkAllEntries` as inserting an XE field after all instances
of the text in the selected range. The desktop dialog exposes the same operation as **Mark All**.

A bounded Word COM call against a short-path scratch document stalled before returning any inspectable
package or field count. That process and scratch directory were removed, and the attempt was not used as
acceptance evidence. The implemented occurrence contract follows the documented Word API, while package
fidelity remains covered by the existing exact XE round-trip tests.

## Verification

- `DocumentIndexTests`: 18/18.
- `ComplexFieldRoundTripTests`: 17/17.
- `MarkIndexEntryDialogPlannerTests`: 8/8.
- WPF Mark Index dialog and undo contracts: 9/9.
- Avalonia References plus adjacent editing contracts: 14/14 focused.
- Repeated same-paragraph occurrences: 1/1 in WPF and 1/1 in Avalonia.

## Remaining index scope

Bookmark page ranges (`\r`), alternate indexes (`\f`), and configurable Insert Index layout remain separate
semantic slices.
