# Avalonia Columns Source Parity

`FreeW.PageLayoutShot --fixtures-dir` previously looked up the UI scenario id
`page-composition-columns.docx`. The generated Word corpus uses the canonical
fixture id `f2-columns.docx`, so the Avalonia capture silently fell back to a
synthetic document while the Word baseline rendered the serialized corpus
fixture.

The page-shot fixture resolver now maps the columns, border/watermark, and
floating-image UI scenarios to their corresponding corpus fixture ids. The
columns scenario also captures the document page surface, giving both Word and
Avalonia an `816x1056` PNG from the same `f2-columns.docx` payload.

Fresh local evidence, using the cached Word COM baseline and a rebuilt Release
`FreeW.PageLayoutShot`, measured the current Avalonia residual at a mean
absolute channel delta of `15.8887` with `11.5685%` changed pixels at a channel
threshold of eight. The remaining error is now attributable to text
rasterization and column-flow cadence, rather than a mismatched source
fixture.

Verification:

- `dotnet build freew\\tools\\FreeW.PageLayoutShot\\FreeW.PageLayoutShot.csproj --configuration Release`
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests`
- Release `FreeW.PageLayoutShot` capture with `--scenario page-composition-columns --fixtures-dir <f2 corpus>`.
