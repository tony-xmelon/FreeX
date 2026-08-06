# FreeW MERGEFIELD Conditional Text Switches (2026-08-06)

## Scope

FreeW preview and Finish & Merge now evaluate Word's native MERGEFIELD conditional text switches:

- `\b "text"` prefixes the recipient value only when that value is nonblank.
- `\f "text"` appends the recipient value only when that value is nonblank.
- A blank or missing recipient value suppresses the value and both conditional fragments.

Legacy guillemet placeholders remain unchanged. The behavior applies to both the ordinary record path and the rules-aware record path used by WPF and Avalonia.

## Exact Word Gate

A short-path C# COM probe created a two-record Word data source (`Name=Ada` and blank), authored `MERGEFIELD Name \b "[" \f "]"`, and executed the merge in Word. Word produced:

- nonblank record: `Value=[Ada];End`
- blank record: `Value=;End`

Word package hashes:

- data source: `39763403648116BFAE3411C07CA8EB86EF4451D0BB967056AE37D65AB126628A`
- merge template: `FAABC9BA6710E22524E6D5C4DD4B6608B9439C62DB8FE5E3788D9968C08D4EFB`
- merged result: `90529B8CEF3E7AEEF0DAA753AB3D5D116D83637B4C4F77719C1BD363C987604D`

FreeW reopened the Word-saved template with the exact instruction `MERGEFIELD Name \b "[" \f "]" \* MERGEFORMAT` and reproduced both record results exactly.

## Verification

- focused `MailMergeTests`: 122/122
- Word-saved package reopen and two-record result cross-check: 2/2

## Process Note

Do not use `Word.Application.Ready` as the startup gate on this Office build: it remains false or empty even with a responsive active document. Use an observable document handshake (`Documents.Add`, `Documents.Count`, readable document name) instead. PowerShell's overloaded `SaveAs2` COM binding can stall on optional/ref parameters; the short-path C# `dynamic` COM route reaches Word, saves immediately, and closes cleanly. Keep scratch paths short and remove the probe corpus after integration.
