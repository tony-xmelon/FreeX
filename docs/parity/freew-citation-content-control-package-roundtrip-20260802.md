# FreeW Citation content-control package parity (2026-08-02)

## Scope

This slice preserves Word Citation content controls represented by `w:sdtPr/w:citation`. It is
limited to FreeW Core Model, Core IO, and focused tests. No page-border planner or renderer,
host/Avalonia `DocumentView`, or FidelityRender source is involved.

## Semantic contract

- Inline `w:sdt` ownership maps to `ContentControlKind.Citation` on the owning run.
- Body-level `w:sdt` ownership maps to `BlockContentControlKind.Citation` on every enclosed block;
  enclosed runs remain ordinary runs and consecutive blocks retain shared block-control ownership.
- `Run.CitationControl` and `BlockContentControl.CitationRegion` construct the two explicit forms
  without changing the values or behavior of existing content-control kinds.
- Both forms serialize one canonical empty `w:citation` kind marker and never fall back to
  `w:text`, `w:richText`, `w:group`, or `w:docPartObj`.
- Existing common SDT alias, tag, lock, identity, placeholder, data binding, temporary, appearance,
  and color metadata survive import, save, reopen, and a second save.
- A native Word `CITATION` complex field remains a five-run field sequence inside its Citation SDT.
  Imported Citation metadata is retained; programmatic fields receive a canonical `w:id` child.

## Exact package evidence

`CitationContentControlRoundTripTests` constructs a hand-authored DOCX containing:

- one body-level Citation SDT with a combined control/content lock and the full common metadata
  payload; and
- one inline Citation SDT with its own lock and metadata, wrapping a native `CITATION` complex
  field and cached display result.

The test asserts source XML, imported ownership and metadata, canonical first-save XML, reopened
model, exact second-save `word/document.xml` stability, native field structure, and Office 2013
schema validity for the source package and both saved packages. A second test verifies that an
existing programmatic Citation field emits a schema-valid `w:id` child plus `w:citation` and reopens
with the explicit Citation kind.

## Verification

- Citation model factory contract: 1/1.
- Citation exact package and programmatic-field contracts: 2/2.
- Full focused Core Model content-control lane: 13/13.
- Full focused Core IO content-control plus complex-field lane: 49/49.

No functional or schema blocker remains in this bounded package slice.
