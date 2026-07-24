# FreeW/FreeP Linux Physical X11 Baseline

This slice adds a reusable, app-parameterized physical-input smoke runner for
the Avalonia FreeW and FreeP applications:

```powershell
powershell -File tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeW
powershell -File tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeP
```

The runner starts the existing harness on an isolated port, discovers the visible
application window, and retains a screenshot plus a machine-readable manifest for:

- the visible-window discovery;
- standalone `Alt` key-tip appearance and `Escape` dismissal;
- standalone `F10` key-tip appearance and `Escape` dismissal;
- switching a ribbon tab by key tip (`I` for FreeW, `N` for FreeP);
- opening and dismissing the app's File surface.

FreeW additionally runs a seven-row physical editing slice: it clicks the real
document editor, replaces the selection with a sentinel, proves exact X11
clipboard text, proves Ctrl+Z and Ctrl+Y restore the exact clipboard states, and
opens/dismisses the real editor context menu through both Shift+F10 and a
pointer right-click. These rows are intentionally FreeW-only. FreeP now runs a
parallel seven-row slide-pane slice for an exact fifteen-row contract: it clicks
the real bottom `+ New Slide` affordance, proves the changed thumbnail-pane
evidence, retains the calibrated main-view frame as contextual evidence, proves
that Ctrl+Z and Ctrl+Y restore the exact calibrated pre-create and created
states, and opens/dismisses the real slide-thumbnail context menu through
both Shift+F10 and a pointer right-click. The screenshot regions and calibration
artifact are retained with each physical run. The required IDs are
`slide-pane-new-slide-create`, `slide-pane-new-slide-undo`,
`slide-pane-new-slide-redo`, `slide-pane-keyboard-context-open`,
`slide-pane-keyboard-context-dismissal`, `slide-pane-pointer-context-open`, and
`slide-pane-pointer-context-dismissal`.

FreeW's File key tip is expected to open its separate top-level `BackstageView`
window. FreeP's File key tip is expected to open the in-window
`FreePBackstageOverlay`/`BackstageView` user control while retaining the owner
window and X11 window count. These distinct invariants are retained in the
manifest's `appSurface`, `parameters.fileSurface`, and result notes.

## Evidence contract

The probe writes `family-x11-results.json` and state screenshots under the session's
`family-validation/` directory. The manifest follows the contract described by
`tools/LinuxInteractiveDocker/family-x11-validation.schema.json`. The PowerShell
runner performs strict contract validation of the required header, app-specific
surface parameters, result IDs, summary counts, physical evidence level, and every
referenced artifact, including non-empty files. It records that result as
`contractValidation.status=passed`; this runner does not claim to execute a general
JSON Schema engine.

The `coverage.exhaustive` field is always `false`. This is a deterministic baseline,
not exhaustive command, dialog, context-menu, shortcut, or visual parity coverage.
The FreeW editing rows are physical evidence for the editor path only, not a
claim that every editing command has been exercised.
FreeX remains covered by `tools/Run-FreeXLinuxInteractionValidation.ps1`; future
family work can extend this runner with additional parameterized probes without
copying the FreeX-specific calibration and grid workflow.

By default the host runner stops only the harness-owned container that it started.
Use `-KeepContainer` when retaining the desktop for interactive inspection; never
stop or replace a container that is not owned by this harness.
