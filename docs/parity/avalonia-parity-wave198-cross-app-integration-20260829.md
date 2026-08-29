# Avalonia/WPF Cross-App Parity Wave198 Integration

Date: 2026-08-29  
Wave: 198  
Status: accepted-local-gates

## Integration Status

Wave198 records three app slices and cumulative **594 app slices (198 per
app)**. Overall 100% Avalonia/WPF parity remains incomplete. The exact tested
source commit is `1c6cb5e8019dd0098465c67f8f0261929a3d3bbc`.

Repository preflight passed at the tested source commit in
`00:06:49.7701327`. The full Release build passed with 0 warnings and 0
errors:

```text
dotnet build FreeX.slnx --configuration Release
MSBuild 00:09:30.47; wrapper 00:09:30.8983681
```

Focused Wave198 validation passed: FreeX **3/3** after review remediation,
with the combined Wave198/Wave197 command at **5/5**; shared
`DialogTabChromeParityTests` **3/3**; FreeW target suite **32/32** plus the
FontDialog/Wave198 review suite **6/6**; and FreeP Wave198 evidence **2/2**.

This is an acceptance-only documentation/tooling refresh; it does not alter
the tested source commit. The refresh is restricted to exactly these six
paths:

- `tools/Generate-CrossAppParityDashboard.ps1`
- `tools/Test-CrossAppParityDashboard.ps1`
- `tests/FreeX.App.Host.Tests/CrossAppParityDashboardTests.cs`
- `docs/parity/avalonia-wpf-cross-app-dashboard.json`
- `docs/parity/avalonia-wpf-cross-app-dashboard.md`
- `docs/parity/avalonia-parity-wave198-cross-app-integration-20260829.md`

Delegated manifest-driven integration and UI/render/release-only GitHub
workflows were not run locally and are not represented as passed. Local gates
do not establish complete Avalonia/WPF parity.

## App Slices

### FreeX

The production Linux/X11 workflow selected `Arial` through the Home ribbon
font-family combo for cell `A1`, saved cleanly, and persisted
`style-id=1|font-id=1|font-name=Arial|font-family=true`. The physical evidence
run `20260829T040529Z` passed **1/1** and the focused Wave198 source tests
passed **3/3**. The durable evidence bundle's SHA-256 values are recomputed by
the focused FreeX source test.

Automatic combo-close focus was **not measured** before the explicit worksheet
reselect, so that focus-routing behavior remains unresolved. The subsequent
explicit `Right` and `Ctrl+C` check copied `B1=Unchanged`; this is bounded
workflow evidence, not a full-parity claim.

### FreeW

The shared Avalonia compact dialog tab chrome now preserves a one-pixel WPF
trailing pane frame when route authority provides negative right compensation.
Fresh route-local evidence improved all seven Table Properties states and all
three Borders/Shading control states:

- Table Properties changed pixels: `191369 -> 187872` (`-3497`).
- Borders/Shading changed pixels: `106540 -> 104932` (`-1608`).

The canonical comparison remains **291 rows: 141 genuine visual mismatches,
80 passes, and 70 Avalonia extensions**. The tracked raw bundle is
**metadata-only**: PNGs and route manifests are untracked/disposable, so the
recorded metrics and manifest hashes cannot independently inspect the pixels.
The correction is route-local evidence and does not establish complete FreeW
or Word visual parity.

### FreeP

The `SubpixelAntialias` candidate for the fixed-size Aptos deck17 slide02
residual was rejected. Avalonia/Office improved from `2.4820%` to `2.4583%`,
an improvement of `0.0237` percentage points, but WPF/Avalonia worsened from
`2.8755%` to `2.8847%`, a regression of `0.0092` points. The slide01 control
was unchanged. No production candidate is retained, and generation linkage is
explicitly **not independently proven**.

## Boundaries And Next Work

Wave197 acceptance remains preserved in the dashboard as historical context,
including its exact tested-source boundary and local-gate facts. Wave198 does
not rewrite that history. FreeW's 141 genuine visual mismatches and 70
Avalonia extensions remain open, FreeX automatic combo-close focus needs a
pre-reselect physical probe, and FreeP needs supported native Aptos/resource
or independently measured host glyph-raster evidence. The overall 100% parity
goal remains incomplete.
