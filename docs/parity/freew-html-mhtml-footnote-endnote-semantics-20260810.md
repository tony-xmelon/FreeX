# FreeW HTML/MHTML Footnote and Endnote Semantics

## Word contract

Word's HTML representation keeps note references in the body and stores note bodies in
`mso-element:footnote-list` / `mso-element:endnote-list` containers. Reference and backlink anchors use
the `_ftn` / `_edn` naming convention. Reopening the file must not flatten note bodies into ordinary body
paragraphs.

## Previous gap

`HtmlFileAdapter.WriteRuns` deliberately skipped every footnote and endnote reference. HTML and MHTML
therefore lost both the body markers and the complete note stores, including note formatting, links,
images, automatic-reference state, and numbering options.

## Implementation

- Filtered HTML, full Web Page HTML, and MHTML now emit Word-style note reference/backlink anchors and
  `mso-element` note-store containers.
- Deterministic `data-freew-*` metadata preserves note identity, automatic-reference presence, number
  format, start value, and restart behavior when FreeW reopens its own output.
- Visible marker/backlink text follows the configured start value and number format and resets at explicit
  page breaks or section boundaries.
- Word's native `mso-footnote-numbering-style`, `mso-footnote-numbering-start`, and
  `mso-footnote-numbering-restart` CSS is emitted and parsed, preserving natural-page/section restart
  semantics when Word owns layout.
- The reader recognizes both that metadata and conventional Word `_ftn` / `_edn` markup.
- Note stores are parsed before the body and excluded from normal block traversal, so their paragraphs do
  not leak into the main document flow.
- Multi-paragraph note content, paragraph/run formatting, hyperlinks, data-URI images, and MHTML CID images
  reuse the existing HTML block/run and resource paths.
- Word ownership signals are required before `_ftn` / `_edn` anchors become notes; coincidentally named
  ordinary fragment links remain hyperlinks. Automatic backlinks and custom note marks remain distinct.

## Word evidence

A controlled Word `SaveAs2(..., wdFormatHTML)` export at a short local path established the native CSS
tokens rather than relying on inferred markup. Lower-Roman/start-at-3 emitted
`mso-footnote-numbering-style:roman-lower` plus `mso-footnote-numbering-start:3`; page and section restart
emitted `mso-footnote-numbering-restart:each-page` and `each-section`, respectively. The owned Word process
and temporary export directory were removed after inspection.

## Verification

- Filtered HTML, full Web Page HTML, and MHTML round-trip body references, footnote/endnote stores,
  automatic-reference state, numbering options, hyperlinks, marker formatting, and a note image.
- A conventional Word HTML fixture imports footnote/endnote anchors and bodies without adding note-store
  paragraphs to the document body.
- `HtmlMhtmlRoundTripTests` passed 22/22.
- Full `FreeW.Core.IO.Tests` passed 1,587/1,587.
- `tools/Test-RepositoryPreflight.ps1` passed.
- `dotnet build FreeW.slnx --configuration Release` succeeded with 0 warnings and 0 errors.
