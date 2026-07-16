# FreeW Word SmartArt Layered Gallery

**Date:** 2026-07-16

## Scope

This slice takes over the paused FreeW parity lane on the Word-equipped machine and compares the four generic Word SmartArt fixtures against FreeW's WPF FidelityRender output:

- `08-smartart-list.docx`
- `09-smartart-process.docx`
- `10-smartart-hierarchy-cycle.docx`
- `11-smartart-styled-color.docx`

Word's normalized PDF raster shows one consistent gallery treatment across these authored layouts: a dark backing shape is offset behind a smaller light foreground shape, the text is black, connectors are thin, and the SmartArt object does not show an editor-only outer frame. The hierarchy, cycle, and radial examples also use compact geometry that differs from FreeW's general-purpose colorful fallback.

## Changes

- Added the Word `accent1_2` color alias used by the hierarchy fixture.
- Recognized authored `simple1`, `colorful2/intense1`, and `accent1/subtle1` gallery combinations for layered rendering while leaving newly-created `SmartArt.Create` diagrams on their existing explicit-style path.
- Calibrated the basic list and process gallery geometry against the normalized Word page raster.
- Added layered WPF layouts for basic hierarchy, cycle, and radial gallery fixtures, including transparent outer framing and compact vertical Word gallery output.
- Ported the same authored-gallery branch to Avalonia: the shared planner flag is carried into `FloatingSmartArtData`, Word gallery objects bypass the editor-only frame, and Avalonia draws the layered backing/foreground treatment for list, process, hierarchy, cycle, and radial layouts. Explicit FreeW-created diagrams remain on the existing renderer path.

## Evidence

Word reference pages are retained in the ignored run folder:

`freew-fidelity-corpus/runs/smartart-generic-word-normalized-20260716/`

The corresponding FreeW render was regenerated after the change at:

`freew-fidelity-corpus/runs/smartart-generic-layered-gallery-20260716/`

The focused WPF evidence run passed for all four fixtures. List and process now match the Word layer colors and overall placement closely; hierarchy, cycle, and radial now use the same layered visual language. Remaining differences are primarily font metrics and fine SmartArt shape curvature.

The Avalonia headless capture test also rendered an authored `process1`/`accent0_1`/`simple1` object and counted the expected Word-default dark backing pixels in the PNG. This verifies the live drawing path in addition to the planner/source wiring test.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ChartSmartArtVisualPlannerTests"`
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~SmartArtRenderingTests"`
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~DocumentViewFloatingFO3Tests"`
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --nologo`

All focused tests and renderer builds passed, including 48/48 Avalonia FO3 tests with the live authored-gallery capture. The full repository verification remains the next integration step.
