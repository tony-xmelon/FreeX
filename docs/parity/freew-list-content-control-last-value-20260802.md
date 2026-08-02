# FreeW list content-control `w:lastValue` parity (2026-08-02)

## Scope

WordprocessingML owns the optional `w:lastValue` attribute on the list-kind element itself:

- `w:sdtPr/w:dropDownList/@w:lastValue`
- `w:sdtPr/w:comboBox/@w:lastValue`

The installed Open XML SDK exposes the same ownership through
`SdtContentDropDownList.LastValue` and `SdtContentComboBox.LastValue`.

FreeW now carries that attribute as nullable `ContentControl.ListLastValue`. `null` means the source
attribute was absent; a non-null value, including the empty string, means the attribute was present.
It is independent of the displayed run text and of every `w:listItem/@w:value` choice.

## Read/write contract

- The DOCX reader recovers `w:lastValue` from both inline list control kinds without normalizing an
  explicitly empty value to absence.
- The writer emits `w:lastValue` only when `ListLastValue` is non-null and places it on the correct
  `w:dropDownList` or `w:comboBox` owner.
- The run factories accept an optional `lastValue` while preserving their prior absent default.
- Focused tests cover source XML, the first read model, exact canonical saved XML, the reopened model,
  byte-stable list XML after a second save, and Microsoft 365 Open XML schema validation.

## Verification

- `ListContentControlLastValueModelTests`: 2/2 passed.
- `ListContentControlLastValueRoundTripTests`: 4/4 passed with Microsoft 365 schema validation.
- Full `FreeW.Core.Model.Tests`: 1,572/1,572 passed.
- Full `FreeW.Core.IO.Tests`: 1,215/1,215 passed.
