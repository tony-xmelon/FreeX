# FreeP Avalonia responsive 750-DIP breakpoint — Wave 235 (2026-08-25)

## Scope

The FreeP responsive-chrome contract includes 750 DIPs, but the Avalonia MainWindow previously set
an 800-DIP minimum width. The 750-DIP full captures therefore rendered at 800 DIPs while the client
artifacts were cropped to 750, masking the real compact-ribbon breakpoint. The Avalonia window now
accepts a 750-DIP minimum width, matching the documented capture width and the WPF responsive lane.

`AvaloniaWholeWindowVisualEvidenceCapture` now verifies the visible `ClientSize.Width` after layout
and fails the capture if it differs from the requested logical width. This prevents future minimum-size
clamping from being represented as a valid cropped evidence artifact. No command behavior or external
dependency changed.

## Visual evidence

All 64 responsive WPF/Avalonia captures were regenerated. At 750 DIPs, FreeP’s Avalonia Home full
capture is now 750×760 and uses the compact Home groups instead of an 800-DIP desktop render.
`750/avalonia/manifest.json` records an approximately 750.4-DIP semantic ribbon/client width due to
the headless renderer scale factor, with a 750-pixel output width.

## Verification

- Focused MainWindow minimum-width contract — 1 passed.
- Focused Avalonia capture-width guard contract — 1 passed.
- `Capture-FreePResponsiveChrome.ps1` — captured 64/64.
- `Test-FreePResponsiveChromeEvidence.ps1` — passed 64/64.
- `Capture-FreePResponsiveChrome.ps1 -Check` — passed.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
