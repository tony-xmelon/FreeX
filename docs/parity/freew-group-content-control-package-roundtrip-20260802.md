# FreeW Group content-control package parity (2026-08-02)

## Scope

This slice preserves Word Group content controls represented by `w:sdtPr/w:group`. It is limited
to FreeW Core Model, Core IO, and focused tests. No page-border planner or renderer, host/Avalonia
`DocumentView`, or FidelityRender source is involved.

## Semantic contract

- Inline `w:sdt` ownership maps to `ContentControlKind.Group` on the owning run.
- Body-level `w:sdt` ownership maps to `BlockContentControlKind.Group` on every enclosed block;
  those blocks share one control instance and their runs remain ordinary runs.
- `Run.GroupControl` and `BlockContentControl.GroupRegion` construct the two explicit ownership
  forms without changing any existing content-control kind.
- Both forms serialize an empty `w:group` kind marker and never fall back to `w:text`, `w:richText`,
  or `w:docPartObj`.
- Existing common SDT alias, tag, lock, identity, placeholder, data binding, temporary, appearance,
  and color metadata survive import, save, reopen, and a second save.
- Office 2013 requires `w15:color/@w:val`. New saves use that schema-valid form; the reader also
  accepts legacy FreeW `w15:color/@w15:val` packages and canonicalizes them on save.

## Exact package evidence

`GroupContentControlRoundTripTests` constructs a hand-authored DOCX containing:

- one body-level Group SDT wrapping two paragraphs, with a combined control/content lock and the
  full common metadata payload; and
- one inline Group SDT inside a separate paragraph, with its own control lock and identity metadata.

The test asserts source XML, imported ownership and metadata, canonical first-save XML, reopened
model, exact second-save `word/document.xml` stability, and Office 2013 schema validity for the
source package and both saved packages. A second test imports the legacy FreeW color attribute,
retains its value, writes the standard attribute, and validates the resulting package.

## Verification

- Group model factory contract: 1/1.
- Group exact package and legacy-canonicalization contracts: 2/2.
- Full focused Core Model content-control lane: 12/12.
- Full focused Core IO content-control lane: 36/36.

No functional or schema blocker remains in this bounded package slice.
