# FreeW Attached-Template Relationship Preservation

Date: 2026-07-26

## Scope

Preserve Word's attached-template relationship through a FreeW DOCX read/write
cycle. Word stores the `w:attachedTemplate/@r:id` marker in
`word/settings.xml`, with its relationship in
`word/_rels/settings.xml.rels`.

## Behavior

- FreeW continues to overlay its modeled settings onto the original
  `w:settings` element.
- The reader now also captures the settings-local relationship graph verbatim.
- An attached external template stays connected after save; internal local
  relationship targets are captured recursively when present.

## Verification

```powershell
dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" --logger "trx;LogFileName=attached-template-green.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 12 passed, 0 failed. The regression package checks the exact
`w:attachedTemplate` relationship id and byte-identical local relationship
part after two complete read/write cycles.
