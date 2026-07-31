# FreeP Wave 89: multi-selection resize and rotate X11 evidence

Date: 2026-08-01

This slice adds a dedicated, deterministic physical Avalonia/X11 validation for
FreeP multi-selection handles. The runner creates
`freep-multiselect-x11-wave89-fixture.pptx` from the existing autoshape corpus,
retaining exactly two shapes named `Wave89 Left` and `Wave89 Right` at fixed EMU
bounds. The probe selects them with two real pointer clicks, using Ctrl for the
second click, then drags the shared SE resize handle and shared rotate handle.

The probe retains calibration, selection/drag screenshots, window state, PPTX
copies, SHA-256 files, and parsed `ppt/slides/slide1.xml` geometry reports. The
package assertions are exact:

- baseline: `(200,180,200,120)` and `(500,300,200,120)` DIP, both at 0 degrees;
- resize: `(200,180,240,182)` and `(560,362,240,182)` DIP, both at 0 degrees;
- rotate: `(471,91,240,182)` and `(289,451,240,182)` DIP, both at 90 degrees.

The two-DIP vertical difference from the ideal drag target is the deterministic
result of mapping the 720-DIP slide into the 480-pixel physical X11 viewport.

After saving the rotated state, one physical Ctrl+Z must restore and save the
exact resize state. An active rotate drag is then canceled with Escape and a
stale pointer release; a second active drag minimizes and restores the real owner window
to force pointer-capture loss before the stale release. Both cancellation routes require
the exact pre-cancel package hash and parsed geometry.

## Files

- `tools/Run-FreePMultiSelectionX11Validation.ps1`
- `tools/LinuxInteractiveDocker/run-freep-multiselect-x11-wave89-probe.sh`
- `tools/LinuxInteractiveDocker/freep-multiselect-x11-wave89-validation.schema.json`
- `freep/FreeP.App.Presentation.Tests/Wave89MultiSelectionEvidenceContractTests.cs`

The PowerShell runner performs strict manifest header, row-order, summary,
calibration, artifact, package-state, and physical-evidence checks. The JSON
schema is retained beside the probe; the managed tests parse the schema and
assert the probe contains the real-input and exact-package gates.

## Verification

Foreground static verification and the focused managed contract tests passed
3/3. Final physical Docker/X11 verification passed 9/9:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Management.Automation.Language.Parser]::ParseFile('tools/Run-FreePMultiSelectionX11Validation.ps1',[ref]$null,[ref]$null) | Out-Null"
```

The focused managed test command is:

```powershell
dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~Wave89MultiSelectionEvidenceContractTests --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

The exact successful orchestrator command is:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreePMultiSelectionX11Validation.ps1 -Port 6108 -SkipPublish -SkipImageBuild
```

Evidence is retained under
`artifacts/freep-multiselect-x11-wave89-20260801/` and the harness session
directory printed by the runner.
