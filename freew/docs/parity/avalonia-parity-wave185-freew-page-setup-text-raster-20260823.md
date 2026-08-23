# Avalonia Parity Wave 185: FreeW Page Setup Text Raster

Date: 2026-08-23
Scope: `page-setup`, paired FreeW WPF/Avalonia dialog evidence at 560 x 600 logical pixels

## Selection

After Wave184's `table-properties.tab-cell` correction, the current canonical FreeW
dialog comparison ranked the six-state `page-setup` family as the next high-value
reproducible residual: 167,686 changed pixels across `initial`, `populated`,
`tab-layout`, `tab-margins`, `tab-paper`, and `validation-error`. The route has
matching action semantics and WPF/Avalonia outer content bounds; the residual is
product-owned Avalonia text rasterization rather than a semantic or missing-content
gap.

The available Word bundle remains `available-needs-review` (65 reference PNGs;
102 rows, 99 comparable, 5 passed, 94 failed, 3 skipped). It was used as a
typography triage signal, not as a direct dialog pixel-parity claim.

## Cause And Change

The shared Avalonia dialog shell intentionally uses subpixel antialiasing for
general dialog coverage. The WPF Page Setup authority capture has monochrome glyph
edges, while the shared Avalonia mode produced colored fringe pixels around the
same labels, tab captions, and field text. FreeW's Avalonia `PageSetupDialog` now
selects Avalonia's `Antialias` text mode for this authority-specific route. The
shared shell default, WPF host, page-setup planner/session semantics, comparison
thresholds, and other routes are unchanged.

## Fresh Evidence

Artifacts were captured from the verified checkout under ignored worktree paths:

- `artifacts/wave185-freew-page-setup-final-wpf`
- `artifacts/wave185-freew-page-setup-final-avalonia`
- `artifacts/wave185-freew-page-setup-final-compare`

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | pHash before/after | WPF/Avalonia painted bounds after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `initial` | 32,469 | 31,991 | 9.663393% | 9.521131% | 6.0979395 | 6.0934306 | 1 / 1 | 517x537 / 518x537 |
| `populated` | 32,469 | 31,991 | 9.663393% | 9.521131% | 6.0979395 | 6.0934306 | 1 / 1 | 517x537 / 518x537 |
| `tab-layout` | 22,472 | 22,094 | 6.688095% | 6.575595% | 4.5889444 | 4.5809583 | 2 / 2 | 517x537 / 518x537 |
| `tab-margins` | 32,469 | 31,991 | 9.663393% | 9.521131% | 6.0979395 | 6.0934306 | 1 / 1 | 517x537 / 518x537 |
| `tab-paper` | 14,983 | 14,851 | 4.459226% | 4.419940% | 2.9882976 | 2.9838313 | 0 / 0 | 517x537 / 518x537 |
| `validation-error` | 32,824 | 32,319 | 9.769048% | 9.618750% | 6.2141875 | 6.2090982 | 1 / 1 | 517x537 / 518x537 |

Route totals moved from 167,686 to 165,237 changed pixels. Average changed
ratio moved from 8.317758% to 8.196280%, and average mean channel delta moved
from 5.3475413 to 5.3423633. All six final rows are content-gated,
`captured/captured`, semantically equal, and remain `genuine-visual-mismatch`
under the unchanged thresholds. The remaining delta is native WPF/Avalonia
control and glyph rasterization plus the stable one-pixel Avalonia painted-width
residual.

## Verification

- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~PageSetupDialogVisualParityTests"`: 8 passed, 0 failed.
- WPF route capture: 6/6 captured, 0 unsupported.
- Avalonia route capture: 6/6 captured, 0 unsupported.
- Focused comparison: 6 genuine visual mismatches, 0 semantic differences; no threshold or classification was weakened.
