# FreeW custom XML date-binding refresh

## Scope

FreeW already retained a date picker's `w:dateFormat`, `w:date/@w:fullDate`, calendar,
locale, mapped-data storage form, and `w:dataBinding`. The custom XML refresh pass did
not consume date controls, so opening a data-bound document left the serialized display
and semantic date stale even when the custom XML item was authoritative.

The resolver now accepts an exact bounded path:

- content-control kind is `DatePicker`;
- calendar is absent or `gregorian`;
- `w:storeMappedDataAs` is explicitly `date` or `dateTime`;
- `date` is an XML `yyyy-MM-dd` value and `dateTime` is a valid XML-schema date-time;
- the authored locale and date format are valid for .NET's corresponding culture.

A successful refresh formats the visible text from the authored format/locale and
updates `w:date/@w:fullDate`. Every run in the SDT range receives the same updated
immutable control instance; later run text is blanked using the existing mapped-control
contract. Invalid values, unsupported calendars, text storage, and invalid locale or
format tokens leave both display and date metadata unchanged.

## Verification

Focused current-main Release gates:

- custom XML binding suite: 20/20;
- custom XML binding plus date-picker metadata suite: 22/22;
- `FreeW.Core.IO` and `FreeW.Core.IO.Tests`: 0 warnings, 0 errors.

The tests cover `date` and `dateTime`, multi-run ownership, invalid/unsupported storage,
custom XML item/property retention, exact date XML through reopen and second save, and
Microsoft 365 schema validation. Existing plain text, list, combo, checkbox, block-level,
namespace, missing-XPath, and custom-value controls remain in the same focused gate.

## Remaining work

Text-storage and omitted-storage mapping are covered by the follow-up
`freew-custom-xml-text-date-binding-refresh-20260805.md`. Non-Gregorian calendars
still require separate source semantics and remain preserved rather than guessed.
