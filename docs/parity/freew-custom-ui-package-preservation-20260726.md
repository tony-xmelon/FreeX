# FreeW Custom UI Package Preservation

Date: 2026-07-26

## Scope

Preserve a Word document's package-root custom Ribbon relationship, `customUI/customUI.xml`, and the custom UI part's local relationship graph through a FreeW DOCX read/write cycle.

## Behavior

- `DocxReader` captures package-root targets under `/customUI/` and records the package relationship type on the root part.
- The reader recursively retains the custom UI part's `.rels` and referenced resources such as Ribbon images.
- `DocxWriter` emits deterministic package-root relationships for preserved parts that carry a package relationship type.
- Existing content-type defaults and overrides continue to preserve custom UI XML and local resources.

## Verification

Focused Core.IO preservation suite:

```powershell
dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter "FullyQualifiedName~PreservedPartsRoundTripTests" --logger "trx;LogFileName=custom-ui-preservation.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal
```

Result: 10 passed, 0 failed.

The authored-package regression test verifies the custom UI XML, local relationship part, embedded image bytes, custom UI content type, package-root relationship, and a second read/write round trip.
