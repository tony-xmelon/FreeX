# Avalonia table cell surface spacing

## Scope

Imported `w:tblCellSpacing` now reserves physical gaps around Avalonia table cell
surfaces without changing the nominal row measurement used by page scheduling.

## Owner and implementation

`FreeW.App.Avalonia/Editing/DocumentView.cs` retains the logical grid for column
widths, text wrapping, row heights, and `ReserveContentY`.  `SurfaceRectFor`
insets each drawn cell and its text origin by the serialized cell spacing.  Outer
edges receive the same physical reservation as interior seams, while adjacent
cell surfaces create the full visible gutter.

This is intentionally separate from the rejected vertical-gutter probe, which
added spacing to row height and changed pagination.  Word's reference raster
shows the gap as a surface/composition feature rather than additional scheduled
row height for these fixed-grid fixtures.

## Matching Word evidence

Fresh Word COM reference: `freew-fidelity-corpus/runs/table-current-word-proof-20260730`
at 816x1056 (complex) and 816x528 (paginated/composition pages).

| Scenario | Baseline mean / changed | Candidate mean / changed |
| --- | --- | --- |
| `table-layout-complex` p1 | 10.2499 / 19.2881% | 10.0091 / 18.6307% |
| `table-page-composition-stress` p1 | 26.2263 / 30.8304% | 26.0190 / 30.3007% |
| `table-page-composition-stress` p2 | 34.5021 / 47.5683% | 34.2966 / 46.9644% |
| `table-page-composition-stress` p3 | 25.1255 / 29.9338% | 25.0402 / 29.6214% |

The no-cell-spacing pagination controls are SHA-256 byte-identical:
`table-pagination-repeat-header` p1 and p2 remain 12.3656 / 13.8931% and
11.6068 / 13.6025% against the same Word targets.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests`
- `dotnet build freew/tools/FreeW.PageLayoutShot/FreeW.PageLayoutShot.csproj --configuration Release --no-restore --verbosity quiet`
- Fresh `FreeW.PageLayoutShot` rendering of all three table scenarios against the
  matching persistent Word corpus.
