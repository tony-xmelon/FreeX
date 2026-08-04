# Avalonia Parity Wave 137: FreeW Backstage Export

Date: 2026-08-04

## Scope

This slice targets the highest current untouched non-Legal FreeW visual
residual, `backstage-export.open`, at the dialog harness contract of 560x600.
The WPF Export pane uses the WPF backstage scrollbar contract: a 17-DIP
vertical lane with a one-pixel right inset and the WPF track/thumb palette.
Avalonia Export was using the generic scrollbar path, while the equivalent
FreeW Open pane already used the route-local WPF treatment.

## Change

FreeW Avalonia now opts the Export action pane into the existing WPF scrollbar
geometry and styling helper. The action planner, labels, descriptions, order,
callbacks, accessibility identifiers, and export routing are unchanged. No
shared shell default was modified.

## Evidence

Both paired frames are 560x600. The accepted WPF authority frame passed the
existing content gate. A fresh WPF attempt on this host was rejected by that
same gate as blank (`0.00%` opaque, `100%` near-black, no meaningful painted
bounds), so it was not promoted or used as authority. The fresh Avalonia frame
passed the full and target content gates. The fresh capture and focused
comparison were generated under the ignored temporary directory
`%TEMP%/FreeW-Wave137-Export-FinalCompare-20260804/` during validation. Only
the canonical comparison artifacts are retained and committed.

| Metric | Previous canonical row | Final paired row | Change |
| --- | ---: | ---: | ---: |
| Changed pixels | 45,833 | 40,578 | -5,255 |
| Changed ratio | 0.1364077381 | 0.1207678571 | -0.0156398810 |
| Mean absolute channel delta | 10.8529494 | 10.3659375 | -0.4870119 |
| P95 absolute channel delta | 106 | 106 | unchanged |
| Luminance similarity | 0.8660733343 | 0.8668089664 | +0.0007356320 |
| Perceptual hash distance | 12 | 12 | unchanged |

The row remains classified `genuine-visual-mismatch`; no comparison threshold
or evidence classification was changed. The canonical comparison refresh was
limited to the Export route rows in the JSON, Markdown, HTML, and freshness
artifacts. The cross-app dashboard is intentionally outside this slice.

## Verification

- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~BackstageViewTests.Export_pane_preserves_shared_WPF_authority_button_order_and_geometry" --logger "console;verbosity=minimal" -m:1` - 1 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests" --logger "console;verbosity=minimal" -m:1` - 40 passed.
- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~Backstage" --logger "console;verbosity=minimal" -m:1` - 75 passed.
- Fresh Avalonia Export capture - 1/1 captured and content-gated.
- Fresh WPF Export capture - rejected by the existing blank-frame content gate; not used.
- Focused comparison - 1 paired row, expected `genuine-visual-mismatch` exit status.

## Residual

The remaining difference is primarily framework text rasterization and the
native scrollbar template footprint. Avalonia still reports 44 distinct colors
versus 225 in the accepted WPF frame, so the residual is not evidence that the
route should be reclassified as a pass.
