# XLSX Selection Pane Object Names

## Scope

Persist model-backed Selection Pane object names through XLSX drawing non-visual properties for supported visual
object kinds.

## Tasks

- [x] Add failing XLSX round-trip tests for picture, text box, and drawing-shape names.
- [x] Load `xdr:cNvPr/@name` into picture, text box, shape, and chart models.
- [x] Save modeled names back to XLSX drawing non-visual properties, with generated names as the fallback.
- [x] Update command parity and architecture documentation for the XLSX name persistence boundary.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxAdapter_RoundTrip_ImagePicture_SavesAsDrawing|XlsxAdapter_RoundTrip_TextBoxesAndDrawingShapes" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because saved drawing XML used generated names and loaded pictures had no modeled name.
- Green: `dotnet test FreeX\tests\FreeX.Core.IO.Tests\FreeX.Core.IO.Tests.csproj --filter "XlsxAdapter_RoundTrip_ImagePicture_SavesAsDrawing|XlsxAdapter_RoundTrip_TextBoxesAndDrawingShapes" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.

## Architecture Decisions

- XLSX object names use the existing drawing non-visual property (`xdr:cNvPr/@name`) instead of adding a FreeX custom extension.
- Blank or whitespace-only modeled names fall back to generated Office-style names so authored drawing parts remain valid.
- Office drawing IDs and other non-visual metadata stay package details; only the user-visible Selection Pane name is promoted to model state.
