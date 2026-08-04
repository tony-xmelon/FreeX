# FreeW no-break hyphen round trip

## Gap

Word stores a non-breaking hyphen as the empty run child
`w:noBreakHyphen`. FreeW ignored that child, deleting the visible character and
its no-wrap behavior during import.

## Slice

- Map `w:noBreakHyphen` to Unicode U+2011 in authored child order.
- Keep the character in normal model text so WPF, Avalonia, search, copy, and
  document statistics consume one visible non-breaking character.
- Write U+2011 back as canonical `w:noBreakHyphen` rather than a plain glyph.

The Open XML SDK identifies `w:noBreakHyphen` as Word's non-breaking hyphen
character: https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.nobreakhyphen

## Verification

The exact package test imports `non`, `w:noBreakHyphen`, `breaking` from one
run, asserts the U+2011 model position, checks canonical saved XML child order,
and reopens the saved package to prove the semantic character remains.

## Process rule

Do not flatten semantic run characters to generic text before deciding line-
breaking ownership. Preserve a source token that changes wrapping as a distinct
canonical package element on save.
