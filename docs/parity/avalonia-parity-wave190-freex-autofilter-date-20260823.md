# Wave190 FreeX: Linux X11 Date AutoFilter Reopen

Date: 2026-08-23
Branch: `codex/parity-wave190-freex-20260823`
Base: `origin/main` at `17b3c972a5ef410290d3a8b268238c2f6cbc6f00`

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
- The committed After result names `autofilter-date-after-reopened-grid-read.png` as primary evidence;
  it is also retained and hash-listed in the durable evidence bundle.

The modal/open-cycle owner is the production Avalonia `MainWindow.OpenWorkbookAsync` workflow. Its
`_isSaving`/`_isOpening` boundaries explain why a clean title or an arbitrary extra window alone is
not sufficient readiness evidence. The helper waits for the save boundary, retries the real
`Ctrl+F12`, and verifies the GTK dialog's focused child only after the owning top-level identity is
accepted.

## Physical Evidence

Final report: `artifacts/linux-interactive/freex/interaction-validation/20260823T105230Z/`

```text
before-package=ref=A1:B5|colId=1|operator=lessThan|value=45323
before-open-attempts=1
before-dialog-id=25165831
before-dialog-title=Open Workbook
before-dialog-pid=29
before-reopened=Jan01,Jan15,
after-package=ref=A1:B5|colId=1|operator=greaterThan|value=45323
after-open-attempts=2
after-dialog-id=25168091
after-dialog-title=Open Workbook
after-dialog-pid=29
after-reopened-visible=Mar15
after-reopened-semantic-a5=Mar15
```

The durable evidence bundle is in
`docs/parity/evidence/wave190-freex-autofilter-date-20260823/`. The physical capture ran at
commit `8b5487b35f6e503adafc354176857bf3aee400af`; `manifest.json` records that run commit,
`sourceTestSha256=c4d1111e62e51b9574278dbde9d1e5925da15d17d8c25f5b45ada9ece26b3b2e` and
`harnessSha256=836f4eb4c8873bb42ae86530d372267c8145ef4447729a0195ee502bae7496b4`, plus SHA-256
file hashes, report provenance, strict 2/2 metrics, and accepted dialog identities. The bundle retains
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
