# Wave 172: FreeP WPF visual-evidence capture host

Date: 2026-08-22

## Scope

This slice fixes the deterministic WPF visual-evidence host hang that left the
FreeP dialog/pane comparison without WPF authority. The investigation and fix
were limited to the WPF evidence hosts and their focused orchestration tests.
No catalog capture or canonical evidence promotion was performed.

## Root cause

Both WPF evidence paths constructed the production `MainWindow` with startup
recovery enabled. `MainWindow.Show()` raises the production `Loaded` handler,
which can synchronously enter the interactive autosave recovery workflow. An
isolated visual-evidence process cannot answer that modal prompt, so the host
stalled before `Show()` returned.

The instrumented `review.comments-pane.seeded` reproduction reached:

```text
Scenario callback entered review.comments-pane.seeded
Preparation created
Before owner.Show
```

The 20-second external timeout then expired. PID `27028` had not exited, the
progress log contained only `start review.comments-pane.seeded`, and no host
manifest or PNG was emitted. This isolates the failure to the source-owned
capture lifecycle rather than route preparation, rendering, shutdown, or the
host environment.

## Fix

- Both WPF evidence hosts construct `MainWindow` with
  `suppressStartupRecoveryOffer: true`. Production startup recovery remains
  unchanged.
- The dialog/pane host explicitly sets `WindowState.Normal` before `Show()`,
  matching the whole-window capture lifecycle and preventing the production
  maximized default from influencing its fixed-size evidence surface.
- Focused source regression tests pin both contracts.

## Route-local proof

### Dialog/pane route

The direct WPF route `review.comments-pane.seeded` completed after the fix:

- PID `19436`, exit code `0`, no timeout.
- Progress log: `start review.comments-pane.seeded`, then
  `complete review.comments-pane.seeded`.
- Manifest: 5,606 bytes.
- Shell PNG: 94,404 bytes.
- Target PNG: 24,311 bytes.
- Both captures passed the host's non-background gate.

### Whole-window control

Exactly one control route was run with a hard 30-second external timeout:

```text
FreeP.VisualEvidence.Wpf.exe
  --whole-window-visual-evidence-output <temporary-output>
  --whole-window-visual-evidence-scenario startup.slide
```

Result:

- PID `21128`, exit code `0`, elapsed 5,166 ms, no timeout.
- Manifest: 4,175 bytes; host `wpf`; one capture; zero limitations.
- Scenario `startup.slide`; `captureStatus=complete`.
- Logical and normalized pixel size: 1280 x 760 at 96 DPI.
- Source DPI: 144 x 144.
- Non-background pixels: 923,819.
- Full PNG: 29,199 bytes; valid PNG signature.
- Client PNG: 29,199 bytes; valid PNG signature.
- Full and client SHA-256 values both matched the manifest:
  `ebc20e83320c92bcdf76201902556c9cf3ea01859c0e837948e98436ae3f70a5`.
- All four semantic assertions passed: fixture load, slide activation,
  selection activation, and active ribbon tab.

## Verification

```powershell
dotnet test tools/FreeP.RenderCompare.Tests/FreeP.RenderCompare.Tests.csproj `
  --configuration Release `
  --filter "FullyQualifiedName~Wpf_capture_hosts_suppress_interactive_startup_recovery|FullyQualifiedName~Wpf_dialog_capture_forces_normal_window_state_before_showing_the_owner"
```

Result: 2 passed, 0 failed.

```powershell
dotnet build freep/TestSupport/VisualEvidence.Wpf/FreeP.VisualEvidence.Wpf.csproj `
  --configuration Release --no-restore
```

Result: build succeeded with 0 warnings and 0 errors.

The temporary route outputs were removed after validation, no WPF evidence
process remained, and .NET build servers were shut down.
