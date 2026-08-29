# Avalonia/WPF Cross-App Parity Wave197 Integration

Date: 2026-08-29
Wave: 197
Status: accepted-local-gates

## Integration Status

Wave197 records three app slices and cumulative **591 app slices (197 per
app)**. Overall 100% parity remains incomplete. The exact tested source commit
is `a6b1f27e02d15a7495644db64c9bda3a839f126a`.

Repository preflight passed in Mode All with exit 0. The full Release build
passed with 0 warnings and 0 errors:

```text
dotnet build FreeX.slnx --configuration Release
MSBuild 00:07:04.93; wrapper 00:07:05.2629619
```

Focused validation at the exact tested head passed: FreeX **16/16**, FreeW
**20/20**, and FreeP **4/4**. Final independent review found no P1/P2 findings
after all remediation.

This is an acceptance-only documentation/tooling refresh; it does not alter
the tested source commit. The refresh is restricted to exactly these six
paths:

- `tools/Generate-CrossAppParityDashboard.ps1`
- `tools/Test-CrossAppParityDashboard.ps1`
- `tests/FreeX.App.Host.Tests/CrossAppParityDashboardTests.cs`
- `docs/parity/avalonia-wpf-cross-app-dashboard.json`
- `docs/parity/avalonia-wpf-cross-app-dashboard.md`
- `docs/parity/avalonia-parity-wave197-cross-app-integration-20260829.md`

The delegated manifest-driven integration and UI/render/release-only GitHub
workflows were not run locally and are not represented as passed. Local gates
do not establish complete Avalonia/WPF parity.

## App Slices

### FreeX

The production slice retains ordinary bubble key routing. One deferred
combo-dismiss callback rechecks focus immediately and synchronously restores
worksheet focus. The current physical Docker/X11 report
`20260829T013532Z` passed **1/1** with `save-clean=true`, `style-id=1`,
`numFmtId=2`, and `number-format=true`.

The physical report provenance is
`9c1fd10cb61dc5bf324502ba68fc47d939436624`. The later exact tested head
differs only by the FreeW evidence/test commit `a6b1f27e02`, not by FreeX
production source. This is bounded production evidence, not a full-parity
claim.

### FreeW

No production candidate is retained. The selected-tab surface-margin candidate
regressed all six Legal Notices rows. The 16px line-box candidate improved two
long rows and regressed two long rows; it was rejected.

Clean-checkout tracked raw evidence and checksums are retained, with exact
unique six-scenario validation. Focused validation passed **20/20**. The
canonical FreeW inventory remains **291** rendered rows: **80** pass, **141**
genuine visual mismatches, and **70** Avalonia extensions. These counts remain
evidence and triage metrics, not visual or functional completion.

### FreeP

No production candidate is retained. Leading and baseline-alignment candidates
were rejected. Tracked image bytes/hashes and the recorded source commit are
verified, but image-generation linkage is explicitly unproven. The residual
remains unresolved text-raster evidence, not a fallback-font diagnosis.

Focused validation passed **4/4**. This is bounded renderer evidence and does
not establish complete FreeP or PowerPoint visual parity.

## Boundaries

Current app inventory counts are retained. FreeW retains **141 genuine visual
mismatches** and **70 Avalonia extensions**. No visual or functional completion
claim is made, and the overall 100% parity goal remains incomplete.

Wave196 acceptance remains preserved as historical nested dashboard context,
including its exact tested-source boundary, accepted local gates, and prior
evidence. The Wave197 refresh does not rewrite that historical acceptance.
