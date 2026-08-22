# Avalonia Parity Wave179: FreeX Managed Ribbon Bindings

Date: 2026-08-22
Application: FreeX Avalonia interaction-validation host
Display: 1280x820 at 96 DPI
Base revision: `22b5fcefd57bb9fd2c4c7d53ae390b0aecd4934c`

## Residual Closed

Wave178 documented that the broad managed `ribbon-bindings` phase was bypassed
after the owned Docker container remained near-idle. The runner's managed calls
were using the packaged `FreeX` Application host by default. That host does not
own the `--interaction-validation` manifest route; the route is implemented by
`FreeX.ParityCapture.Avalonia`.

Wave179 makes the host boundary explicit. Managed core, context-menu, dialog,
and ribbon batches use `-HostMode Validation`; the physical X11 phase remains
explicitly `-HostMode Application`. Managed provenance now names the validation
publish directory and image, while physical evidence remains physical X11
evidence and is not credited from this managed lane.

## Bounded Evidence

The focused command arguments were:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-LinuxInteractiveDocker.ps1 `
  -Action Start -App FreeX -HostMode Validation -Port 6189 `
  -OutputDir $env:TEMP/FreeX-Wave179-focused `
  -SessionMetadataPath $env:TEMP/FreeX-Wave179-focused/session.json `
  -SkipImageBuild `
  -AppArgument @("--interaction-validation", "/work/validation", "--interaction-validation-dialog-start", "0", "--interaction-validation-dialog-count", "0", "--interaction-validation-ribbon-start", "0", "--interaction-validation-ribbon-count", "0", "--interaction-validation-core-section", "ribbon-bindings")
```

The owned container became ready in the bounded runner startup window and wrote:

`%TEMP%/FreeX-Wave179-focused/freex/sessions/20260822T114115793Z/validation/interaction-validation.json`

Observed manifest evidence:

- `validationSection=ribbon-bindings`
- `641` `ribbon-command` rows
- `74` `ribbon-collapsed-group` rows
- `715` total rows
- `715` passed, `0` failed
- ribbon catalog: `605` distinct command IDs, with all `605` selected by the section contract
- image: `sha256:6ae31faefc71f4d75b505f85e5ca5a63dc0e66f73c6707eb8ce2f7e75b54a4bc`

The exact owned container was stopped after the run:

```text
freex-linux-interactive-freex-6189
```

The source/behavior checks also require the 641/74 row contract and the
validation-host selection. No row was removed, and no managed row is used as a
substitute for the Wave178 physical X11 claim.

## Verification

```powershell
dotnet test tests/FreeX.App.Services.Tests/FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~LinuxFreeXInteractionValidationToolTests --logger "console;verbosity=minimal"
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~RibbonBindingsSection_EmitsAllAuthoritativeRows --logger "console;verbosity=minimal"
```

The full exhaustive physical `all` lane remains the Wave178 authority:
`32/32` physical X11 rows, with no managed evidence substituted.

## Honest Residual

This focused run proves the corrected managed ribbon-binding route and its
authoritative row coverage. It does not rerun the complete 641-command physical
interaction matrix; the physical claim remains exactly the Wave178 32-row X11
manifest until a new full physical run is intentionally made.
