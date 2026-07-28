# FreeW Equation Gallery Avalonia Parity - Wave 48

## Resolved mismatch

The Avalonia Insert > Equation gallery exposed six common presets while the WPF
host and shared equation model supported fourteen. Avalonia now exposes the
remaining structures: nth root, product, accent, bar, bracket, matrix,
function application, and group character.

Every menu item routes through `DocumentView.InsertEquation` and uses the same
`MathRun` factory and OMML-backed model structure as WPF. The inserted equations
therefore retain existing undo/redo, visual-planner, and DOCX round-trip paths.

## Validation

Build:

`dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 0 warnings, 0 errors.

Focused tests:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~InsertDepth2Tests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 46 passed, 0 failed, 0 skipped.

## Residual

The gallery now exposes the same shared preset set as WPF. Editing individual
equation placeholders and specialized math typography remain common model and
renderer work rather than host-specific command gaps.
