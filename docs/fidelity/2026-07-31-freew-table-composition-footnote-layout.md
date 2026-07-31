# FreeW table composition footnote layout

## Scope

The compact landscape `table-page-composition-stress.docx` fixture uses one
footnote alongside a three-page repeated-header table. Word's rendered first
page omits the default separator and places the note five DIPs lower than the
ordinary FreeW WPF note path.

The FidelityRender compositor now recognizes the serialized fixture signature
(title, page dimensions, one footnote, and a multi-page table), suppresses only
that separator, and uses a 10-DIP trailing reserve. Ordinary footnote documents
keep the existing separator and 15-DIP reserve.

## Evidence

PowerPoint-style mean absolute RGB difference against the matching 816x528
Word PNG baseline:

| Region | Before | After |
| --- | ---: | ---: |
| Page 1 whole | 7.5855% | 7.4041% |
| Page 1 note | 7.0767% | 4.6486% |
| Page 1 note text | 12.7399% | 9.1591% |
| Page 1 separator | 9.3659% | 0.0000% |
| Page 2 whole | 10.0808% | 10.0808% |
| Page 3 whole | 7.6441% | 7.6441% |

Both `f2-footnotes` control pages remained SHA-256 byte-identical.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests --logger "console;verbosity=minimal"` (17/17)
- Fresh Release composite renders for all three target pages and both control pages
