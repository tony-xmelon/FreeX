# FreeW Avalonia Print Layout ruler legibility — Wave 232 (2026-08-25)

## Scope

This slice aligns the visible FreeW Avalonia Print Layout ruler with the existing WPF ruler treatment.
The Avalonia ruler already provided backed margin, indent, and tab-stop interactions, but its 14-DIP
strip used very pale, unlabelled whole-inch ticks and was easy to miss.

The Avalonia-only renderer now uses a 16-DIP high-contrast ruler strip, half-inch minor ticks,
whole-inch major ticks, and whole-inch numeric labels on both axes. Existing ruler geometry,
markers, toggles, and hit-testing remain unchanged. No external dependency or command behavior was
added.

## Verification

- Focused ruler geometry/render tests — 2 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build` — 2,178 passed.
- `Generate-FreeWShellVisualEvidence.ps1`, `Test-FreeWShellVisualEvidence.ps1`, and generator `-Check` — passed (40 paired static and 32 paired contextual captures).

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
