# FreeW Avalonia adaptive ribbon and Print Layout ruler — Wave 228 (2026-08-25)

## Scope

This slice aligns two visible FreeW Avalonia workspace behaviors with the desktop WPF host:

- Print Layout now shows its backed horizontal and vertical ruler on startup. WPF already starts with
  the ruler visible, and the Avalonia View > Ruler command remains available to hide or show it.
- The Avalonia ribbon now opts into the shared renderer's progressive responsive states. At constrained
  widths, a group proceeds through full, compact, and icon-only presentations before becoming an
  overflow flyout.

No command registration or document-editing behavior changed, and this uses the existing shared
`AvaloniaRibbonRendererOptions.EnableIntermediateGroupPresentations` capability that FreeP already
uses. It introduces no external dependency.

## Visual evidence

At 900 DIPs, the refreshed Insert ribbon retains its actual Tables, Illustrations, Links, Header &
Footer, Text, and Symbols controls instead of collapsing those groups directly to generic flyouts.
Home keeps compact labeled groups where the available width requires an icon-only presentation.

The canonical FreeW evidence was recaptured at 1500, 1100, 900, and 750 DIPs, including all eight
contextual fixtures. The capture harness now settles two layout/render turns before saving a frame;
adaptive presentation selection can invalidate the first layout pass, and the extra turn prevents a
blank initial-Home evidence frame.

`Test-FreeWShellVisualEvidence.ps1` reports 40 paired static captures and 32 paired contextual
captures, all current and complete.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release` — 2,178 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~FreePRibbonContextSourceTests"` — 2 passed.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlidePanePolicySourceGuardTests"` — 1 passed.
- `Generate-FreeWShellVisualEvidence.ps1`, `Test-FreeWShellVisualEvidence.ps1`, and the generator's `-Check` mode all passed.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
