# Custom Number Single Text Section

## Goal

Apply custom number formats such as `@" units"` to text values when no fourth semicolon text section is present.

## Decisions

- Keep Excel's fourth-section precedence for text values.
- When no fourth section exists, apply the first section only if it contains an `@` text placeholder.
- Reuse the existing text-section renderer so quotes, escapes, spacing directives, and fill directives behave consistently.

## Verification

- Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CustomNumberSubset_AppliesSingleTextSectionWhenItContainsPlaceholder" -v minimal` failed 3 cases because single-section text placeholders were ignored.
- Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "NumberFormatterTests" -v minimal` passed 261 tests.
