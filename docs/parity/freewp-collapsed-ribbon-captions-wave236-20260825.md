# FreeW and FreeP Avalonia collapsed-ribbon captions — Wave 236 (2026-08-25)

## Scope

At narrow widths, Avalonia collapsed ribbon groups allowed their captions to wrap inside a fixed-width
tile. Long labels such as FreeW **Accessibility** and FreeP **Transition to This Slide** therefore
wrapped or clipped, reducing the room available to their representative icon and chevron. WPF uses a
fixed 58-DIP, single-line caption lane with character ellipsis.

The shared Avalonia ribbon renderer now uses that same no-wrap, character-ellipsis, 58-DIP treatment.
The change is presentation-only: collapsed groups, commands, flyouts, key tips, and adaptive fit
decisions are unchanged. It has no external dependency and applies consistently to FreeW and FreeP.

## Visual evidence

The FreeW 72-capture shell matrix and FreeP 64-capture responsive matrix were regenerated. In
FreeW `shell-750x720-review.png`, compact Review labels remain single-line rather than wrapping
mid-word. In FreeP `750/avalonia/full/ribbon.transitions.png`, the transition tile uses a single,
trimmed caption lane and preserves the icon/chevron cluster.

## Verification

- Focused shared renderer caption contract — 1 passed.
- `dotnet test tests/Free.Shared.Ribbon.Tests/Free.Shared.Ribbon.Tests.csproj --configuration Release --no-build` — 796 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build` — 2,178 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build` — 732 passed.
- `Test-FreeWShellVisualEvidence.ps1` — passed (40 static and 32 contextual captures).
- `Generate-FreeWShellVisualEvidence.ps1 -Check` — passed.
- `Capture-FreePResponsiveChrome.ps1` — captured 64/64.
- `Test-FreePResponsiveChromeEvidence.ps1` — passed 64/64.
- `Capture-FreePResponsiveChrome.ps1 -Check` — passed.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
