# FreeW explicit document-default natural line spacing parity (2026-08-01)

## Scope

Imported WordprocessingML was marked to use Word's application-default 1.15-line cadence whenever a
paragraph had no explicit `w:spacing/@w:line`. That is correct for packages with no paragraph-default
root, but not for packages that author `w:docDefaults/w:pPrDefault/w:pPr` and omit only the line token.
Word uses the font's natural single-line box in the latter case.

`DocxReader` now clears the application-default fallback when an authored paragraph-default root is
present. It also preserves whether that root carries an explicit line token. WPF's paragraph cascade
consumes an explicit document-default line only after direct and style line rules, so an authored
`w:line="276"` remains authoritative while an omitted line uses natural layout.

## Provenance

- Fixture: `wordart-watermark-stress.docx`
- Fixture SHA-256: `82ED2615AD914FE8611DCBBC962CB864324830FC283021D553131BB1D994B681`
- Word 16 export: isolated visible COM `ExportAsFixedFormat`, short staging path
  `C:\FWP\pdf\fw-16024-0.pdf`
- Word PNG: 816x1056, SHA-256
  `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- FreeW path: fresh Release `FreeW.FidelityRender`, WPF composite, 816x1056

The Word trace reached ready, open, ready-with-one-document, export, close, and owned-process quit.
Source and output path lengths were 39 and 25 characters. The PDF was removed after rasterization.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| Whole page | 6.5238% | 4.2071% | -2.3167 pp |
| Content | 9.9816% | 6.5647% | -3.4169 pp |
| Intro flow | 12.2306% | 8.1483% | -4.0823 pp |
| Lower body flow | 11.5917% | 7.4946% | -4.0971 pp |
| Banner | 6.6467% | 6.3476% | -0.2991 pp |
| Green backing shape | 6.2728% | 4.7645% | -1.5083 pp |
| Review Copy | 4.2895% | 4.2122% | -0.0773 pp |
| Title | 4.4353% | 4.4353% | byte-stable |
| Frame top | 0.0000% | 0.0000% | byte-stable |

Word's lower body line bands end at y=823; FreeW moved from y=864 to y=821. Corresponding line
bands track within about two pixels through paragraph 12 instead of accumulating roughly five pixels
of excess advance per paragraph.

Two temporary package controls were rendered by the candidate:

- explicit document-default `w:line="276" w:lineRule="auto"`
- no `w:pPrDefault` root, retaining the imported application fallback

Both controls were byte-identical to the pre-fix FreeW PNG:
`F4B235AB45136824F439F70AE252E8C1F6D719E81753AB2E9A2B2FE46FEB2802`.

## Verification

- `DocDefaultsSpacingReaderTests`: 16/16
- `LineHeightMultipleTests`: 8/8
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Exact fixture render: 1/1 page
- Word COM export: 1/1 document, clean owned-process exit

## Process rule

Treat an absent paragraph-default root, an authored root with no line token, and an explicit default
line rule as three separate provenance states. Gate paragraph-cadence changes against the complete
affected page, raw line bands, and pixel-stable explicit/fallback controls.
