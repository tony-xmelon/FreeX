# Avalonia Page Setup parity: Wave 119

## Scope

This slice closes the bounded FreeX `dialog.PageSetup` parity gap identified in the
Wave 119 audit. The Avalonia Margins tab now follows the WPF structure with six
editable margin fields: Left, Right, Top, Bottom, Header, and Footer. Shared
planner/model code remains the source of truth for field composition, surface
population, validation focus, and initial focus.

The parity capture fixture now explicitly sets the Page and Sheet defaults shared
by both hosts: Landscape, Letter, Normal margins, 90% scaling, Over-then-down,
print area `$A$1:$G$9`, and row/column print titles `$1:$1` / `$A:$A`.

## Implementation

- `PageSetupDialogPlanner` exposes shared automation IDs for all margin fields.
- `PageSetupDialogPlanner.BuildFields` composes separate Avalonia margin values
  in WPF order and preserves the legacy combined margin input for compatibility.
- Avalonia uses the existing localized `PageSetup_Left`, `PageSetup_Right`,
  `PageSetup_Top`, and `PageSetup_Bottom` resource keys.
- Validation routes select the first invalid individual margin field, while the
  `Margins` initial-focus route selects the Left field on both hosts.
- `ParityDemoWorkbookFactory` explicitly initializes the shared Page Setup state
  so captures do not depend on host defaults.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~PageSetupDialogPlannerTests`
  - 15 passed.
- `dotnet test tests/FreeX.App.Services.Tests/FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~ParityDemoWorkbookFactoryTests`
  - 4 passed.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AvaloniaPageSetupDialogParitySourceTests`
  - 1 passed; the Avalonia project and dependencies built successfully.
- `git diff --check` passed.

## Capture status

The previous worker started a bounded Docker capture named `freex-wave119-baseline`
but was shut down while it was still running. At takeover, the container no
longer existed and no capture artifacts were present; `docker ps -a --filter
name=freex-wave119-baseline` returned no rows. No new capture was started because
this worktree does not contain a targeted Page Setup capture command and an
unbounded retry could leave a container/process behind. The remaining visual
evidence requirement is therefore a fresh WPF/Avalonia Page Setup capture from
the integration harness, with a hard timeout and cleanup owned by the integrator.
