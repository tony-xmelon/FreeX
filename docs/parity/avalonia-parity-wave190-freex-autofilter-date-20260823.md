# Wave190 FreeX: Linux X11 Date AutoFilter Reopen

Date: 2026-08-23
Branch: `codex/parity-wave190-freex-20260823`
Base: `origin/main` at `2aef931ca017f5c3755d86b302099597c72947db`

## Outcome

The production Linux X11 `Date Filters > Before/After > February 1` save/reopen lane passes
strictly at 2/2. This follow-up closes the three integration-review gaps in `049953808e` without
changing the app or weakening acceptance.

- The After reopen assertion now physically selects the first rendered data-row slot and invokes
  the production worksheet context-menu Copy command. Its clipboard must change from an in-app
  anti-stale `Region` value to `Mar15`. The address-based A5 formula-field read remains a separate
  semantic assertion, and both values are mandatory.
- A new window is accepted only when its active X11 identity is new, its exact title is
  `Open Workbook`, and its PID matches the FreeX main window. The accepted id/title/PID are recorded
  before path input; an unrelated window is rejected without typing.
- Before and After use the same bounded post-save idle wait and identity-checked Open retry helper.

The modal/open-cycle owner is the production Avalonia `MainWindow.OpenWorkbookAsync` workflow. Its
`_isSaving`/`_isOpening` boundaries explain why a clean title or an arbitrary extra window alone is
not sufficient readiness evidence. The helper waits for the save boundary, retries the real
`Ctrl+F12`, and verifies the GTK dialog's focused child only after the owning top-level identity is
accepted.

## Physical Evidence

Final report: `artifacts/linux-interactive/freex/interaction-validation/20260823T102404Z/`

```text
before-package=ref=A1:B5|colId=1|operator=lessThan|value=45323
before-open-attempts=1
before-dialog-id=25165831
before-dialog-title=Open Workbook
before-dialog-pid=29
before-reopened=Jan01,Jan15,
after-package=ref=A1:B5|colId=1|operator=greaterThan|value=45323
after-open-attempts=2
after-dialog-id=25168074
after-dialog-title=Open Workbook
after-dialog-pid=29
after-reopened-visible=Mar15
after-reopened-semantic-a5=Mar15
```

The durable evidence bundle is in
`docs/parity/evidence/wave190-freex-autofilter-date-20260823/`. `manifest.json` records SHA-256
hashes, report provenance, strict 2/2 metrics, and accepted dialog identities. The bundle retains
the machine-readable physical result, full postcondition, both Open-cycle diagnostics, the Before
reopen PNG, and the After reopened visible-grid read PNG. The ignored scratch artifact tree is not
committed.

## Verification

```text
dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~Wave189AutoFilterDatePhysicalSourceTests" --logger "console;verbosity=minimal"
Passed: 2, Failed: 0, Skipped: 0

powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector autofilter-date-criteria-persistence -SkipImageBuild -TimeoutMinutes 20
Passed: 2, Failed: 0, Total: 2
```

The physical runner stopped its owned container. No XLSX bypass/direct package manipulation was
used, and no cross-app dashboard or integration note was changed.
