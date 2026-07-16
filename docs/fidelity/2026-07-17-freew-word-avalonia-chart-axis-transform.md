# FreeW Word Avalonia Chart Axis Transform

Date: 2026-07-17

## Finding

The live Word PDF baseline for `chart-smartart-complex` places the rotated
`USD` and `Weight` value-axis titles in the reserved band to the left of each
plot. The matching Avalonia page shot placed both titles through their plots.

`DocumentView.DrawSceneText` composed an anchor translation before the glyph
rotation. Avalonia composes those matrices left-to-right, so the anchor vector
was rotated too.

## Fix

The Avalonia renderer now rotates local glyph coordinates first, then translates
them to the shared chart-scene anchor. Horizontal labels are unchanged.

## Evidence

- Word: `freew-fidelity-corpus/runs/word-smartart-refresh-20260717/word-png/chart-smartart-complex_p1.png`
- Avalonia: `freew-fidelity-corpus/runs/avalonia-chart-axis-transform-20260717/chart-smartart-complex_p1.png`

The refreshed Avalonia page shot keeps `USD` and `Weight` outside their plots,
where the Word baseline places them.

## Verification

- `dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --nologo`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~DocumentViewPolishTests.Chart_render_with_all_annotations_does_not_throw"`
- `dotnet run --project freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release --no-restore -- freew-fidelity-corpus/runs/avalonia-chart-axis-transform-20260717`
