# FreeW Avalonia Home Formatting ribbon — Wave 234 (2026-08-25)

## Scope

The WPF FreeW Home ribbon exposes a **Formatting** group with **Reveal Formatting** between
**Styles** and **Editing**. Avalonia had omitted that topology section despite already having the
same stateful command, registry callback, and formatting pane. The omission is removed for the
portable profile, restoring the WPF group order without changing command behavior or adding an
external dependency.

The canonical-profile and command-inventory contracts now list the group in both profiles. The
FreeW shell-evidence freshness inputs also include the capability and ordinary ribbon-definition
sources, so a future change to this visible topology invalidates stale captures.

## Visual evidence

The 72-capture Avalonia FreeW shell matrix was regenerated. In
`avalonia/shell-1500x720-home.png`, the Formatting group and its Reveal Formatting control now
appear directly after Styles and before Editing; the same section is present at 1100, 900, and 750
DIPs. This matches the WPF Home ordering in `wpf/<width>/ribbon-1-Home.png`.

## Verification

- `dotnet test freew/FreeW.Ribbon.Definitions.Tests/FreeW.Ribbon.Definitions.Tests.csproj --configuration Release` — 64 passed.
- `Generate-FreeWCanonicalRibbonEvidence.ps1 -Check` — passed.
- `Generate-FreeWCommandInventory.ps1 -Check` — passed.
- `Test-FreeWShellVisualEvidence.ps1` — passed (40 static and 32 contextual paired captures).
- `Generate-FreeWShellVisualEvidence.ps1 -Check` — passed.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
