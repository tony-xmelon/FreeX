# Avalonia Parity Wave 184: FreeW Table Properties Cell Tab

Date: 2026-08-23
Scope: `table-properties.tab-cell`, paired FreeW WPF/Avalonia dialog evidence at 560 x 600 logical pixels

## Selection

The committed FreeW dialog comparison ranked `table-properties.tab-cell` as a high-value
genuine mismatch: 47,810 changed pixels out of 336,000 (14.2292%) with mean channel delta
7.8428. The tracked aggregate is older than the current route implementation, so a fresh
same-checkout capture was used for the before/after measurement below. The Word bundle was
available for triage but is explicitly `word-baseline-needs-review` (102 rows, 99 comparable,
5 passed, 94 failed, 3 skipped); it was not used as a pixel-parity claim for this dialog.

## Cause And Change

The fresh pair showed a bounded Avalonia realization mismatch: its Cell-tab Positioning stack
placed the disabled `Allow overlap` row inside the visible bottom of the tab pane, while WPF's
native tab viewport clips that row below the 560 x 600 action-row boundary. Avalonia now keeps
the tab control clipped and gives that route-local checkbox the measured WPF ten-DIP bottom
cadence. Shared table session semantics, the WPF host, comparator thresholds, and other dialog
routes are unchanged.

## Fresh Evidence

Artifacts were captured under the ignored worktree paths:

- `artifacts/wave184-freew-table-cell-before-wpf`
- `artifacts/wave184-freew-table-cell-before-avalonia`
- `artifacts/wave184-freew-table-cell-before-comparison`
- `artifacts/wave184-freew-table-cell-final-wpf`
- `artifacts/wave184-freew-table-cell-final-avalonia-v3`
- `artifacts/wave184-freew-table-cell-final-comparison-v3`

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | pHash after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `table-properties.tab-cell` | 41,127 | 40,659 | 12.240179% | 12.100893% | 7.7785923 | 7.6741369 | 2 |

The focused route captured 7/7 WPF and 7/7 Avalonia states, all content-gated. The final route
comparison classified 6 rows as `genuine-visual-mismatch` and 1 as `pass`, with no semantic
differences. The focused row remains a genuine mismatch because native WPF/Avalonia control
chrome and text rasterization still differ; the change improves the product-owned viewport
geometry without weakening the existing threshold.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests.Table_properties"`: 7 passed, 0 failed.
- WPF route capture: 7 captured, 0 unsupported.
- Avalonia route capture: 7 captured, 0 unsupported.
- Focused comparison: 6 genuine visual mismatches, 1 pass, 0 semantic differences.
