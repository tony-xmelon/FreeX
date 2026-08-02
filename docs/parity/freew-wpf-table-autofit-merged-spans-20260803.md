# FreeW WPF table auto-fit merged-span constraints

## Scope

WPF content auto-fit previously returned no measured width plan when any table cell had a horizontal
`GridSpan`. The renderer then used the raw `tblGrid` widths even though an absent `w:tblLayout` told Word
to auto-fit the table. This was most visible in `06-merged-cells.docx`, whose two separate two-column
cells constrain different grid ranges.

The WPF resolver now measures single-column cells first, records each merged cell's minimum width, and
satisfies any unmet span constraint through the widest column already owned by that span. A merged cell
reserves the normal content inset for every occupied grid column. The completed distribution is then
scaled to the authored preferred table width, preserving the existing total-width contract.

## Provenance

- Corpus: all 11 committed fixtures under `freew-fidelity-corpus/files/tables`
- Target fixture SHA-256:
  `C1BCF2A812567A99DDAC7FECD37ED4BAA98E10218D6A975394529519E9E3AA68`
- Word 16: isolated visible COM exports, read-only opens, short paths under `C:\fwv`
- Word target PNG: 816x1056, SHA-256
  `2745A06DF2A70DAA20A8AECDFD59554D1697717DF6B15C022FE3F1E4DB4539AE`
- Baseline WPF PNG SHA-256:
  `CAFCC478A205D8D9D952AC3CA7D7C0BA2FA080510836D5A31173FB521A300253`
- Candidate WPF PNG SHA-256:
  `8C2B0405317C032646AC7D3A9BD595AB78D5B14E73628CD3D03FE01B32F80842`

All 11 Word exports reached ready, open, export, close, and owned-process quit. Temporary PDFs were
removed after rasterization.

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| `06-merged-cells` whole page | 1.1372% | 1.0644% | -0.0728 pp |
| Merged table `(80,90)-(740,320)` | 6.4444% | 6.0309% | -0.4135 pp |
| 11-page table-corpus mean | 1.0568% | 1.0502% | -0.0066 pp |

The other ten WPF corpus PNGs are SHA-256 byte-identical. In particular, the accepted authored-width
auto-fit behavior in `04-custom-borders` remains unchanged at 1.1033%.

## Rejected probes

- Removing the 14-DIP content allowance worsened the target from 1.6694% to 1.7537% and regressed the
  prior custom-border page. A 12/16-DIP bounded sweep confirmed 14 DIP as the current corpus optimum.
- Resolving every complete uniform explicit `color=auto` border payload to opaque black worsened the
  target from 1.6694% to 2.0096% and regressed nine other pages. Raw line color is not sufficient evidence
  across Word and WPF antialiasing paths.

Both probes were fully reverted before the accepted slice was scored.

## Verification

- Focused content-auto-fit tests: 3/3
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Exact WPF corpus render: 11/11 pages
- Exact Word COM corpus export: 11/11 documents
- Unaffected WPF corpus controls: 10/10 byte-stable

## Process rule

Treat merged cells as width constraints over grid ranges, not as a reason to disable auto-fit. Resolve
single-column minima before spanning minima, preserve the authored total width, and gate the complete
affected corpus. Do not infer stroke ownership from raw black/gray line appearance without pixel evidence.
