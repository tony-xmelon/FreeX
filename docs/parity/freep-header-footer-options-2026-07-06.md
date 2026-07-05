# FreeP Header/Footer Options - 2026-07-06

## Scope

This slice deepens Insert > Header & Footer behavior in shared FreeP code.
WPF and Avalonia remain thin option collectors over `HeaderFooterCommandPlanner`.

## Improved

- Header/Footer apply options now include PowerPoint-style "Don't show on title
  slide" behavior. The shared planner detects title-layout slides and suppresses
  date, footer, and slide-number visibility on those slides when applying to all
  slides.
- Date/time options now distinguish auto-updating date fields from fixed literal
  date text. Auto mode writes a selected shared `datetimeN` field type; fixed
  mode writes literal text without a field run.
- WPF and Avalonia expose the same shared option shape and route application
  through the existing shared command path.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~HeaderFooterCommandPlannerTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~HeaderFooterDialogTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freep\FreeP.App.Avalonia.Tests\FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~HeaderFooterCommandRoutingTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Remaining

- PowerPoint-authoritative header/footer visual baselines remain deferred.
- Exact fallback layout heuristics and theme-specific visual tuning remain
  deferred.
