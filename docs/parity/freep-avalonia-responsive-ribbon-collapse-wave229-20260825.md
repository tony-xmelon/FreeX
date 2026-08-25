# FreeP Avalonia responsive ribbon collapse — Wave 229 (2026-08-25)

## Scope

This slice aligns FreeP Avalonia's constrained-width ribbon interaction with the desktop WPF host.
FreeP had enabled the shared renderer's intermediate group presentations, leaving thin icon strips at
widths where WPF presents larger collapsed group tiles and their flyouts. The FreeP-only opt-in is
now removed, so groups progress directly from their full presentation to the renderer's normal
collapsed tile/overflow presentation.

At 900 DIPs on Insert and 750 DIPs on Home, the refreshed Avalonia captures now expose the same
whole-group tile/dropdown interaction shape as WPF. Commands remain registered and reachable
through the collapsed group; no command routing or document behavior changed. This is a local use
of existing renderer behavior and adds no external dependency.

The targeted keyboard test now asserts that the Charts group reaches the collapsed tile rather than
asserting the removed intermediate icon state. A separate review-mention test now fixes the
presentation author to `Alice Writer`, removing its accidental dependency on `Environment.UserName`.

## Visual evidence

The canonical responsive FreeP evidence was recaptured at 1280, 1100, 900, and 750 DIPs for all
eight primary tabs and both client and full-window captures. `Test-FreePResponsiveChromeEvidence.ps1`
reports 64 paired WPF/Avalonia captures, and the capture generator's `-Check` mode confirms that all
64 are current.

## Verification

- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~FreePRibbonContextSourceTests"` — 2 passed.
- Targeted collapsed-ribbon and deterministic-mention regressions — 2 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build` — 729 passed.
- `Capture-FreePResponsiveChrome.ps1`, `Test-FreePResponsiveChromeEvidence.ps1`, and `Capture-FreePResponsiveChrome.ps1 -Check` — passed (64/64 captures).

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
