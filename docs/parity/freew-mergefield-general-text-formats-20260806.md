# FreeW MERGEFIELD General Text Formats (2026-08-06)

## Scope

FreeW preview and Finish & Merge now evaluate Word's native general text formats on MERGEFIELD results:

- `\* Upper`
- `\* Lower`
- `\* FirstCap`
- `\* Caps`

Repeated `\*` switches are retained in instruction order, allowing a text format to coexist with `\* MERGEFORMAT`. The text format applies to the complete visible field result, including conditional `\b` and `\f` fragments, matching Word.

## Exact Word Gate

A short-path C# COM probe merged the recipient value `ada LOVELACE` through five native Word fields. Word produced:

- `Upper=ADA LOVELACE`
- `Lower=ada lovelace`
- `FirstCap=Ada LOVELACE`
- `Caps=Ada LOVELACE`
- `Combined=PRE-ADA LOVELACE-POST` for `\b "pre-" \f "-post" \* Upper`
- `Punct=Ada-Lovelace Ada/Lovelace O'connor` for `\* Caps`

Word package hashes:

- data source: `6909421A5114099AE913C9D9BC59FA30C1EF13F5A6AD4C6BBA7B69829A0AA3C6`
- merge template: `08DFC87EA404D88E259B14799CA77A3646BCB454AA36C0F87B8BAE4F7A3E1F8B`
- merged result: `11179D11713319B05C1B33357013302D09204B23641BF25633820C355861AE65`

FreeW reopened the Word-saved template, preserved all six exact field instructions, and reproduced every merged line exactly.

## Verification

- focused `MailMergeTests` and `ComplexFieldEngineTests`: 172/172
- Word-saved package reopen and result cross-check: 6/6

## Process Note

General field formatting belongs after MERGEFIELD-specific conditional text composition. Formatting only the recipient value looked plausible but failed the combined Word probe, which uppercased both conditional fragments as part of the visible field result. Calibrate interaction order with a combined exact field rather than accepting isolated switch results alone.
