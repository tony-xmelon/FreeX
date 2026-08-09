# Native Date-Time Field Updates

## Scope

FreeW now applies authored Word date-time picture switches (`\@`) when complex
`DATE` and `TIME` fields are displayed, inserted, rendered in headers or footers,
or refreshed with F9. The WPF and Avalonia hosts consume one shared formatter,
including the run language for localized day and month names.

The same model-side update pass now recomputes three package-backed fields:

- `CREATEDATE` from the OPC core `created` property
- `SAVEDATE` from the OPC core `modified` property
- `LASTSAVEDBY` from the OPC core `lastModifiedBy` property

`CREATEDATE` and `SAVEDATE` honor the same `\@` picture implementation. Without
an explicit picture they use the field run's culture and its regional general
date/time format. Missing metadata keeps the authored cached result, and locked
imported simple fields remain untouched.

## Source Ownership

The formatter was extracted from the already calibrated mail-merge field path,
so ordinary fields and merge fields no longer maintain separate Word-picture
parsers. Supported pictures cover Word day, month, year, hour, minute, second,
AM/PM, punctuation, and single-quoted literal text tokens. Malformed or unknown
pictures do not replace visible cached content.

Microsoft's field contracts identify `\@` as the date-time result switch and
define the metadata sources used by the three package-backed fields:

- [Format field results](https://support.microsoft.com/en-us/word/format-field-results)
- [CreateDate field](https://support.microsoft.com/en-us/word/field-codes-createdate-field)
- [SaveDate field](https://support.microsoft.com/en-us/word/field-codes-savedate-field)
- [LastSavedBy field](https://support.microsoft.com/en-us/word/field-codes-lastsavedby-field)
- [Update fields](https://support.microsoft.com/en-us/word/update-fields)

## Verification

- `ComplexFieldEngineTests|WordFieldDateTimeFormatterTests`: 75/75
- Existing mail-merge date-picture regressions: 14/14
- `ComplexFieldUpdateRoundTripTests`: 3/3
- `ComplexFieldDisplayPlannerTests`: 19/19
- WPF `ComplexFieldEditorTests`: 14/14
- Avalonia `FieldDisplayParityTests`: 6/6

The package test saves and reopens created/modified/last-save metadata and the
corresponding fields before recomputing their results. Host tests cover both
live current-time fields and fixed package metadata in one F9 pass.
