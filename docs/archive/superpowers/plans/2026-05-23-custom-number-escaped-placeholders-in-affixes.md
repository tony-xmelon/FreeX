# Custom Number Escaped Placeholders In Affixes

## Goal

Improve Excel custom-number fidelity for formats that combine quoted literal affixes with escaped numeric-placeholder
characters. Escaped `0`, `#`, and `?` characters should display literally and must not cause the affix extractor to
consume the cell value.

## Checklist

- [x] Add red formatter examples for quoted-affix formats with escaped placeholder characters.
- [x] Update `NumberFormatter.ExtractNumericAffixes` so escaped characters outside quotes become literal affix text
      and are not counted as numeric placeholders.
- [x] Preserve escapes for non-placeholder characters that remain inside extracted numeric patterns.
- [x] Run focused and full `NumberFormatterTests`.
- [x] Update architecture and command-parity documentation.

## Verification

- Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_HandlesEscapedLiteralsAndCommaScaling" -v minimal` failed because `"ID "\0`, `"ID "\#`, and `"ID "\#0` treated escaped placeholder characters as numeric placeholders.
- Review fix: preserve escapes for non-placeholder characters inside extracted numeric patterns and add guards for escaped
  `?`, escaped percent, and escaped comma.
- Green: the same focused formatter test passed 12 tests.
- Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests" -v minimal` passed 268 tests.
