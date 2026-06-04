# Custom Number Question Placeholders

## Goal

Close an Excel custom-number fidelity gap where `?` placeholders in ordinary integer and decimal formats were rendered as literal question marks by .NET custom numeric formatting instead of Excel-style alignment spaces.

## Scope

- Preserve existing fraction handling for formats such as `# ?/?`.
- Apply the new behavior only to active, unescaped, unquoted `?` placeholders in numeric formats.
- Keep prefix/suffix literal extraction as the boundary for quoted affixes such as `"ID "??0.??`.

## Verification

- Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~CustomNumberSubset_FormatsQuestionPlaceholdersAsAlignmentSpaces" -v minimal` failed because formats like `??0` and `0.??` rendered literal `?` characters.
- Green: same command passed 6 tests after adding the dedicated formatter path.
- Broader: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~NumberFormatterTests" -v minimal` passed 274 tests.
