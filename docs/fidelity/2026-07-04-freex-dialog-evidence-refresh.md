# FreeX dialog evidence refresh

This slice follows the `543b9726d` dialog-size target merge for `dialog.GoToSpecial`, `dialog.InsertHyperlink`, and `dialog.ProtectSheet`.

## Outcome

- `tools/Generate-DialogVisualEvidenceSummary.ps1` now treats those three surfaces as deterministic expected-size evidence sourced from the shared planner constants.
- `docs/parity/dialog-visual-evidence-summary.md` and `.json` now flag the committed Avalonia PNGs for those surfaces as expected-size evidence mismatches instead of product-size mismatches.
- Current summary after regeneration:
  - Paired expected-size evidence mismatches: 3
  - Stale promoted expected-size evidence: 0
  - Real logical-size mismatches: 9

## Capture blocker

Two recapture attempts were made from this worktree.

- `dotnet run --configuration Release --project src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj -- --parity-capture <outDir>` exited with code `1` and wrote no manifest or PNG evidence.
- A temporary Avalonia headless runner using `MainWindow.CaptureParitySurfacesAsync` could invoke the three modal surfaces, but `RenderVisualToPng` produced zero-byte files for `dialog.GoToSpecial.png`, `dialog.InsertHyperlink.png`, and `dialog.ProtectSheet.png` while the returned `ParitySurfaceResult` values still reported `Captured: true`.

Do not promote those zero-byte outputs. The capture path needs a follow-up guard that rejects zero-byte PNGs before marking a surface captured.

## Follow-up capture guard

Branch `codex/freex-avalonia-capture-zero-byte-20260704-c` adds the capture guard described above: a parity surface can only report `captured: true` after the referenced PNG file exists, is non-empty, and has the PNG signature. Missing, zero-byte, or non-PNG outputs are now recorded as `captured: false` with the exact path in the note.

Validation from the branch:

- `dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~ParityCaptureTests --logger "trx;LogFileName=parity-capture-zero-byte.trx"` passed `2/2`.
- `dotnet run --no-build --configuration Release --project src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj -- --parity-capture <temp>` exited `0`.
- The no-build capture produced non-empty PNGs for the three stale expected-size dialogs:
  - `dialog.GoToSpecial.png`: 23069 bytes
  - `dialog.InsertHyperlink.png`: 15870 bytes
  - `dialog.ProtectSheet.png`: 20670 bytes

## Follow-up evidence promotion

Branch `codex/freex-promote-dialog-captures-20260704-d` regenerated the Avalonia parity capture after the zero-byte output guard landed and promoted only the three expected-size dialog PNGs from that valid capture:

- `dialog.GoToSpecial.png`: 23069 bytes, 430x438 px @ 96 DPI
- `dialog.InsertHyperlink.png`: 15870 bytes, 560x300 px @ 96 DPI
- `dialog.ProtectSheet.png`: 20670 bytes, 430x540 px @ 96 DPI

The regenerated committed parity summary now reports:

- Paired expected-size evidence mismatches: 0
- Stale promoted expected-size evidence: 0
- Real logical-size mismatches: 9
