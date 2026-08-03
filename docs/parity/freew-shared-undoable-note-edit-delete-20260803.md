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
