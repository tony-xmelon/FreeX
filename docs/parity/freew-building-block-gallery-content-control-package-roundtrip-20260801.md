# FreeW building-block gallery content-control package parity (2026-08-01)

## Scope

This slice preserves Word building-block gallery content controls represented by
`w:sdtPr/w:docPartObj`. It is limited to FreeW Core Model, Core IO, and focused tests.
No renderer, host, Avalonia `DocumentView`, page-border, or FidelityRender code is involved.

## Semantic contract

- Inline `w:sdt` ownership maps to `ContentControlKind.BuildingBlockGallery` on the owning run.
- Body-level `w:sdt` ownership maps to `BlockContentControlKind.BuildingBlockGallery` on the
  enclosed blocks; their runs remain ordinary runs.
- `w:docPartGallery/@w:val` is retained as the gallery identity.
- Optional `w:docPartCategory/@w:val` is retained when present and omitted when absent.
- `w:docPartUnique` follows Word on/off semantics: empty or `w:val="1"` is true, while
  `w:val="0"` is false. Canonical output emits an empty element for true and omits it for false.
- The existing `BlockContentControlKind.DocumentPart` writer path and bibliography specialization
  remain supported for source compatibility.

## Exact package evidence

`BuildingBlockGalleryContentControlRoundTripTests` constructs a hand-authored DOCX containing:

- a block-level Cover Pages gallery with category `Built-In` and `docPartUnique=1`; and
- an inline Quick Parts gallery with no category and explicit `docPartUnique=0`.

The test asserts the source XML before import, imported model ownership and metadata, canonical
first-save XML, reopened model, exact second-save `word/document.xml` stability, and Office 2013
schema validity for the source package and both saved packages.

## Verification

- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~BuildingBlockGalleryContentControlModelTests`: 2/2.
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~BuildingBlockGalleryContentControlRoundTripTests`: 1/1.
- Existing model ContentControl lane: 11/11.
- Existing IO ContentControl lane: 34/34.

No functional or schema blocker remains in this bounded package slice.
