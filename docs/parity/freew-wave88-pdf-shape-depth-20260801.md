# FreeW Avalonia PDF shape depth - Wave 88

Date: 2026-08-01
Scope: FreeW Avalonia direct PDF export and the shared PDF draw-op backends. No Linux harness, shared ribbon, FreeX, FreeP, or Wave 88 integration report changes were made.

## Result

This wave closes two residuals called out by Wave 87 for floating AutoShapes:

- Shape `FlipH` and `FlipV` now survive the shared PDF path. The adapter wraps geometry and run-aware shape text in the existing rotation group whenever rotation or either flip is present. The transform is centered on the page-space shape bounds and applies horizontal/vertical scale before the Office rotation angle, matching the live Avalonia/WPF visual-plan contract.
- Shape outline dash tokens now survive vector PDF export. The existing visual plan tokens `dash`, `sysDot`, and `dashDot` map to shared point-space dash arrays `[4,3]`, `[1,2]`, and `[4,2,1,2]`. Rectangle, ellipse, rounded/custom path, and gradient-path outline ops carry the same optional dash metadata.

Both shared PDF writers consume the new metadata:

- Skia applies centered flip transforms and `SKPathEffect` dash patterns to rectangle, ellipse, and path strokes.
- Portable PDF emits the equivalent centered `cm` transform and PDF `d` operator, including dashed strokes inside combined fill-and-stroke paths.
- Existing callers that do not provide flips or dash metadata retain their prior output because all new draw-op fields are optional.

## Evidence

Focused regression tests prove the adapter and backends independently:

- `DocumentViewPdfExportTests.BuildPdfContent_PreservesFloatingShapeFlipsAndDashStyle` builds a real floating text box with both flips, 17 degree rotation, and `dashDot`, then verifies the emitted `PdfRotationGroup` and `[4,2,1,2]` outline plan.
- `PortablePdfWriterTests.Write_EmitsDashPatternAndCenteredFlipTransform` verifies the portable stream contains the center-preserving `-1 0 0 1 100 0 cm` transform and `[4 3] 0 d` stroke operator.
- The existing Skia PDF writer suite passed with the same shared draw-op model, covering the Skia serialization/render path after the new optional fields were added.

## Verification

```text
dotnet restore freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj
dotnet restore tests/Free.Shared.Pdf.Tests/Free.Shared.Pdf.Tests.csproj

dotnet test tests/Free.Shared.Pdf.Tests/Free.Shared.Pdf.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~PortablePdfWriterTests|FullyQualifiedName~SkiaPdfWriterTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Passed: 43, Failed: 0, Skipped: 0

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~DocumentViewPdfExportTests --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  Passed: 9, Failed: 0, Skipped: 0
```

The first attempted parallel test launch hit a shared `Free.Shared.Pdf.dll` file lock; the authoritative reruns above were serialized and passed. No Docker or machine-wide process termination was used.

## Residuals

- Pattern fills still use the established solid background/foreground fallback in FreeW PDF export; the shared PDF vocabulary has no tiling-pattern fill primitive yet.
- Shape shadow, glow, soft edge, reflection, and bevel remain outside this vector slice. The existing effect fallback contract remains in force until a bounded raster/effect draw-op is added.
- Floating charts, WordArt, SmartArt, groups, watermarks, and several page decorations remain unclaimed by this FreeW direct-PDF shape adapter.
- PowerPoint/Word-authoritative PDF visual baselines remain unavailable in this worktree; these tests prove shared operation semantics and local backend output, not Office pixel identity.
