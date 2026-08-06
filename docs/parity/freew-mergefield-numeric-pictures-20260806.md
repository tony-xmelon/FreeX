# FreeW MERGEFIELD Numeric Pictures (2026-08-06)

## Scope

FreeW preview and Finish & Merge now apply the exact Word-calibrated MERGEFIELD numeric pictures `\# "$#,##0.00"` for nonnegative values and `\# "0.0%"` before composing conditional text and general text formats. Nonnumeric values, negative currency values, and unmodeled pictures retain their source text; Word's wider picture language is not delegated blindly to .NET formatting.

## Exact Word Gate

A short-path C# COM probe merged two Word fields:

- `1234.5` with `\# "$#,##0.00"` produced `$1,234.50`.
- `12.5` with the same picture produced `$  12.50`; Word pads the two unfilled `#` positions with spaces.
- `0.125` with `\# "0.0%"` produced `0.1%`.
- nonnumeric `abc` with `\# "0.00"` remained `abc`.

The percentage result is important: Word treats `%` in this field picture as a literal suffix and does not multiply the value by 100. FreeW escapes the marker before using its existing deterministic numeric formatter.

Word package hashes:

- data source: `0FAFBBD53C40D02A85EFBFD65A316070FACA8575F0BDC94EE97071A06E762B49`
- merge template: `93B62EB1189629D1733041650BAEE32856A5C90B8C6A783BF811B13A15CA96B6`
- merged result: `59FD24809C646BF35FFE901B55E19E5322CC309715AB4E64434A8111DABAA5D0`

FreeW reopened all four exact Word field instructions and reproduced all result lines.

## Verification

- focused `MailMergeTests`: 134/134
- Word-saved package reopen and result cross-check: 4/4

## Process Note

Do not assume .NET and Word numeric pictures have identical operator semantics. Reusing the established formatter is appropriate only after translating the measured Word behavior; the percent marker required a literal escape even though grouping, decimal places, and currency literals aligned directly.
