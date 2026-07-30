# Avalonia Table Cell Hard Breaks

## Scope

`DocumentView.WrapCellLines` now treats carriage return/line feed text in table cells as a hard line break. Previously the Avalonia renderer measured and painted `\n` as if it were an ordinary glyph, so a cell such as `Q1\n$1.20M` collapsed into one line.

## Matched Evidence

The candidate used the same package fixtures and fresh Word PDF/PNG references generated in `table-current-word-proof-20260730`, all at 816x1056 or the corresponding 816x528 physical page surface. The actual consuming `FreeW.PageLayoutShot` Release artifact was rebuilt before rendering.

| Surface | Word vs Avalonia before | Word vs Avalonia after |
| --- | ---: | ---: |
| `table-layout-complex` p1 mean channel delta | 10.6269 | 10.6021 |
| `table-layout-complex` p1 changed pixels | 20.4051% | 20.3942% |

The change is isolated to explicit line-break content. `table-page-composition-stress` pages 1-3 and `table-pagination-repeat-header` pages 1-2 were byte-identical before and after the candidate render.

## Verification

- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release --no-restore --verbosity minimal`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests`
- PageLayoutShot Release render of all six table reference pages.

## Remaining Work

Table row height, cell margins, spacing, and paragraph-after geometry still account for the larger residual. Those are separate layout-owner slices and should be measured against the preserved Word corpus without changing this hard-break behavior.
