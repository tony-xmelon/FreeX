# FreeW and FreeP Avalonia titlebar identity — Wave 233 (2026-08-25)

## Scope

The WPF FreeW and FreeP shells show an app identity tile at the far left of the title bar before
the Quick Access Toolbar (QAT). The shared Avalonia frame reserved the same 34-DIP leading region,
but left it blank. This was a conspicuous cross-host chrome difference in every ribbon capture.

`SisterAppWindowFrameBuilder` now accepts an opt-in product badge descriptor. FreeW supplies its
active-theme `W` glyph and accent brush; FreeP supplies its active-theme `P` glyph and accent-dark
brush, matching their WPF shell palettes. The badge occupies the existing 22-DIP tile geometry and
keeps the QAT at its existing 34-DIP inset. FreeX does not opt in, so its titlebar remains unchanged.
No command routing, window behavior, or external dependency changes.

## Visual evidence

The canonical FreeW shell matrix was recaptured at 1500, 1100, 900, and 750 DIPs, including all
standard and contextual ribbon states. The FreeW Avalonia title bar visibly begins with the amber
`W` tile before Save, Undo, and Redo.

The canonical FreeP responsive matrix was recaptured for all eight primary tabs at 1280, 1100, 900,
and 750 DIPs. The FreeP Avalonia title bar visibly begins with the berry `P` tile before its QAT.
The change is stable across desktop and compact ribbon widths because the tile uses the previously
reserved titlebar inset.

## Verification

- Focused shared-titlebar contracts: FreeW `MainWindowShellFrameTests` — 7 passed; FreeP product-badge test — passed.
- `Generate-FreeWShellVisualEvidence.ps1`, `Test-FreeWShellVisualEvidence.ps1`, and generator `-Check` — passed (40 paired static and 32 paired contextual captures).
- `Capture-FreePResponsiveChrome.ps1`, `Test-FreePResponsiveChromeEvidence.ps1`, and capture `-Check` — passed (64/64 captures).
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build` — 2,178 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build` — 731 passed.

The repository default lane was also run. The new FreeP review-workflow assertion initially depended on
the local Windows account name; the fixture now sets its author deterministically and the focused test
passes. The remaining default-lane failures are outside this titlebar change: 30 WPF host-logic clipboard
tests receive `CLIPBRD_E_CANT_OPEN` even though the shared test helper already retries 20 times and no
clipboard-owner window is present, and one model timing test passes when rerun in isolation. The titlebar
and application-specific suites above are green; the clipboard issue is retained as a Windows test-host
environment limitation rather than masked by a product-code change.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
