# FreeW Package-Root Part Preservation

Date: 2026-07-26

## Scope

Preserve Word package-root parts FreeW does not model, including a custom Ribbon relationship, `customUI/customUI.xml`, its local relationship graph, and a document thumbnail through a FreeW DOCX read/write cycle.

## Behavior

- `DocxReader` captures non-modelled package-root targets and records the package relationship type on the root part.
- The reader recursively retains each root part's `.rels` and referenced resources such as Ribbon images.
- `DocxWriter` emits deterministic package-root relationships for preserved parts that carry a package relationship type.
- Existing content-type defaults and overrides continue to preserve custom UI XML and local resources.

## Verification

Focused Core.IO preservation suite:

```powershell
dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" --logger "trx;LogFileName=custom-ui-preservation.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 10 passed, 0 failed.

The authored-package regression test verifies the custom UI XML, local relationship part, embedded image bytes, thumbnail bytes, content types, package-root relationships, and a second read/write round trip.
