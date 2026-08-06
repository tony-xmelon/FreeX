# FreeW MERGEFIELD numeric general formats parity (2026-08-06)

## Scope

FreeW now evaluates Word's common numeric general result switches during both ordinary and
rule-aware mail merge:

- `Arabic`
- `ROMAN` / `roman`
- `ALPHABETIC` / `alphabetic`
- `Hex`
- `Ordinal`
- `OrdText`
- `CardText`
- `DollarText`

Unknown switches and nonnumeric source values remain unchanged. `MERGEFORMAT` remains a
format-retention marker rather than a value transformation.

## Word authority

The reference was Microsoft Word `16.0.20228.20124`, driven through a short-path C# `dynamic`
COM probe under `C:\fm8`. Each sweep created a Word-table data source, an exact MERGEFIELD
template, and Word's merged result. Word launched, merged, saved, and quit cleanly in 6-13
seconds per sweep. The temporary corpus was deleted after integration.

The final boundary-sweep package hashes were:

- data: `934759D417F7A19F60E8EFA898BD282ADF445A8A39E94A709D190E85D8004D04`
- template: `E6E397344B63BE9A80D118AC6D498C867F653D33799497ADB54473D691D5910A`
- result: `ADD615A4201DB3A06DC46B5FD59DCE2A32F9565C216560D13280923A804E5DEB`

## Calibrated behavior

Word's results established these non-obvious contracts:

- Numeric integral formats round midpoint values away from zero: `12.5 -> 13`, `-12.5 -> -13`.
- Roman accepts `1..32767`, emits blank for zero, and errors for negative/out-of-range values.
- Alphabetic is repeated-letter numbering, not spreadsheet base-26: `27 -> AA`, `52 -> ZZ`,
  `702 ->` 27 Z characters, `703 ->` 28 A characters; `780` is the maximum.
- Hex accepts `0..65535`, always using uppercase hexadecimal digits.
- Ordinal permits signed values (`-21st`) and uses the ordinary 11/12/13 suffix exception.
- `CardText` and `OrdText` use lowercase US English through `999999`; their rounded integer
  result errors when it leaves that range.
- `DollarText` supports a nonnegative integer part through `999999`, formats cents to two digits,
  and does not carry rounded `100/100` into the whole number (`12.995 -> twelve and 00/100`).
- A lone numeric switch on a numeric nonempty field suppresses conditional `\b`/`\f` text.
  With multiple general switches, punctuation-only wrappers are likewise suppressed, while wrappers
  containing letters are processed as part of the assembled result and make the numeric transform a no-op.

Representative exact results include:

| Field value and switch | Word result |
| --- | --- |
| `27 \\* ROMAN` | `XXVII` |
| `27 \\* roman` | `xxvii` |
| `4000 \\* ROMAN` | `MMMM` |
| `32768 \\* ROMAN` | `Error! Number cannot be represented in specified format.` |
| `703 \\* ALPHABETIC` | 28 `A` characters |
| `781 \\* ALPHABETIC` | representation error |
| `65535 \\* Hex` | `FFFF` |
| `1234 \\* OrdText` | `one thousand two hundred thirty-fourth` |
| `999999 \\* CardText` | `nine hundred ninety-nine thousand nine hundred ninety-nine` |
| `12.005 \\* DollarText` | `twelve and 01/100` |

## Verification

`dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~MailMergeTests`

Result after implementation: `202/202` passed. The cases execute both `MergeRecord` and
`MergeRecordWithRules` and include ranges, errors, casing, rounding, nonnumeric controls, switch
ordering, and conditional-text behavior.
