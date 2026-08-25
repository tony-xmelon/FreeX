# FreeW Avalonia Home adaptive density — Wave 231 (2026-08-25)

## Scope

This slice improves FreeW Avalonia Home-ribbon discoverability at desktop widths. The shared Avalonia
renderer already supports compact icon presentations, but the portable Font and Paragraph definitions
were left at default full-or-collapsed sizing. At 1500 DIPs, Font consequently consumed a broad
text-labelled lane while Paragraph and Editing had already become flyouts.

The Avalonia-only Font and Paragraph groups now opt into `RibbonGroupSizing.OfficeIconAdaptive`.
They retain dense, direct icon controls before collapse, matching the WPF Home ribbon's command-dense
shape more closely. WPF definitions, command IDs, command routing, and overflow menus are unchanged;
this introduces no external dependency.

## Visual evidence

At 1500 DIPs, the refreshed Avalonia Home ribbon keeps Font and Paragraph controls directly visible,
including list, alignment, and formatting commands, rather than presenting Paragraph as one collapsed
tile. At 1100 and 900 DIPs, the same groups compact or collapse without clipping, preserving the
constrained-width fallback path.

The canonical FreeW shell matrix was recaptured at 1500, 1100, 900, and 750 DIPs, including all eight
contextual fixtures. `Test-FreeWShellVisualEvidence.ps1` reports 40 paired static captures and 32
paired contextual captures, all current and complete.

## Verification

- Focused FreeW ribbon-definition sizing test — 1 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release` — 2,178 passed.
- Avalonia shell harness, four WPF `FreeW.RibbonShot` width passes, `Generate-FreeWShellVisualEvidence.ps1`, `Test-FreeWShellVisualEvidence.ps1`, and generator `-Check` — passed.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
