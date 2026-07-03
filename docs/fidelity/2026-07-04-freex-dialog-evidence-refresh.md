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
