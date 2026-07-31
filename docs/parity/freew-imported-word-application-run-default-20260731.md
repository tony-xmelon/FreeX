# FreeW imported Word application run default parity (2026-07-31)

## Scope

The generated header/footer review fixtures contain a Calibri theme but omit
`w:docDefaults/w:rPrDefault`. Word 16 resolves their body, header, and footer text as Calibri 12 pt;
FreeW imported them as its model-authored Calibri 11 pt default. The smaller FreeW fallback changed
line breaks and continuation-page ownership even after the implicit 1.15-line cadence was restored.

`DocxReader` now distinguishes this imported application-default route from model-authored documents
and packages with explicit run defaults. It resolves the missing size to 12 pt. WPF applies a bounded
1.01 implicit-line calibration and measured style-to-body clearances only on that source route:
3 pt for `Heading1` and 4.5 pt for `Title`. Explicit package run defaults bypass all three adjustments.

## Provenance

- Word 16 PDF export via isolated `ExportAsFixedFormat`, then the same Poppler raster path at 816x1056.
- Direct PDF inspection found embedded `Calibri` / `Calibri-Bold`; body/header glyph records are 12 pt.
- Diagnostic PDF SHA-256: `13F4E15B255427C3E5F9C6255DDE25DB4554BBC8FD8F0E7FE443D85EA42EB399`.
- Fixture SHA-256:
  - `header-footer-basic.docx`: `545DC2AB238FF33495C4576CBA8C017955F1A1A03728A0247F5A11D6C290CBFE`
  - `header-firstpage.docx`: `84C94A2940F8EE3BF5B205476F1BE61F28BFBC31140C9516AE3E1F474BBF1267`
  - `header-odd-even.docx`: `9569AE261311EABF0D7BD4659276C41F6CAC3D869E6CE6797FD60BCDB5D619FE`

## Evidence

For `header-footer-basic`, relative to the accepted implicit-line-spacing baseline, mean absolute RGB
channel delta improved on every page:

| Page | Before | After | Change |
|---|---:|---:|---:|
| 1 | 21.4868 | 13.8873 | -7.5995 |
| 2 | 19.1463 | 15.6003 | -3.5460 |
| 3 | 15.8915 | 12.4956 | -3.3959 |
| Average | 18.8415 | 13.9944 | -4.8471 |

Pixels over the 32-channel threshold improved from `12.3571%/11.4779%/9.5095%` to
`9.0149%/10.0360%/8.1132%`. Body ownership remains exactly `1-10 / 11-21 / 22-30`.

Fresh final metrics and continuation ownership for the sibling fixtures:

- `header-firstpage`: `8.6741 / 16.1758 / 14.5706`; page 1 now owns body items 1-9 like Word.
- `header-odd-even`: `14.0368 / 15.7353 / 15.7713 / 3.7560`; page 4 now starts at item 33
  like Word instead of carrying an incorrect item-32 continuation.

The temporary explicit Calibri 11 pt control kept its three FreeW PNG SHA-256 values byte-stable
through the 1.01/style-clearance refinements and retained Word's 11-item first-page ownership.

## Verification

- `DocDefaultsRoundTripTests|DocDefaultsSpacingReaderTests`: 19/19
- `LineHeightMultipleTests`: 7/7
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh Word COM export: 3/3 documents, 10/10 pages
- Fresh FreeW composite render: matching 3/3, 3/3, and 4/4 page counts

## Acceptance rule

When a DOCX omits run defaults, inspect the exported PDF's embedded font and point size before tuning
glyph scale or wrapping. Preserve a separate explicit-default control, and gate the full continuation
sequence; a lower pixel score caused by overlapping the wrong page content is not valid parity evidence.
