# FreeX Wave 19 Print Preview parity

## Scope

This slice aligns the Avalonia Print Preview surface with the committed WPF evidence while keeping native print routing, keyboard behavior, accessibility hooks, and the existing parity fixture intact.

## Visual causes addressed

- The Avalonia surface now uses the WPF capture's 1106x663 client geometry inside the 1120x700 evidence frame.
- The settings rail, print toolbar, and page padding consume shared planner constants; WPF consumes the same rail and toolbar control metrics.
- Avalonia uses a scrollable preview viewer with the WPF page boundary and black page edge.
- The top toolbar uses the WPF chrome color, spacing, print-button width, and an overflow menu for the close action instead of a clipped close button.
- The find bar uses the compact blue navigation glyph treatment and aligned field spacing from the WPF capture.

## Evidence

- WPF: `docs/parity/dialog-visual-assets/wpf-capture/dialog.PrintPreview.png`
- Avalonia: `docs/parity/dialog-visual-assets/avalonia-capture/dialog.PrintPreview.png`
- Both captures are 1120x700 px and nonblank. A fresh WPF full capture on 2026-07-27 reproduced the committed 57,998-byte PNG byte-for-byte; a fresh Avalonia focused production capture reproduced the promoted 49,716-byte PNG byte-for-byte. Both use the Print Preview parity fixture.
- Before triage score: `0.157272`.
- After triage score: `0.039808`.
- Score reduction: approximately 75%.
- After metric components: sample mean delta `0.028640`, luma delta `0.002742`, non-background delta `0.008147`; no dimension mismatch.

## Verification

- Presentation planner: 7 passed, 0 failed.
- Avalonia Print Preview source contracts: 3 passed, 0 failed.
- WPF Print Preview source contract: 1 passed, 0 failed.
- Focused Avalonia capture: completed successfully and wrote a 49,716-byte PNG plus manifest.

All test/build commands used `--disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`; no build-server shutdown or machine-wide process cleanup was performed.

## Residuals

The remaining metric is primarily platform rendering and native control/icon rasterization: WPF's native DocumentViewer toolbar glyphs and Avalonia's equivalent glyphs are not byte-identical. The WPF evidence was unchanged because this slice changes shared planner consumption and Avalonia presentation only; its committed PNG remains the comparison baseline.
