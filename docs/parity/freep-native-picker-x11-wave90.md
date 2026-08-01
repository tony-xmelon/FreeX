# FreeP Native Picker X11 Lane - Wave 90

This lane closes the Linux Avalonia side of the FreeP Open and Save As dialog
residual when the orchestrator produces a passing manifest. It is deliberately
separate from the family baseline and from app-owned headless picker tests.

## Command

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreePNativePickerX11Validation.ps1 -SkipPublish -SkipImageBuild
```

The first run should omit both skip switches so the branch-local Ubuntu image and
FreeP publish are built. The wrapper uses port `6110`, a `1280x820` Xvfb desktop,
and `96` DPI by default. It starts the existing harness through
`Run-LinuxInteractiveDocker.ps1`, seeds `01-title-slide.pptx` and
`03-mixed-text.pptx` in the mounted documents directory, and leaves the evidence
under `artifacts/fp-picker-w90/freep/sessions/`. The compact path keeps the
physical-evidence lane below Windows PowerShell's legacy path-length boundary
when it runs from a deep integration worktree.

## Physical contract

The probe drives the real Avalonia storage-provider windows with `xdotool` and
retains screenshots, `wmctrl` inventories, exact SHA-256 files, and ZIP package
inspections. Its nine ordered rows are:

1. visible FreeP owner and initial package
2. Open Escape cancellation with unchanged document hash
3. physical PPTX path selection and package load
4. Save As PPTX filter/path selection and package write
5. existing-target collision confirmation, Escape decline, and unchanged hash
6. unwritable `/proc` target, bounded error, absent output, and safe return
7. Open Escape with no remaining modal blocker
8. Save As Escape with no remaining modal blocker
9. final owner focus after all cancellation/error routes

The PowerShell wrapper rejects duplicate or reordered rows, failed rows, missing
or empty evidence, non-basename evidence references, invalid package hashes,
missing PPTX parts, changed collision hashes, and fixture source/mount hash drift.
The Wave 90 integration run completed all **9/9** rows with strict manifest
validation. Its harness-owned container was stopped after capture; the retained
manifest and screenshots live in the timestamped session below the artifact root
described above.

## Verification boundary

The lane proves Linux/X11 Avalonia storage-provider behavior only. It does not
claim Windows picker pixels or Windows foreground behavior, and it must not be
replaced with picker-result overrides from `NativePickerWorkflowEvidenceTests`.
