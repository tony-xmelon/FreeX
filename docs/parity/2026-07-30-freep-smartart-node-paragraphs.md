# FreeP SmartArt Node Paragraph Boundaries

## Scope

SmartArt node text can contain multiple authored DrawingML `a:p` elements. The reader previously flattened every text run with spaces, which lost paragraph boundaries used by name-and-title org charts and by later editing/save operations.

## Change

- `PptxPackageReader` now preserves `a:p` boundaries as newline-separated model text and preserves explicit `a:br` breaks.
- The shared SmartArt live layout creates one text paragraph per model line for ordinary boxes and org-chart boxes.
- The existing SmartArt data-part rewrite path emits the preserved lines as separate `a:p` elements.

## Verification

- `FreeP.App.Presentation.Tests`: 304 SmartArt layout/editing tests passed.
- `FreeP.App.Host.Tests`: 210 SmartArt tests passed.
- The focused regression verifies import, live layout, rewrite, save, and reread behavior for `Jane Doe` plus `Chief Executive Officer`.

This is a functional/package parity slice. It makes no visual-baseline claim beyond preserving the authored text structure for the existing renderers.
