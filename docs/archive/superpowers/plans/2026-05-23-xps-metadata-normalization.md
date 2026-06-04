# XPS Metadata Normalization

## Goal

Keep XPS export metadata behavior aligned with PDF export metadata normalization: trim explicit package property values and skip whitespace-only fields at the final write boundary.

## Scope

- `XpsDocumentProperties.ApplyToPackage` owns normalization before writing `PackageProperties`.
- Workbook-derived properties already pass through the same helper, so explicit and future metadata sources behave consistently.
- No new workbook metadata model is introduced in this slice.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~XpsDocumentProperties_TrimsAndSkipsBlankPackageProperties" -v minimal` failed because the XPS title retained surrounding spaces.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~XpsDocumentProperties_TrimsAndSkipsBlankPackageProperties|FullyQualifiedName~XpsDocumentProperties_ApplyToPackageProperties_WhenOptionIsRequested|FullyQualifiedName~PdfDocumentExporter_TrimsDocumentPropertiesBeforeWriting" -v minimal` passed 3 tests.
