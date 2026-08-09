# FreeW native per-record merge prompts

Date: 2026-08-09

## Scope

FreeW now evaluates native Word `FILLIN` and `ASK` fields without the `\o` switch at the point where
each selected mail-merge record reaches the field. Fields with `\o` retain the existing one-time prompt
behavior.

Microsoft's Word object model exposes this distinction through the Fill-in field `EachRecord` argument:
`false` prompts once and `true` prompts for every merged record.

Reference: https://learn.microsoft.com/en-us/office/vba/api/word.mailmergefields.addfillin

## Behavior

- Prompt order follows actual record and field traversal.
- A preceding Skip Record If rule suppresses later prompts for that skipped record.
- FILLIN writes the formatted answer into the result; ASK stores the formatted answer for following REF
  fields and emits no visible text itself.
- Empty answers are retained as intentional blanks. Cancel discards the complete partial merge and causes
  no new-document or printer side effect.
- WPF uses its synchronous owner-modal dialog path. Avalonia builds the merge on a worker and dispatches
  each dialog to the UI thread, avoiding a UI-thread wait cycle.
- Both Avalonia finish-merge command identifiers route through the dialog-aware shell path.

## Verification

- Shared model: distinct answers, record/field order, cancellation, and skip-before-prompt.
- DOCX round trip: native field instructions survive save/reopen and resolve distinctly per record.
- WPF: printer merge collects per-record answers and cancellation preserves the preview/template.
- Avalonia: build output is all-or-nothing, while new-document application and printing remain UI-owned.
