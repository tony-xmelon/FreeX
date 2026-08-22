# Avalonia parity Wave 181: FreeX Name Box physical evidence

Date: 2026-08-22
Branch: `codex/wave181-freex-namebox-physical-20260822`

## Bounded change

The production Linux executable was missing the Name Box physical fixture and
evidence partial. The physical runner launches
`src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj`, while those methods existed
only in the parity-capture project. The fixture and JSONL writer now live in
`src/FreeX.App.Avalonia/MainWindow.NameBoxPhysicalEvidence.cs`, so the
production executable records `fixture-seeded` and
`neutral-cell-selected` object-state events at the harness-provided path.

The existing production dropdown implementation is intentionally unchanged in
this slice because the physical run did not prove that the attempted container
rewrite improved X11 painting or selection. The independently correct change is
the production fixture/evidence plumbing needed to observe the remaining fault.

## Verification

Managed Name Box regression: `16/16` passed.

`NameBoxDropdownParityCaptureSourceTests`: passed.

Production Avalonia build: succeeded with `0` warnings and `0` errors.

Physical command:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 6096 -TimeoutMinutes 10 -PhysicalOnly -PhysicalProbeSelector name-box-dropdown
```

Session: `artifacts/linux-interactive/freex/sessions/20260822T184102001Z`.

The validator stopped its owned container and emitted the required object-state
artifact, but the honest result was `0/8`. The JSONL contains the production
`fixture-seeded` event and eight neutral-cell events, but no
`object-selected` events. Keyboard evidence was `open=true` with an empty
clipboard; mouse evidence was `open=false` with an empty clipboard. The exact
postcondition is in
`x11-validation/name-box-dropdown-object-postcondition.json`.

A parity-crop run was also executed:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 6095 -TimeoutMinutes 10 -PhysicalOnly -PhysicalProbeSelector name-box-dropdown-parity
```

It stopped its owned container and failed `0/1`: the X11 inventory found four
new 208x136 windows instead of one, so the required
`popup.nameBoxDropdown.png` crop was not produced. The authoritative evidence
is retained in session
`artifacts/linux-interactive/freex/sessions/20260822T183858832Z`.

## Remaining blocker

The production Avalonia X11 popup/ListBox content is still blank to the
physical capture path, and the probe's native-window identity contract does
not yet identify exactly one popup window. The managed test and production
evidence plumbing do not substitute for that missing physical pixel and
object-selection proof. This commit therefore records the independently correct
production evidence plumbing, but does not claim the physical slice is passing.
