# Wave 64 FreeX Formula Reference Grip Parity

## Scope

This slice closes the cross-sheet formula-reference grip workflow between the WPF and Avalonia
FreeX shells. An existing formula edit can remain open while the user switches to a quoted,
qualified referenced worksheet; the reference overlays and grips follow that worksheet; dragging a
grip rewrites only the selected area while preserving the qualifier; commit targets the original
formula cell; calculation and native JSON save/reopen retain the new formula and value.

## Implementation

- Both shells preserve existing formula Edit mode during a referenced-sheet tab switch.
- WPF keeps the source edit address when committing from a different visible sheet and refreshes
  the reference overlays after the switch.
- Avalonia prefers the active Formula Bar editor for reference highlights and clears a stale inline
  editor after a successful Formula Bar commit.
- Avalonia's managed scenario uses command-routed seed edits, then verifies source-cell commit,
  calculation, and native JSON round-trip.
- The FreeX LinuxInteractiveDocker probe creates a real second worksheet, performs the tab switch,
  drags the second reference grip through X11, commits through the Formula Bar, and checks formula,
  result, and clean-save postconditions.

## Verification

- WPF build: `dotnet build tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:quiet` - 0 warnings, 0 errors.
- WPF focused test: `QualifiedFormula_SwitchesToReferencedSheet_ResizesAndRoundTrips` - 1 passed.
- Avalonia focused lane: `R92_FormulaReferenceGripEditingTests` - 2 passed.
- Linux X11 lane: `Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector formula-reference-grip -Port 6084` - 1 passed.
- Latest physical evidence: `artifacts/linux-interactive/freex/interaction-validation/20260730T054406Z/x11-validation/`.

## Residual limitations

This is a bounded formula-reference workflow slice, not a claim that every Avalonia interaction or
visual surface is fully at WPF parity. The shared integration worktree contains other workers'
FreeW/FreeP changes; this commit intentionally excludes them.
