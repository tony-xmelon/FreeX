# Custom Number LCID Currency Plan

- [x] Identify LCID currency tokens as the next small custom number-format fidelity gap.
- [x] Add failing formatter tests for visible currency symbols in `[$symbol-lcid]` tokens.
- [x] Preserve visible currency symbols before generic bracket stripping.
- [x] Run focused formatter verification.
- [x] Update parity docs and architecture notes.
- [x] Fix review finding for LCID currency tokens after sign/accounting literals.
- [x] Fix review finding for LCID currency tokens followed by accounting fill-space directives.
- [x] Fix review finding for quoted placeholder literals during affix extraction.
- [x] Extend LCID handling to deterministic decimal/group separators for modeled LCIDs `409`, `407`, `40C`, and `422`.
- [x] Extend LCID handling to deterministic custom-date separators for modeled LCIDs `409`, `407`, `40C`, and `422`.
- [ ] Run final verification, review, commit, merge, and sync.

## Verification

- `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_PreservesVisibleCurrencyFromLocaleTokens"` - failed before implementation because the visible currency symbols were stripped.
- `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~NumberFormatterTests.CustomNumberSubset_PreservesVisibleCurrencyFromLocaleTokens"` - 7 passed.
- `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal --filter "FullyQualifiedName~NumberFormatterTests|FullyQualifiedName~NumberFormatterDateTests"` - 47 passed.
- `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` - 195 passed.

## Review Notes

- Spec review finding: LCID currency tokens after a sign or accounting parenthesis were treated as a suffix and dropped the numeric pattern. Fixed by deriving quoted literal prefix/suffix from numeric placeholder bounds and preserving alignment-only `?` placeholders as non-rendering literals.
- Quality review finding: LCID currency tokens followed by accounting fill directives lost the visible fill space. Fixed by preserving `* ` as a single display space while rewriting the LCID token.
- Quality re-review finding: quoted placeholder literals such as `"0"` and `"??"` were treated as real placeholders. Fixed by tracking numeric placeholder bounds only outside quoted literal spans.
- LCID separator decision: FreeX does not bind custom number formatting to the user's OS culture. Instead, explicit workbook LCIDs map to a small deterministic separator table so common imported formats render predictably while full Excel locale services remain partial.
- LCID date decision: the same deterministic LCID table now supplies custom-date separators for date/time value and numeric date-serial rendering, without localizing month/day names or adopting OS culture services.
