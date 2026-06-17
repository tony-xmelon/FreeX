# FreeW DOCX corpus growth scout - 2026-06-17

Added 22 download-on-demand DOCX rows to `freew-fidelity-corpus/manifest.csv`, growing the
corpus from 26 to 48 files while keeping third-party binaries out of the repo.

## Added source families

- Apache Tika test documents (Apache-2.0): mixed Word features, charts, SmartArt diagram data,
  EMF and attachments, SDTs inside text boxes, VML hover links, altChunk, and mail merge settings.
- docx4j sample/test documents (Apache-2.0): data-bound invoice content controls, TOC and fields,
  legacy forms, and larger nested-table samples.
- Open XML PowerTools sample documents (MIT): nested content controls, embedded workbook, equation,
  section watermark, and shape/VML samples.
- Open XML SDK test assets (MIT): two broad complex Wordprocessing fixtures plus object/text/picture
  and SDT normalization fixtures.

## Coverage added

New manifest tags include `altchunk`, `checkboxes`, `custom-xml`, `equations`,
`external-relationships`, `glossary`, `hyperlinks`, `legacy-forms`, `mail-merge`, `settings`,
`shapes`, `smartart`, `text-boxes`, `theme`, `vml`, `watermarks`, and `web-settings`.

The largest new rows are Open XML SDK's `complex2005_12rtm.docx` and `complex1_NOR.docx`, which add
broad package coverage without committing the binaries.
