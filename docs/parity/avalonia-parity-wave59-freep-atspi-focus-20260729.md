# Avalonia parity Wave 59: FreeP AT-SPI focus traversal

## Scope

This FreeP-only slice extends the Wave 58 Linux accessibility lane from live
pane metadata to OS-level keyboard focus evidence for the five representative
panes already covered by that lane:

- Slides
- Notes
- Comments
- Selection Pane
- Animation Pane

The shared `PresentationPaneAccessibilityPlanner` order is the authority:
`Slides`, `Notes`, `Comments`, `Selection Pane`, `Animation Pane`.

## Implementation

- `PresentationPaneAccessibilityAdapter` now gives visible pane hosts an
  explicit keyboard route: `Focusable`, `IsTabStop`, and a positive `TabIndex`
  derived from the shared descriptor order. Hidden pane hosts are removed from
  the Tab sequence.
- `AccessibilityValidationCoordinator` waits for the AT-SPI probe to attach,
  focuses the first live pane, and then allows the probe to drive the real X11
  keyboard path.
- `run-freep-accessibility-probe.sh` registers an
  `object:state-changed:focused` AT-SPI listener, sends X11 `Tab` events through
  `xdotool`, records exact target name/role/state/focusability/visibility, and
  rejects duplicate role-qualified candidates. Labels cannot satisfy a target
  contract because the expected role is part of every match.
- `freep-atspi-validation.schema.json` is schema version 2 and describes the
  event trail, expected order, observed order, and keyboard method.
- `Run-FreePAccessibilityValidation.ps1` validates the live and OS contracts
  and preserves `not-proven` as an honest result when OS exposure or traversal
  is incomplete.

No Dockerfile change was required. Wave 58's existing `at-spi2-core`,
`python3-pyatspi`, DBus, and X11 packages are sufficient.

## Verification

Focused tests:

```powershell
dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj `
  --configuration Release --no-restore `
  --filter "FullyQualifiedName~AccessibilityValidationSourceTests|FullyQualifiedName~PresentationPaneAccessibilityTests" `
  --logger "console;verbosity=minimal" -m:1
```

Result: 8 passed, 0 failed.

Real Linux evidence:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File tools/Run-FreePAccessibilityValidation.ps1 `
  -Port 6192 -OutputDir artifacts/a59v3 -Replace
```

Result at 1280x820, 96 DPI:

- live controls: 5/5 passed
- AT-SPI target nodes: 5/5 passed
- focus events: 5 target events observed
- target state: every target was `focusable`, `visible`, and `showing`
- exact roles: `list`, `entry`, `panel`, `panel`, `panel`
- exact traversal: `slides,notes,comments,selection,animation`
- container `freex-linux-interactive-freep-6192`: stopped by the owning runner

Retained evidence is under the session directory recorded by
`artifacts/a59v3/freep/current-session.json`, especially
`accessibility-validation/atspi-result.json` and
`accessibility-validation/report.json`.

## Boundary

This proves the OS AT-SPI semantic tree and the X11 keyboard focus-event trail.
It does not certify synthesized screen-reader speech, announcement wording, or
announcement timing. Those remain an explicit residual and are not represented
as passed evidence.
