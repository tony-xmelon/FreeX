# FreeP external RTF list-template punctuation

The external RTF planner now combines the existing `\\levelnfc` numbering family with the literal punctuation carried by `\\leveltext`. Common period, closing-parenthesis, and both-parenthesis variants are mapped to the existing `AutoNumType` values for Arabic, Roman, and alpha lists.

This preserves authored cases such as `A)` instead of normalizing them to `A.` while keeping unsupported ordinal, locale-specific, and multi-token numbering templates on the established Arabic-period fallback.

Evidence:

- `WordListTable_UsesLevelTextPunctuationForExistingAutoNumberVariants` proves an RTF alpha level with a closing parenthesis reaches `AutoNumType.AlphaUcParenR`.
- Existing external RTF list, restart, indentation, and custom-bullet contracts remain green.
