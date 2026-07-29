# Avalonia Field Widow-Control Pagination

The source-backed field-page-number-variants comparison exposed a real
pagination discrepancy after the page-surface capture was corrected: Avalonia
placed the first line of body paragraph 34 at the bottom of page two, then
continued that paragraph on page three. Word moved the complete ordinary
paragraph to page three.

Avalonia now pre-measures the complete ordinary paragraph before emitting its
first line whenever keep-lines is enabled or Word's default-on widow-control
policy applies. The preflight deliberately excludes tabs, equations, drop caps,
nonzero first-line indents, and floating-wrap exclusions; those paths have
their own line geometry and remain line-by-line. Paragraphs taller than the
available page body continue to split normally.

Against the matching cached Word PNG corpus (816x1056), the fresh candidate
keeps page one byte-identical and improves every affected page:

| Page | Before | After | Change |
| --- | ---: | ---: | ---: |
| 1 | 5.2647% | 5.2647% | 0.0000 pp |
| 2 | 5.1805% | 5.0104% | -0.1701 pp |
| 3 | 8.5076% | 5.0362% | -3.4714 pp |
| 4 | 2.1503% | 2.1258% | -0.0246 pp |

The candidate page sequence matches the Word ownership boundary: page two ends
at paragraph 33 and page three begins with both lines of paragraph 34.

Verification:

- dotnet build freew\tools\FreeW.PageLayoutShot\FreeW.PageLayoutShot.csproj --configuration Release (0 warnings, 0 errors)
- dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~DocumentViewColumnLayoutTests (10/10)
- same focused test with --no-build (10/10)
- fresh source-backed field capture using the matching cached Word PNG corpus.
