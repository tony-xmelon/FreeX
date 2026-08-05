# Avalonia parity Wave 162: FreeW paragraph geometry evidence

This slice owns the real-geometry residuals for the canonical Paragraph dialog states
`paragraph.initial`, `paragraph.populated`, `paragraph.tab-indents-and-spacing`, and
`paragraph.tab-line-and-page-breaks`. WPF remains the authority.

## Fresh canonical evidence

Fresh captures were taken from the rebased Wave162 worktree at 96 DPI:

- WPF route-local captures: `artifacts/freew-wave162-paragraph-geometry-20260805/wpf-*`.
- Avalonia route-local captures: `artifacts/freew-wave162-paragraph-geometry-20260805/avalonia-*`.
- Focused four-state comparison: `artifacts/freew-wave162-paragraph-geometry-20260805/compare-focused`.

The four WPF states are structurally identical for this geometry question. Their painted bounds are
`366x307@0,0` for the first three states and `366x290@0,0` for Line and Page Breaks. Avalonia paints
the same controls inside `343x283@12,12` and `343x265@12,12`, respectively. This is the known
12-DIP Avalonia inner viewport inset plus the corresponding available-size reduction; it is not a
tab-specific indent, spacing, or pagination control placement difference.

| State | Fresh changed pixels | Fresh mean delta | pHash | WPF bounds | Avalonia bounds |
| --- | ---: | ---: | ---: | --- | --- |
| `paragraph.initial` | 12.489% | 12.163 | 1 | 366x307@0,0 | 343x283@12,12 |
| `paragraph.populated` | 12.489% | 12.163 | 1 | 366x307@0,0 | 343x283@12,12 |
| `paragraph.tab-indents-and-spacing` | 12.489% | 12.163 | 1 | 366x307@0,0 | 343x283@12,12 |
| `paragraph.tab-line-and-page-breaks` | 8.213% | 10.125 | 7 | 366x290@0,0 | 343x265@12,12 |

The shared Avalonia dialog window already supplies a white client surface. The visible tab frame,
fields, labels, and action row remain at the expected 12-DIP inner positions in both captures, so
the bound difference is a client-surface/content heuristic mismatch rather than evidence that these
controls should move to the client origin.

## Rejected production probe

An uncommitted probe removed only Paragraph's 12-DIP outer tab margin. It made the reported Avalonia
bounds look closer at `366x283@0,0` and `366x265@0,0`, but shifted the actual controls and regressed
the WPF comparison:

| State group | Baseline changed / mean / pHash | Margin probe changed / mean / pHash |
| --- | --- | --- |
| Initial, populated, Indents and Spacing | 12.489% / 12.163 / 1 | 22.189% / 18.388 / 24 |
| Line and Page Breaks | 8.213% / 10.125 / 7 | 14.050% / 13.943 / 17 |

The probe was reverted. No shared-window or paragraph production margin change is safe based on this
evidence: it improves a painted-bounds statistic while moving already-aligned WPF controls and
increasing every image delta.

## Regression coverage

`ParagraphDialogVisualParityTests.Paragraph_dialog_preserves_Wpf_client_surface_inset` arranges the
dialog at the harness client size (`366x308`) and protects the observed WPF-equivalent tab geometry:
`12,12` origin and `343x253` Indents and Spacing surface.

## Residual

The four states remain genuine visual mismatches because the capture surfaces expose different
client/background edge geometry and native text/control rasterization. The residual is retained
explicitly; no threshold or classification was weakened.
