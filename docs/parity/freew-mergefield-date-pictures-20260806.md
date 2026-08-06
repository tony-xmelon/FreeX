# FreeW MERGEFIELD Date Pictures (2026-08-06)

## Scope

FreeW preview and Finish & Merge now parse Word's common MERGEFIELD `\@` date/time token language:

- `MMMM d, yyyy`
- `MM/dd/yyyy`
- `yyyy-MM-dd`
- `h:mm AM/PM`
- single-token pictures such as `d`, `m`, and `h`
- localized patterns such as `M/d/yyyy`, `dd.MM.yyyy`, and `dddd, d. MMMM yyyy`

The result picture is applied before conditional `\b`/`\f` text and general text formatting. Parsing and names use the field run's language tag, falling back to the process culture; invariant parsing is a secondary path for unambiguous interchange values. Nondates and unsupported tokens preserve the recipient source value.

## Exact Word Gate

A short-path C# COM probe merged the Word-document datasource value `8/6/2026 2:05 PM`. Word produced:

- `Long=August 6, 2026`
- `Short=08/06/2026`
- `Iso=2026-08-06`
- `Time=2:05 PM`
- `Natural=8/6/2026`
- `Day=Thursday`
- `LowerTime=2:05 PM` (Word retains the culture's uppercase designator for lowercase `am/pm`)
- `Dot=06.08.2026`
- `DayToken=6`
- `MinuteToken=5`
- `HourToken=2`
- `German=Donnerstag, 6. August 2026` for an explicit German field language

Word package hashes:

- data source: `40851083F9B27372A2D0B953D12489B198F0142A6C1C2E5B82747D650E654FD0`
- merge template: `215E01BA8E2A185AAE689F5210161E008D5ACF4742816A9837E0A83D2C4CAAC9`
- merged result: `8D667836630E63374F66D48887F154D8E52D293210BFD8126157914D1C798446`

FreeW reopened all 12 exact Word field instructions, including the German language tag, and reproduced every merged line.

## Verification

- focused `MailMergeTests`: 147/147
- Word-saved package reopen and result cross-check: 12/12

## Process Note

Treat Word's date-picture language as a separately calibrated result owner. Translate validated Word tokens into escaped .NET custom-format tokens, use the field language for culture ownership, and preserve source values for unknown letters rather than claiming compatibility from syntactic similarity.
