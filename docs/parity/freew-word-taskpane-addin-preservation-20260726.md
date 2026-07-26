# FreeW Word Task-Pane Add-in Preservation

Date: 2026-07-26

## Scope

Preserve a Word task-pane add-in through a FreeW DOCX read/write cycle. Word stores the add-in marker in `word/document.xml`, the marker target in `word/_rels/document.xml.rels`, and the task-pane plus web-extension payload in `word/webextensions/`.

## Behavior

- `DocxReader` captures `w:webExtensions` with its document relationship references.
- The task-pane part, its local relationship part, and the web-extension payload are preserved byte-for-byte.
- `DocxWriter` emits fresh document relationship IDs and rewrites the preserved `w:webExtension/@r:id` marker to the new ID.
- Content-type overrides and the local task-pane relationship graph remain unchanged.

## Verification

```powershell
dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" --logger "trx;LogFileName=webextensions-preservation.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 11 passed, 0 failed.

The regression package proves the task-pane marker, rebuilt document relationship, task-pane XML, local `.rels`, web-extension payload, content types, and a second round trip.
