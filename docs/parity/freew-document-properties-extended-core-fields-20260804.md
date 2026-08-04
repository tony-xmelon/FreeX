# FreeW extended core document properties

Date: 2026-08-04

## Gap

FreeW already read, wrote, and retained twelve modeled OPC core properties, but the WPF and
Avalonia Document Properties dialogs exposed only Title, Author, Subject, Keywords, and Comments.
Category, Content Status, Language, and Version could survive a Word round trip but could not be
edited in FreeW. Last Saved By, Created, and Modified were not visible in the dialog.

## Slice

- Both hosts now expose Category, Status, Language, and Version as editable fields.
- Both hosts display Last Saved By, Created, and Modified as read-only provenance values.
- The shared dialog payload normalizes and applies all nine editable fields as one undoable command.
- Undo and redo restore the complete editable set while leaving the three read-only provenance
  values unchanged.
- The existing DOCX core-property reader/writer remains authoritative and unchanged.

## Evidence

- WPF runtime coverage verifies the four new editable controls and three read-only values.
- Avalonia runtime coverage edits all nine values, verifies all three read-only values, and proves
  that constructing and accepting the dialog does not mutate the source model directly.
- Shared command coverage proves trimming/null normalization and one-step apply/undo/redo behavior.
- Existing package coverage proves all twelve modeled properties survive DOCX save/reopen, and that
  unmodeled Word properties remain preserved across edited and second saves.

## Verification

- Core-property package tests: 3/3.
- Shared document-properties command: 1/1.
- WPF dialog, undo, and shared-boundary contracts: 9/9.
- Avalonia dialog, focus, and undo contracts: 3/3.
