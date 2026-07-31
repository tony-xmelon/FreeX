# FreeW imported Word default line spacing parity (2026-07-31)

## Scope

`header-footer-basic.docx` omits `w:docDefaults` and every paragraph/style omits
`w:spacing/@w:line`. Word still applies its application default 1.15-line cadence. FreeW treated the
model's inherited 1.15 value as non-authoritative and let WPF use its natural single-line box, which
packed too much body content onto each page.

The DOCX reader now records that the document came through WordprocessingML. WPF consumes that
provenance only when the resolved paragraph has no explicit or non-default line rule. Model-authored
documents retain natural line layout, and explicit single/multiple rules remain authoritative. A
renderer-local 1.10 line-box calibration accounts for the difference between Word's implicit Calibri
line box and WPF's `FontFamily.LineSpacing` metric.

## Provenance

- Fixture SHA-256: `545DC2AB238FF33495C4576CBA8C017955F1A1A03728A0247F5A11D6C290CBFE`
- Word COM export: `ExportAsFixedFormat`, 816x1056 PNG pages
- Word page SHA-256: `3B1BF1DC...`, `4CB537DA...`, `8792116D...`
- FreeW path: fresh Release `FreeW.FidelityRender`, composite WPF capture, 816x1056

Temporary Word package probes proved the semantic owner: adding explicit `w:line="276"`
(`lineRule="auto"`) reproduced the original Word cadence, while explicit `w:line="240"` produced the
expected tighter single-line control.

## Evidence

Mean absolute RGB channel delta against the matching Word pages:

| Page | Before | After | Change |
|---|---:|---:|---:|
| 1 | 25.1060 | 21.4868 | -3.6192 |
| 2 | 27.0097 | 19.1463 | -7.8634 |
| 3 | 16.7290 | 15.8915 | -0.8375 |
| Average | 22.9482 | 18.8415 | -4.1067 |

Pixels whose maximum channel delta exceeds 32 also improved on every page:
`14.2751% -> 12.3571%`, `15.3697% -> 11.4779%`, and `9.5396% -> 9.5095%`.

Pagination now matches Word exactly: body items 1-10, 11-21, and 22-30 occupy pages 1, 2, and 3.
Raw line bands on pages 2 and 3 start at the same Y for the first two body lines and stay within five
pixels through the final paragraph. Footer ROIs are byte-stable; header mean deltas are stable or
slightly improved (`1.3781`, `6.9432 -> 6.9015`, `6.9968 -> 6.9498`).

## Verification

- `DocDefaultsSpacingReaderTests`: 14/14
- `LineHeightMultipleTests`: 4/4
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh candidate render: 3/3 pages

The final focused test counts are updated in the integrating commit verification.
