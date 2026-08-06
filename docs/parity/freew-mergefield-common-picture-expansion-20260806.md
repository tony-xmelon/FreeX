# FreeW MERGEFIELD Common Picture Expansion (2026-08-06)

## Scope

FreeW preview and Finish & Merge now cover additional exact Word-calibrated `MERGEFIELD` result pictures:

- numeric rounding and fixed decimals: `0`, `0.00`
- grouped integer and fixed decimals: `#,##0`, `#,##0.00`
- leading zeros: `000000`
- negative currency sections: `$#,##0.00;($#,##0.00)`
- explicit zero text: `0.00;-0.00;ZERO`
- single-quoted date literals, such as `MMMM d, yyyy 'at' h:mm AM/PM`

Optional-decimal pictures such as `#,##0.##` remain source-preserving because Word reserves blank width for unused `#` positions while .NET removes them. Unknown date letters and unmatched literals also remain source-preserving.

## Exact Word Gate

A short-path C# COM corpus merged `8/6/2026 2:05 PM`, `1234.5`, `-1234.5`, and `0`. Word produced:

- `DateLiteral=August 6, 2026 at 2:05 PM`
- `Integer=1235`
- `Fixed=1234.50`
- `GroupedInteger=1,235`
- `GroupedFixed=1,234.50`
- `OptionalDecimals=1,234.5 `, retained as negative evidence because of its trailing reserved position
- `LeadingZeros=001235`
- `NegativeFixed=-1,234.50`
- `PositiveSections=$1,234.50`
- `NegativeSections=($1,234.50)`
- `PositiveThreeSections=1234.50`
- `NegativeThreeSections=-1234.50`
- `ZeroSections=ZERO`

Word package hashes:

- data source: `F10CB3A7300D8F896AFCCCC441868F2DA24D7FB54FCFCA50DEF0C47BF506B4B6`
- merge template: `6C0121AB99D34A172F048B15B8DB45D930223DF6CE04172896A3867ABAD2F208`
- merged result: `5DAAA460A4362CC7599F8216B33DB432140578D9B438FDEBFEAEAAD275AAE23F`

## Verification

- focused `MailMergeTests`: 159/159
- exact Word result corpus: 13/13 measured; 12 accepted and one optional-decimal negative control retained

## Process Note

Expand Word picture support by exact semantic families, not by passing arbitrary field pictures to .NET. Accept only patterns whose rounding, grouping, section selection, literal handling, and whitespace match Word; preserve the source value for the rest.
