# FreeW update fields on open

## Scope

FreeW already parsed, modeled, serialized, and package-tested Word's
`w:settings/w:updateFields`, but neither desktop host acted on it after opening a DOCX. Field
results therefore remained stale until the user manually invoked F9.

## Change

- WPF invokes its existing full-document field refresh after loading a normal opened document when
  `UpdateFieldsOnOpen` is true.
- WPF establishes the current filename before refresh and performs saved-state bookkeeping after
  refresh, so filename-dependent fields can resolve without dirtying the document.
- Avalonia invokes its existing field refresh after establishing open-path state and suppresses
  editor dirty notifications during that refresh.
- False/absent settings preserve cached field results.
- Autosave snapshot recovery remains unchanged and does not implicitly execute package instructions.

The existing refresh engines cover simple fields, recomputable complex fields, cross-references,
TOC, bibliography, table of figures, and table of authorities.

## Verification

- WPF `FileLifecycleTests`: 16/16
- Avalonia `AsyncFileLifecycleHeadlessTests`: 8/8
- True controls refresh stale AUTHOR text to `Ada Lovelace`.
- False controls preserve `stale author`.
- Both controls retain the opened path and remain clean.

Package XML/reopen behavior remains covered by `UpdateFieldsOnOpenRoundTripTests`.
