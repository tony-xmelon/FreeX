# FreeW plain-text content-control multiLine package parity

## Scope

FreeW now preserves the optional WordprocessingML `w:sdtPr/w:text/@w:multiLine`
state for inline plain-text content controls. The model keeps all three package
states: absent, explicit false, and explicit true. Rich-text and block content
controls remain on their existing paths.

## Canonical package behavior

- Reader accepts the WordprocessingML `ST_OnOff` false tokens `0` and `false`
  and true tokens `1` and `true` through the repository's shared on/off parser.
- An absent attribute remains `null` in the model and is omitted on save.
- A present false value is written canonically as `w:multiLine="0"`.
- A present true value is written canonically as `w:multiLine="1"`.
- Reopen and second-save preserve the canonical `w:sdtPr` XML exactly.

## Verification

Focused tests cover the factory model, source XML tokens, read state, canonical
saved XML, reopened state, second-save stability, the absent case, an untouched
rich-text control, and Microsoft 365 Open XML schema validation. The relevant
full FreeW Core Model and Core IO suites are also run before integration.

- Focused model: 3 passed, 0 failed, 0 skipped.
- Focused package round-trip/schema: 1 passed, 0 failed, 0 skipped.
- Full `FreeW.Core.Model.Tests`: 1,575 passed, 0 failed, 0 skipped.
- Full `FreeW.Core.IO.Tests`: 1,216 passed, 0 failed, 0 skipped.
