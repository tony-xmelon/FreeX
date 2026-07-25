# Table Page Composition Source Authority

## Problem

The cached Microsoft Word baseline for `table-page-composition-stress.docx` is a three-page
document. The current generated fixture had drifted to `NUMPAGES=2`, page-1 wording through
segment 4, page-2 wording through segment 8, and a closing statement that required two trusted
rows. That made the WPF/Avalonia evidence document a different payload from the Word baseline on
pages 2 and 3.

## Restored Payload

- `NUMPAGES` fallback value is `3`.
- Segments 1-2 retain page-1 composition text.
- Segments 3-6 use the page-2 repeated-header text.
- Segments 7-8 use the page-3 caption/closing-text wording.
- The closing paragraph requires three trusted rows.
- The scenario catalog and visual runners require three outputs, including Avalonia page 3.

## Verification

The Release `FreeW.FidelityRender --generate-f2-corpus` output was compared directly with the
cached Word source package. All 36 table-cell text values matched in order. The WPF composite
renderer emitted `table-page-composition-stress_p1.png` through `_p3.png` at 816x528, and page 2
now visibly contains the same repeated-header wording as the Word reference.

Focused verification passed:

- `FreeW.App.Presentation.Tests`: 134/134 planner and runner-script tests.
- `FreeW.PageLayoutShot` Release build: clean.
- `FreeW.App.Avalonia.Tests` source guard: 4/4.
- `FreeW.FidelityRender` Release build: clean.

## Current Production Status

The Avalonia production table path now passes the same shared leading-content estimate used by
`BuildTableLayoutPlans(document)` and the WPF production path. The stress fixture's shared plan is
therefore consumed at the real table block index, yielding source rows `[0,1,2]`, `[3,4,5,6]`, and
`[7,8]` with repeated row `0` on pages 2 and 3 and keep-together rows `3` and `6` preserved on
page 2. Avalonia also now honors authored `Exact`/`AtLeast` row-height semantics when measuring and
rendering, so wrapped cell text cannot create host-only page breaks. Focused WPF and Avalonia host
tests assert rendered content on all three pages.

## Visual Status

The matched Word source baseline is retained. Current WPF mean RGB channel deltas (0-255) are
18.1477 for page 1, 23.4317 for page 2, and 17.8980 for page 3. The former WPF pages 2-3 used a
different serialized payload, so their lower raw deltas are not a valid before/after visual
comparison. Remaining physical Linux evidence is a packaged foreground capture of this three-page
fixture and an image-level comparison against the cached WPF/Word pages. The host-level tests prove
the page composition and nonblank third-page content, but do not replace that physical Linux capture.
