# FreeX Avalonia Parity Wave 144: PivotTable Options Display

Date: 2026-08-04
Surface: `dialog.PivotTableOptions.Display`
Branch: `codex/avalonia-parity-wave144-freex-20260804`

## Finding

The paired WPF/Avalonia evidence had exact logical dimensions (`520x500`) but ranked the Display tab at triage `0.069304`. A fresh Linux/Xvfb capture of the current Avalonia source proved a fixture-state mismatch: WPF's parity fixture explicitly uses `PivotStyleLight16` with banded rows enabled, while Avalonia's `EnsureParityPivot()` relied on the model default for both values. The WPF capture showed `Banded rows` checked; the current Avalonia capture showed it unchecked.

## Change

- Seed the Avalonia parity PivotTable with `PivotStyleGalleryPlanner.DefaultStyleName` and `ShowRowStripes = true`, matching the WPF fixture and shared style contract.
- Keep the existing Display-tab spacing compensation and shared `PivotOptionsPlanner` state flow unchanged.
- Add focused source tests covering the fixture state, all Display values, and the WPF-localized Display labels.

## Evidence

The valid refreshed Avalonia PNG is committed at `docs/parity/dialog-visual-assets/avalonia-capture/dialog.PivotTableOptions.Display.png`, with wave-144 provenance in the Avalonia manifest. The regenerated summary reports:

- WPF: `520x500`, nonblank
- Avalonia: `520x500`, nonblank
- Logical dimensions: exact match
- Triage score: `0.058731` (down from `0.069304`; summary markdown rounds this to `0.059`)
- Paired captured surfaces: `94`
- Nonblank failures: `0`
- Paired dimension mismatches: `0`

The capture remains an Avalonia-only Linux/Xvfb render; the WPF counterpart is the retained paired reference. No About files were changed.

## Verification

- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~PivotOptionsParitySourceTests`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-LinuxParityCapture.ps1 -OutputDir artifacts\avalonia-parity-wave144-display-after -PublishDir $env:TEMP\FreeX-wave144-parity-publish -ContainerName freex-wave144-display-after -SurfaceId dialog.PivotTableOptions.Display -Width 520 -Height 500 -TimeoutSeconds 180`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Generate-DialogVisualEvidenceSummary.ps1`
