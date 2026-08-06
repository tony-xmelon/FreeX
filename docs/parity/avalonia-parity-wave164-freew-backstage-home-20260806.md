# Avalonia Parity Wave 164 FreeW Backstage Home

Date: 2026-08-06

## Scope

This slice targets the app-owned `backstage-home.open` pane in the fixed
560x600, 96-DPI neutral host. WPF remains the visual authority. Legal Notices
and the repeatedly native-only Backstage Open residual were not reclassified.

## Fresh Evidence

The checked-in aggregate before this slice reported the stale Home row at
41,408 / 336,000 changed pixels (`12.3238095%`), mean channel delta
`9.23351885`, p95 `86`, and pHash distance `5`.

Fresh current-source captures were required before editing. The fresh pre-edit
pair measured 30,706 / 336,000 changed pixels (`9.1386905%`), mean channel
delta `6.19348115`, p95 `48`, pHash distance `0`, and no semantic difference.
The images showed an app-owned cumulative vertical drift: Avalonia action rows
added about one DIP per row while the WPF section-header positions remained the
authority.

Three text/button footprint probes were rejected because they regressed the
fresh pair:

| Probe | Changed pixels | Changed ratio | Mean delta |
| --- | ---: | ---: | ---: |
| Explicit line heights on action labels/descriptions | 34,963 | 10.4056548% | 7.62639782 |
| Fixed 29-DIP Home action buttons | 31,052 | 9.2416667% | 7.32451587 |
| Explicit 17-DIP action-label line height | 32,399 | 9.6425595% | 6.74855060 |

The retained alignment compensates the Avalonia Home action-row bottom margin
by one DIP only. It preserves the shared WPF authority metrics, action order,
callbacks, and text content while removing the measured cumulative drift.

| Metric | Fresh pre-edit | Final | Improvement |
| --- | ---: | ---: | ---: |
| Changed pixels | 30,706 | 21,910 | -8,796 |
| Changed ratio | 9.1386905% | 6.5208333% | -2.6178572 pp |
| Mean absolute channel delta | 6.19348115 | 2.83760218 | -3.35587897 |
| P95 absolute channel delta | 48 | 19 | -29 |
| Perceptual hash distance | 0 | 0 | unchanged |
| Semantic difference | none | none | unchanged |

The final row remains `genuine-visual-mismatch` because the repository's
visual mismatch threshold is unchanged and the remaining pixels are native
WPF/Avalonia text rasterization and scrollbar-template variance.

As the required pivot audit, a fresh `backstage-export.open` pair measured
40,578 changed pixels (`12.0767857%`) and mean delta `10.3659375`; its content
bounds, action order, and semantics were aligned, with only the same native
rendering residual. No Export tweak was retained.

## Canonical Counts

The route-only authoritative refresh preserves the aggregate counts:

- 478 inventory scenarios
- 190 WPF captures
- 288 Avalonia captures
- 159 genuine visual mismatches
- 24 passes
- 105 Avalonia extensions
- 7 state-not-applicable rows

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"` - 40 passed.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 0 warnings, 0 errors.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 0 warnings, 0 errors.
- Focused WPF capture: `wpf.backstage-home.open`, 1/1 captured.
- Focused Avalonia capture: `avalonia.backstage-home.open`, 1/1 captured.
- Route-only canonical refresh through `FreeW.DialogVisualHarness compare --baseline ... --refresh-route backstage-home` completed with the counts above; its expected mismatch exit status was `1` because the supplied focused manifests do not contain the other inventory routes.
