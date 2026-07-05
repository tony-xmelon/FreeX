# FreeP Header/Footer Inherited Layout Geometry - 2026-07-06

## Scope

This slice tightens shared Header/Footer placeholder creation after the WPF and
Avalonia option surfaces were aligned. It keeps renderer policy thin by stamping
layout/master placeholder geometry in `HeaderFooterCommandPlanner`.

## Improved

- Created date, footer, and slide-number placeholders now copy concrete
  layout-placeholder geometry when a matching placeholder exists.
- Created placeholders fall back to matching master-placeholder geometry when
  the slide layout omits the header/footer slot.
- Computed bottom-row fallback geometry remains the last resort when neither
  layout nor master provides usable extents.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers --filter "FullyQualifiedName~HeaderFooterCommandPlannerTests" -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Remaining

- PowerPoint-authoritative header/footer visual baselines still require a
  PowerPoint COM-capable machine.
- Theme-specific visual tuning remains deferred.
