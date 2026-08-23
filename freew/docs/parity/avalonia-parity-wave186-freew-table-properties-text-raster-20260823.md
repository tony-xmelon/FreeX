# Avalonia Parity Wave 186: FreeW Table Properties Text Raster

Date: 2026-08-23
Scope: `table-properties`, paired FreeW WPF/Avalonia dialog evidence at 560 x 600 logical pixels

## Selection

After Wave185 Page Setup, the current canonical FreeW comparison ranked the seven-state
`table-properties` family as the next high-value reproducible route: the fresh baseline pair
contained 194,275 changed pixels across `initial`, `populated`, `tab-cell`, `tab-column`,
`tab-row`, `tab-table`, and `validation-error`. All captures had matching dimensions and
the route had no semantic difference.

## Cause And Change

The WPF authority renders this compact surface with monochrome glyph edges, while the shared
Avalonia dialog shell defaults to subpixel antialiasing. FreeW's Avalonia `TablePropertiesDialog`
now selects Avalonia's `Antialias` text mode for this route only. Shared dialog defaults, WPF,
table session semantics, comparator thresholds, and other routes are unchanged.

## Fresh Paired Evidence

Artifacts were captured from the final checkout under ignored worktree paths:

- `artifacts/wave186-freew-table-baseline-wpf`
- `artifacts/wave186-freew-table-baseline-avalonia`
- `artifacts/wave186-freew-table-baseline-compare`
- `artifacts/wave186-freew-table-after-antialias`
- `artifacts/wave186-freew-table-after-antialias-compare`

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | Dimensions | Classification after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `initial` | 32,098 | 31,664 | 9.552976% | 9.423810% | 6.756173 | 6.766810 | 560x600 / 560x600 | genuine-visual-mismatch |
| `populated` | 32,098 | 31,664 | 9.552976% | 9.423810% | 6.756173 | 6.766810 | 560x600 / 560x600 | genuine-visual-mismatch |
| `tab-cell` | 40,659 | 39,948 | 12.100893% | 11.889286% | 7.674137 | 7.688064 | 560x600 / 560x600 | genuine-visual-mismatch |
| `tab-column` | 9,179 | 9,064 | 2.731845% | 2.697619% | 2.212095 | 2.201035 | 560x600 / 560x600 | pass |
| `tab-row` | 15,654 | 15,325 | 4.658929% | 4.561012% | 3.743156 | 3.748252 | 560x600 / 560x600 | genuine-visual-mismatch |
| `tab-table` | 32,098 | 31,664 | 9.552976% | 9.423810% | 6.756173 | 6.766810 | 560x600 / 560x600 | genuine-visual-mismatch |
| `validation-error` | 32,489 | 32,037 | 9.669345% | 9.534821% | 6.892107 | 6.904759 | 560x600 / 560x600 | genuine-visual-mismatch |

Across all seven states, changed pixels improved from 194,275 to 191,366 and average changed
ratio improved from 8.259991% to 8.136310%. Average mean absolute channel delta moved from
5.827145 to 5.834648; this small raster-distribution tradeoff is reported rather than hidden.
The Column state remains a pass, the other six remain honest genuine visual mismatches, and
all seven remain semantically equal under the unchanged thresholds.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests.Table_properties"`: 8 passed, 0 failed.
- WPF route capture: 7/7 captured, 0 unsupported.
- Avalonia route capture: 7/7 captured, 0 unsupported.
- Focused comparison: 6 genuine visual mismatches, 1 pass, 0 semantic differences.
- Canonical aggregate counts remain 141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions.
