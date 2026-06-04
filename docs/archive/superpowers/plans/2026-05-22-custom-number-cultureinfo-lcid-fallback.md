# Custom Number CultureInfo LCID Fallback

## Scope

Broaden custom-number LCID handling without adding another fixed catalog slice.

## Checklist

- [x] Add failing tests for an uncataloged LCID token using localized number separators.
- [x] Add failing coverage for currency-token preservation with the same uncataloged LCID.
- [x] Resolve uncataloged LCIDs through .NET `CultureInfo` after the curated FreeX catalog misses.
- [x] Update command parity and architecture documentation.

## Verification

- Red: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "Format_LcidToken_FallsBackToDotNetCultureSeparatorsForUncatalogedLocale|Format_LcidCurrencyToken_PreservesSymbolWhenUsingCultureFallback" -v minimal` failed because uncataloged `0C07` still rendered with invariant `1,234.50`.
- Green: `dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "Format_LcidToken_FallsBackToDotNetCultureSeparatorsForUncatalogedLocale|Format_LcidCurrencyToken_PreservesSymbolWhenUsingCultureFallback" -v minimal` passed 2 tests.

## Architectural Decision

The custom-number formatter keeps its curated LCID catalog as the authoritative path for tested Excel/FreeX behavior. Unknown LCID tokens now fall back to .NET `CultureInfo` number and date formatting metadata, which improves coverage for real workbooks while preserving deterministic overrides for locales that FreeX has explicitly modeled.
