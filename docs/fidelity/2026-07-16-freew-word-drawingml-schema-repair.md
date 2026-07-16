# FreeW Word DrawingML Schema Repair

**Date:** 2026-07-16

## Scope

The `drawing-objects-complex`, `wordart-watermark-stress`, and
`wordart-picture-watermark-layout` generated DOCX fixtures failed Open XML schema validation. Those
package defects can cause Microsoft Word to repair or reinterpret a document before visual parity can
be meaningfully compared.

## Corrections

- Emit the VML `v:ext="edit"` attribute on watermark `o:lock`, rather than an undeclared unqualified
  `ext` attribute.
- Stop writing FreeW-private `freewStyleId` and `freewColorId` attributes on `dgm:styleDef` and
  `dgm:colorsDef`; those roots do not permit arbitrary attributes.
- Persist SmartArt style identity in the standard quick-style `uniqueId` URI and recover it from that URI.
- Recover Word's standard `accent1_2` color URI as FreeW's `accent1` gallery entry. The reader still
  accepts the old private attributes when opening legacy FreeW packages.

## Verification

- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~SmartArtRoundTripTests"`
  passed 32/32.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~VisualEvidenceDocxSchemaTests.WordComparableDrawingFixtureDocxPassesOpenXmlSchema"`
  passed 5/5.
- The visible Word publish fallback exported all three repaired fixtures to PDF and raster PNG under the
  ignored `freew-fidelity-corpus/runs/word-com-drawing-schema-20260716/` evidence run.

Direct `ExportAsFixedFormat` calls remained blocked in the active Word automation session, including
a native smoke document. The visible `Publish as PDF or XPS` path completed successfully and is the
current reliable Word baseline route on this machine.
