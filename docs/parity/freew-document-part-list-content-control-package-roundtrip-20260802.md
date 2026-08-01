# FreeW document-part list content-control package parity (2026-08-02)

## Scope

This slice preserves Word document-part list content controls represented by
`w:sdtPr/w:docPartList`. It is limited to FreeW Core Model, Core IO, focused tests, and this
evidence note. No renderer, host, Avalonia `DocumentView`, page-border, FidelityRender, or command
inventory code is involved.

## Semantic contract

- Inline `w:docPartList` ownership maps to `ContentControlKind.DocumentPart` on the owning run.
- Body-level `w:docPartList` ownership maps to `BlockContentControlKind.DocumentPart` on all blocks
  enclosed by the same body-level SDT; their runs remain ordinary runs.
- `Run.DocumentPartListControl` and `BlockContentControl.DocumentPartListRegion` require a gallery
  identity and preserve optional category and unique metadata.
- `w:docPartList` remains explicitly distinct from `w:docPartObj`. Existing inline/block
  `BuildingBlockGallery` controls and the Bibliography specialization continue to use
  `w:docPartObj`.
- `w:docPartGallery/@w:val` and optional `w:docPartCategory/@w:val` round-trip without changing
  their values.
- `w:docPartUnique` follows Word on/off semantics: empty or `w:val="1"` is true, while
  `w:val="0"` is false. Canonical output emits an empty element for true and omits it for false.
- Common SDT metadata remains attached to the same owner: alias, lock, ID, tag, data binding,
  placeholder, showing-placeholder, temporary, appearance, and color.

## Exact package evidence

`DocumentPartListContentControlRoundTripTests` constructs a hand-authored DOCX containing:

- one body-level `w:docPartList` wrapping two paragraphs, with gallery `AutoText`, category
  `General`, `docPartUnique=1`, and the full common metadata set; and
- one inline `w:docPartList` inside a paragraph, with gallery `Equations`, category `Built-In`,
  explicit `docPartUnique=0`, and inline common metadata.

The test asserts source XML, imported model ownership and metadata, canonical first-save XML,
reopened model identity, exact second-save `word/document.xml` stability, and Office 2013 schema
validity for the source package and both saved packages. The existing building-block gallery test
also asserts that `w:docPartObj` output contains no `w:docPartList` sibling.

## Verification

- Focused compiling model tests: `DocumentPartListContentControlModelTests` 2/2.
- Focused compiling IO test: `DocumentPartListContentControlRoundTripTests` 1/1.
- Combined document-part list and building-block gallery IO tests: 2/2.
- Full Core Model content-control filter: 15/15.
- Full Core IO content-control filter: 39/39.
- Bibliography block content-control filter: 2/2.

No functional or schema blocker remains in this bounded package slice.
