# Avalonia Table Cell Paragraph Spacing

## Scope

Avalonia's paged table renderer now consumes explicit paragraph `before` and `after` spacing from each table-cell paragraph during both row measurement and glyph placement. The DOCX reader already preserves `w:pPr/w:spacing`; WPF already consumes it, while Avalonia previously discarded it inside table cells.

## Matched Evidence

The candidate used the unchanged package fixtures and the fresh Word PDF/PNG corpus from `table-current-word-proof-20260730`. The consuming `FreeW.PageLayoutShot` Release artifact was rebuilt before rendering.

| Surface | Word vs Avalonia before | Word vs Avalonia after |
| --- | ---: | ---: |
| `table-layout-complex` p1 mean channel delta | 10.6269 | 10.2499 |
| `table-layout-complex` p1 changed pixels | 20.4051% | 19.2881% |
| `table-page-composition-stress` p3 mean channel delta | 25.1485 | 25.1255 |
| `table-page-composition-stress` p3 changed pixels | 30.0375% | 29.9338% |

`table-pagination-repeat-header` pages 1-2 and `table-page-composition-stress` pages 1-2 were byte-identical controls.

## Verification

- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release --no-restore --verbosity minimal`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests`
- matching `--no-build` focused test rerun
- PageLayoutShot Release render of all six table reference pages.

## Remaining Work

The table residual is now primarily cell margins, table cell spacing, column registration, and exact row-height behavior. These remain separate source-driven probes.
