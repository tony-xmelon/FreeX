# FreeW Quick Parts Document Properties Avalonia Parity - Wave 49

## Resolved mismatch

Avalonia's Insert > Quick Parts gallery exposed Title, Author, Subject, and Date,
but omitted the Word-compatible Keywords and Comments document-property fields
already available in WPF and the shared model.

Avalonia now exposes both entries and inserts live `RunFieldKind.Keywords` and
`RunFieldKind.DocComments` fields through `DocumentView.InsertField`. They use
the existing document-property renderer and DOCX field serialization path, so
updates, undo/redo, and round-trip behavior remain shared with WPF.

## Validation

Build:

`dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 0 warnings, 0 errors.

Focused tests:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~InsertDepth2Tests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 48 passed, 0 failed, 0 skipped.
