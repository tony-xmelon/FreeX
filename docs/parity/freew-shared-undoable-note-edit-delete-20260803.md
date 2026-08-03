# FreeW shared undoable note editing and deletion (2026-08-03)

## Gap

Both FreeW hosts expose an editable footnote/endnote pane, but only Avalonia used undoable note
commands. WPF copied edited paragraphs directly into the note store and issued a no-op page-settings
command to force a redraw. WPF deletion also mutated the store and visible marker runs directly.
Avalonia's private delete command removed markers only from top-level paragraphs, leaving a marker in a
table cell orphaned after deleting its note.

## Change

- Promoted rich note replacement and note deletion to shared `FreeW.Core.Model` commands.
- Both WPF and Avalonia now use the same cloned-paragraph edit/undo/redo behavior.
- WPF Notes pane Apply is one real `Edit Footnote` / `Edit Endnote` undo entry; it no longer creates a
  synthetic page-settings entry.
- WPF note deletion is undoable and restores the note plus exact marker-run sequence.
- Deletion traverses ordinary body paragraphs and table-cell paragraphs.
- WPF now clones note content into the sub-editor, matching Avalonia and isolating unapplied edits.

## Verification

- `NoteCommandTests`: 3/3 passed.
  - rich multi-paragraph replacement and undo/redo
  - blank note replacement
  - table-cell marker deletion with exact undo/redo restoration
- `NoteEditCommandRoundTripTests`: 1/1 passed.
  - asserts `word/footnotes.xml` and `word/endnotes.xml`
  - reopens the DOCX and verifies formatted edited content plus an untouched note
- WPF `EditableNotesPaneTests`: 8/8 passed.
- Avalonia `EditingReferenceParityTests`: 7/7 passed.
- Complete FreeW Release build: 50 projects, 0 warnings, 0 errors.
- Completed FreeW model/IO/presentation/localization/ribbon suites: 4,293/4,293 passed.

The all-up WPF host test project did not finish or write a TRX within its bounded ten-minute run;
its owned process tree was stopped. The affected focused WPF suite completed independently at 8/8.

This is a functional/package parity slice; it does not require a Word COM visual baseline.

## Follow-up: caret-positioned note insertion

The two hosts also had different insertion semantics: Avalonia grouped note creation and marker creation
for undo, but appended the marker at paragraph end; WPF inserted at the caret but mutated the note store
outside its command bus. `InsertNoteCommand` now owns note creation plus marker insertion at a measured
plain-text offset. It splits a formatted run without losing formatting and restores the original run
instances on undo.

- WPF top-level/list paragraphs use the shared command; undo/redo removes and restores the note plus
  marker as one edit.
- Avalonia uses the same command and now inserts at the actual caret/selection endpoint rather than at
  paragraph end.
- The existing WPF table-cell FlowDocument path remains as the fallback until shared table-cell paragraph
  addressing is introduced; its prior behavior is preserved.
- Model insertion tests: 5/5 passed.
- DOCX package/reopen tests: 2/2 passed, including `w:footnoteReference` and `word/footnotes.xml`.
- WPF editable Notes tests: 9/9 passed.
- Avalonia footnote insertion tests: 3/3 passed.

## Follow-up: table-cell note insertion

- WPF ordinary table-cell paragraphs now resolve the caret to a stable model table/row/cell/paragraph
  address and execute the shared undoable insertion path instead of mutating the FlowDocument first.
- The shared table-cell command splits the owning formatted run at the exact text offset, creates the note,
  and restores both the original runs and note store as one undo/redo operation.
- DOCX verification asserts the reference remains inside `w:tc`, the note body is written to
  `word/footnotes.xml`, and reopening preserves the marker's exact run position.
- Wrapped/rotated table-cell visuals that do not expose a direct editable WPF paragraph retain the existing
  fallback path; this slice does not infer coordinates through a disconnected nested FlowDocument.
- Focused verification: model note commands 6/6, DOCX package/reopen 3/3, WPF editable Notes 10/10.
