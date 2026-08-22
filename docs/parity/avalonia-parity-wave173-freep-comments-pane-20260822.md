# Wave 173: FreeP comments-pane paired evidence

Date: 2026-08-22

## Scope

Reran the sole canonical FreeP dialog/pane mismatch,
`review.comments-pane.seeded`, using fresh, same-authority WPF and Avalonia
app-owned captures at logical 96 DPI. The WPF evidence-host startup fix from
Wave172 was exercised in the pair; no new product or harness defect was found.

## Fresh evidence

- WPF and Avalonia processes both exited 0 with complete manifests and no
  limitations.
- Semantic parity: dimensions, focus contract, button order, and enabled state
  all pass.
- Target: 1100x100 pixels; 15,076 changed pixels (13.7055%), mean channel
  delta 8.2594; thresholds pass (20% and 18.0).
- Shell context: 1280x760 pixels; 14.9516% changed pixels, mean channel delta
  9.8635; shell thresholds pass.
- Fresh WPF target SHA-256:
  `dee0198148ddd2af7b2c341eba59963f25b1b5098f5526160f77f1ffce93f79b`.
- Fresh Avalonia target SHA-256:
  `8031fef30a24629b3da2e053cb7c9797aa86db59c7705e7004dcaec20435a7e7`.

The fresh route was promoted into the canonical dialog-pane evidence tree.
The canonical dialog/pane lane is now 28 paired captures, 28 pass, 0 mismatch,
and 0 limitations. The cross-framework raster delta remains within the
existing thresholds; those thresholds were not changed.

## Verification

- `dotnet build freep/TestSupport/VisualEvidence.Wpf/FreeP.VisualEvidence.Wpf.csproj --configuration Release`: passed, 0 warnings, 0 errors.
- `dotnet build freep/TestSupport/VisualEvidence.Avalonia/FreeP.VisualEvidence.Avalonia.csproj --configuration Release`: passed, 0 warnings, 0 errors.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release`: passed, 0 warnings, 0 errors.
- Fresh route-local WPF/Avalonia captures: both exit 0; no limitations.
- `dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-build -- --dialog-pane-visual-report <fresh merged evidence>`: 28 pass, 0 mismatch, 0 limitation.
- Focused `DialogPaneVisualEvidenceTests`: includes the canonical comments-pane same-authority pass regression.
