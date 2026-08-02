# FreeW WPF table auto-fit authored-width distribution

## Scope

Word treats an absent `w:tblLayout` as content auto-fit even when the table also carries an authored
`w:tblW` and equal `w:tblGrid` hints. FreeW imported that semantic as `AutoFit=Contents`, but the WPF
renderer disabled content measurement whenever either width payload was present. The result was a fixed,
equal-width table with extra wrapping.

The WPF table resolver now measures each column's unwrapped content for `AutoFit=Contents`, then scales
the measured distribution to the authored preferred table width. When no preferred width is present, an
authored complete grid supplies the target width; tables without either payload retain the existing
fit-to-content and available-page-width behavior. Fixed-layout tables are unchanged.

## Provenance

- Fixture: `freew-fidelity-corpus/files/tables/04-custom-borders.docx`
- Fixture SHA-256: `B99A7E84381011B711A1006D4EF7219016CFF11CCBBB92562C00BD84D9A46227`
- Word 16: isolated visible COM `ExportAsFixedFormat`, read-only open, short paths under `C:\fwv`
- Word PNG: 816x1056, SHA-256
  `DFECBE76ECA76A371A1ECA9C4D1AD381650B85C1300F70038C460CE08FD8B854`
- Baseline WPF PNG SHA-256:
  `E8AD17C27775C1892930A6C2B1C8040E771F815F7FDDB6EEA7C2654BAB8C8E76`
- Candidate WPF PNG SHA-256:
  `9F143A0E0C468460382C1A5874310387FB434C6EED1109D5A763758E4D098A39`

Word reached ready state, opened the exact fixture, exported, closed, and quit its owned process. The
temporary PDF was removed after rasterization.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| Whole page | 1.1667% | 1.1033% | -0.0634 pp |
| Table `(80,80)-(600,270)` | 10.1585% | 9.6059% | -0.5526 pp |
| `wordart-watermark-stress` control | 0 changed pixels | 0 changed pixels | byte-stable |

The candidate shifts the first two column boundaries toward Word's content-driven layout while preserving
the authored 360-point total width. Remaining error is primarily Word/WPF text rasterization and per-edge
border antialiasing.

## Verification

- Focused auto-fit tests: 2/2
- `DocumentViewRoundTripTests`: 56/56
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Exact candidate render: 1/1 page
- Word COM export: 1/1 document, clean owned-process exit

## Process rule

For auto-fit tables, treat `tblGrid` as an initial width hint rather than a fixed-layout override. Measure
content on the effective renderer path, preserve the authored total width, and require target ROI plus
whole-page improvement with an unrelated page remaining byte-stable.
