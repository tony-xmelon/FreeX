# FreeW WPF footer vertical registration parity (2026-08-04)

## Scope

The WPF composite evidence path placed every WordprocessingML footer four pixels below Word. The
normal page-box path and generated-page fallback duplicated the same `+7 DIP` footer-origin
compensation. Both now use one `FooterTopDip` helper with a measured `+3 DIP` compensation.

This changes only footer composition. Header placement, footer content/layout, body pagination, and
the source package remain unchanged.

## Provenance

- Word 16 `ExportAsFixedFormat` from isolated, visible COM instances, followed by the repository PDF
  rasterizer at 816x1056.
- FreeW Release `FreeW.FidelityRender --composite`, rebuilt after the source change.
- Fresh Word exports completed without prompts or failures: 3 documents, 10 pages.
- Fixture SHA-256:
  - `header-footer-basic.docx`: `545DC2AB238FF33495C4576CBA8C017955F1A1A03728A0247F5A11D6C290CBFE`
  - `header-firstpage.docx`: `84C94A2940F8EE3BF5B205476F1BE61F28BFBC31140C9516AE3E1F474BBF1267`
  - `header-odd-even.docx`: `9569AE261311EABF0D7BD4659276C41F6CAC3D869E6CE6797FD60BCDB5D619FE`

## Evidence

Mean absolute RGB channel difference, expressed as a percentage of 255:

| Fixture/page | Whole before | Whole after | Footer ROI before | Footer ROI after |
|---|---:|---:|---:|---:|
| basic 1 | 5.6345% | 5.5905% | 1.8997% | 0.6593% |
| basic 2 | 6.3473% | 6.3033% | 1.8997% | 0.6593% |
| basic 3 | 5.1557% | 5.1117% | 1.8997% | 0.6593% |
| first-page 1 | 3.5702% | 3.5313% | 1.5608% | 0.4437% |
| first-page 2 | 6.6395% | 6.6212% | 1.0373% | 0.5059% |
| first-page 3 | 5.9900% | 5.9717% | 1.0373% | 0.5059% |
| odd/even 1 | 5.7444% | 5.7340% | 0.7346% | 0.3638% |
| odd/even 2 | 6.4803% | 6.4627% | 0.6954% | 0.2315% |
| odd/even 3 | 6.4933% | 6.4830% | 0.7346% | 0.3638% |
| odd/even 4 | 1.7069% | 1.6893% | 0.6954% | 0.2315% |

The candidate footer ink Y bounds exactly match Word on all ten pages, including first, even, and
default footer slots. Every footer ROI and every whole page improved.

## Verification

- `VisualEvidenceFidelityRenderSourceTests`: 21/21.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh Word COM exports: 3/3 documents, 10/10 pages.
- Fresh FreeW composite renders: 3/3 documents, 10/10 pages.

## Process rule

Measure raw footer ink bounds across first, even, and default slots before changing page-frame
geometry. Rebuild the consuming FidelityRender artifact, then require footer ROI and whole-page gains
on the complete affected sequence. Keep normal and generated-page placement on one helper.
