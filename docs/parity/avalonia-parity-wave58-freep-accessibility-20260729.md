# Avalonia parity Wave 58: FreeP live-pane accessibility

## Scope

FreeP's existing shared accessibility contract covers 11 pane IDs in WPF and
Avalonia. This slice adds a real Linux desktop evidence lane for the Avalonia
host. It observes live controls for four representative panes and queries the
running X11 application through AT-SPI for five representative panes:

- Slides
- Notes
- Comments
- Selection Pane
- Animation Pane

The live-control manifest verifies each pane's stable automation ID, accessible
name, help text, host control role, state, and value. The AT-SPI manifest verifies
the OS-visible accessible name, role, state set, and value field.

## Implementation

- `freep/FreeP.App.Avalonia/AccessibilityValidation.cs` adds the
  `--accessibility-validation=<directory>` evidence command. It opens the
  representative live panes, reads attached `AutomationProperties` from the
  actual controls, writes an atomic manifest, and waits for the external probe.
- `tools/LinuxInteractiveDocker/run-freep-accessibility-probe.sh` starts an
  AT-SPI query in the same X11/DBus session. It recursively finds the FreeP
  titled child window below the generic `Avalonia Application` accessible,
  then walks the application tree and reads names, roles, states, and values.
  It only reports `passed` when all five target pane nodes are observed.
- `tools/LinuxInteractiveDocker/Dockerfile` installs the AT-SPI runtime,
  Python bindings, and GDBus support required by the probe.
- `tools/Run-FreePAccessibilityValidation.ps1` owns the full start, probe,
  manifest validation, report, and container cleanup lifecycle.

## Evidence

Command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreePAccessibilityValidation.ps1 `
  -Port 6162 -OutputDir artifacts/a58r -SkipPublish -SkipImageBuild -Replace
```

Result: `live controls passed (4); AT-SPI passed (5 observations)` at
1280x820, 96 DPI.

Committed-run report:

`artifacts/a58r/freep/accessibility-validation/report.json`

The session manifests are under the session directory recorded by
`artifacts/a58r/freep/current-session.json`:

- `accessibility-validation/live-pane-accessibility.json`
- `accessibility-validation/atspi-result.json`

The AT-SPI application was named `Avalonia Application`; recursive traversal
found the child window titled `Untitled * - FreeP` and all five pane nodes. The
probe therefore does not depend on the generic application name containing
`FreeP`.

## Verification

- `AccessibilityValidationSourceTests`: 3 passed.
- Existing `PresentationPaneAccessibilityTests`: 2 passed.
- Bash syntax was validated in the Linux probe image during the end-to-end run.
- The production Linux app was published, started in Docker, queried through
  AT-SPI, and stopped through the harness-owned cleanup path.

## Boundary

AT-SPI exposes semantic names, roles, state sets, and value fields. It does not
surface Avalonia's attached `AutomationId` or help text in this run; those
remain verified from the live control manifest. The lane is therefore an
OS-level accessibility proof for the semantic surface plus an in-process live
host proof for the stable cross-platform metadata contract, not a screen-reader
announcement-order certification.
