# FreeW Styles-With-Effects Preservation

Date: 2026-07-26

## Scope

Preserve Word 2013+'s supplemental `word/stylesWithEffects.xml` payload through
a FreeW DOCX read/write cycle. Microsoft Word maintains this part beside
`word/styles.xml` when richer style effects need to round-trip.

## Behavior

- FreeW keeps its existing modeled `styles.xml` read/write path.
- The reader captures `stylesWithEffects.xml`, its document relationship, and
  any part-local relationship graph verbatim.
- The writer re-emits the original content type and document relationship so
  Word can continue to use its richer effect-style payload after reopening.

## Verification

```powershell
dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" --logger "trx;LogFileName=styles-effects-green.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

The regression package checks byte-identical effect-style payload retention,
the rebuilt document relationship, content-type override, and a second read/
write cycle.
