# FreeW Native MERGEFIELD Authoring (2026-08-06)

## Scope

Mailings > Insert Merge Field now authors a native Word complex field in WPF and Avalonia:

- field code: `MERGEFIELD name \* MERGEFORMAT`
- names containing spaces are quoted
- cached result: Word's familiar `«name»` label
- insertion remains undoable through each host's existing complex-field command

The shared merge engine discovers both native MERGEFIELD runs and legacy literal `«name»` templates. Preview and Finish & Merge resolve native fields from the current recipient row; the generated record contains materialized plain text while the editable template retains its field.

## Exact Word Gate

FreeW authored `C:\fwm\merge-field.docx` with SHA-256 `D1838F9C86462AA72717D8425D74E1BF0D06C8F89E528D7F93144855A85A9F02`.

Word opened the package without repair and exposed exactly one field:

- Word field type: `59` (`wdFieldMergeField`)
- code: ` MERGEFIELD "First Name" \* MERGEFORMAT `
- result: `«First Name»`

Word saved `C:\fwm\word.docx` with SHA-256 `D8C1EE029D4D72898ED5F1FDF46ED24F825C91A85472631ECCCED962A7318EEB`. FreeW reopened that Word-saved package and preserved the exact instruction and result.

## Verification

- `MailMergeTests`: 120/120
- native MERGEFIELD DOCX round trip: 1/1
- Avalonia `MailingsTabTests`: 36/36
- WPF `ComplexFieldEditorTests` and recipient-change source contracts: 14/14

## Process Note

Treat the native field code as the authoring/storage owner and the guillemet label as cached display text. Keep legacy literal placeholders supported during discovery and substitution so existing FreeW templates remain functional while newly authored documents become Word-native. Restore the editable template before replacing recipient data or invalidating an active preview, and treat a resolved native field value as terminal so recipient text containing guillemets is not substituted a second time.
