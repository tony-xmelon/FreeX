# FreeX Cross-Workbook Pointing, Wave 90

Date: 2026-08-01

## Architecture gap

Both hosts previously treated the focused workbook window as the owner of a formula point-mode
gesture. WPF had a live `WorkbookWindowRegistry`, but its contract only described ordinary window
management and had no formula-edit owner. Avalonia had its own local window registry and no route
from a source window to an edit owned elsewhere. The shared range planner could qualify a different
sheet, but neither host carried the source workbook identity through the gesture.

That made a real second-workbook selection impossible: the owner could not receive the source
`GridRange`, external token qualification was lost, and Enter/Escape in the source window could not
finish or cancel the owner session.

## Implemented contract

`FormulaPointModeSelection` carries the source `WorkbookId`, workbook name, sheet name, and real
`GridRange`. `IFormulaPointModeWorkbookWindow` exposes only the host-neutral operations needed by
the resolver: active edit ownership, selection acceptance, source selection chrome, commit, and
cancel. `FormulaPointModeWorkbookResolver` searches the live registry, routes selection replacement
or append to the active owner, and routes Enter/Escape back to that owner.
It also routes source-window F4 to the owner's reference cycler, consuming F4 only when another
live point-mode owner exists so ordinary Repeat Last behavior remains available otherwise.

WPF and Avalonia now register/expose this contract through their existing workbook-window
registries. The source window paints its own selected range while the owner updates its live formula
editor. External references are emitted as, for example,
`'[Source.xlsx]Input Data'!B2`; the owner does not pass a foreign `SheetId` to its local worksheet
selection validator. Point-mode drag, Ctrl/meta append, F4, commit, and Escape use the same route.

## Exact proof

Focused tests passed on branch `codex/agent-freex-cross-workbook-wave90-20260801`:

```text
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R90_CrossWorkbookFormulaPointModeTests"
Passed: 5, Failed: 0

dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R90_CrossWorkbookFormulaPointModeWpfTests"
Passed: 2, Failed: 0

dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R90_CrossWorkbookFormulaPointModeAvaloniaTests"
Passed: 2, Failed: 0
```

The shared tests prove owner resolution, source-chrome handoff, commit/cancel routing, external
replacement and append formatting, F4 preservation of the external workbook qualifier, and the
no-owner F4 fall-through. Each
host pair creates two live workbook windows with distinct identities and proves source selection,
replacement, source-window F4, append, commit, and Escape restoration against the real host edit
session.

Release builds also passed for `FreeX.App.Presentation`, `FreeX.App.Host`, and
`FreeX.App.Avalonia` with `dotnet build --configuration Release --no-restore`.

## Honest residuals

The tests drive the production host routing seam rather than synthesizing native mouse coordinates;
they do not replace a full visual/manual Excel comparison of every pointer path. Cross-workbook
formula evaluation, file-link refresh, and persistence are outside this slice. The implementation
does not add cached-link behavior or a local-sheet approximation.
