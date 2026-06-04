# XPS Extensionless Explicit Format

## Scope

When the user chooses XPS in the PDF/XPS save dialog but enters an extensionless path, export should normalize to
`.xps` instead of falling back to the inferred PDF default.

## Tasks

- [x] Add a failing planner test for explicit XPS format with an extensionless path.
- [x] Add an explicit-format `ExportPlanner.PlanExport` overload and route the save-dialog filter choice through it.
- [x] Update export architecture and parity docs.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "PlanExport_AppendsXpsExtensionForExplicitExtensionlessXpsRequests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because no explicit-format overload existed.

## Architecture Decisions

- Path extension inference remains available for direct callers, but the WPF save-dialog path is authoritative when the user explicitly selects PDF or XPS.
- Extensionless explicit XPS requests normalize to `.xps`; extensionless inferred requests keep the PDF default.
