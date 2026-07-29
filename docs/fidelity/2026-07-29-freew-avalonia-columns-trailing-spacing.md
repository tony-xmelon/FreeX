# Avalonia Column-Break Trailing Spacing

The serialized `f2-columns.docx` corpus fixture specifies `w:after="160"`
for its body paragraphs: 8pt of trailing paragraph spacing. Avalonia previously
added that spacing after the final line in a full column even when it crossed the
column boundary. The first paragraph in the next column consequently began about
9px below Word's text-area origin.

`DocumentView.AdvanceAfterParagraphSpacing` now drops only the portion of
paragraph-after spacing that would cross a print-layout column or page boundary.
Within-column spacing and footnote reservations are unchanged.

Fresh Release `FreeW.PageLayoutShot` evidence against the matching Word COM
`816x1056` PNG:

| Region | Mean absolute channel delta | Changed pixels (threshold 8) |
| --- | ---: | ---: |
| Whole page | 15.8887 -> 11.1124 | 11.5685% -> 9.1834% |
| Right column | 35.6603 -> 18.4945 | 23.2387% -> 14.6668% |
| Left column | 19.0141 -> 19.0141 | 15.0667% -> 15.0667% |

The first right-column ink band moved from `109-121` to `99-111`, matching
Word's `100-111` band within normal host glyph-raster variance. The unchanged
left column is the paired no-regression control.

Verification:

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewColumnLayoutTests` (`9/9`)
- same focused lane with `--no-build` (`9/9`)
- `dotnet build freew\\tools\\FreeW.PageLayoutShot\\FreeW.PageLayoutShot.csproj --configuration Release` (`0` warnings, `0` errors)
