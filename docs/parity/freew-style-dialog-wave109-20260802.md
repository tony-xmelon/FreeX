# FreeW Style Dialog Visual Parity Wave 109

Date: 2026-08-02

## Scope

This slice covers the paired FreeW `style.initial`, `style.populated`, and
`style.validation-error` dialog states. The WPF authority measures a 22-pixel
combo field, a 15-pixel formatting-checkbox row, and a 20-pixel action button
surface. Avalonia had retained a 21-pixel combo field and an 18-pixel checkbox
host, which accumulated vertical drift through the lower half of the dialog.

The WPF and Avalonia shells now consume the same presentation metrics. The
Avalonia correction remains local to the Style dialog and does not change the
shared compact-dialog defaults used by other routes.

## Fresh paired evidence

The current WPF/Avalonia harness captured all three states at the same
`327x442` frame size after the fix:

| State | Same-frame before changed ratio | After changed ratio | Before mean delta | After mean delta |
| --- | ---: | ---: | ---: | ---: |
| initial | 7.7228% | 3.7795% | 7.6444 | 4.1510 |
| populated | 7.8632% | 3.9203% | 7.9240 | 4.4273 |
| validation-error | 7.7228% | 3.7795% | 7.6444 | 4.1510 |

The refreshed canonical report also replaces the older Wave28 values of
16.0613%, 16.2677%, and 16.0613% with the current captures. The remaining
delta is primarily native text/control rasterization and WPF versus Avalonia
template detail; the state rows now share the same measured layout geometry.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.DesignDialogParityTests --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` -> 6 passed.
- Fresh WPF/Avalonia paired harness captures -> 3/3 states captured on each host.
- Refreshed `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.*` and freshness manifest.

## Residuals

The style family remains classified as genuine visual mismatch because the
report still measures 3.78%-3.92% changed pixels. This is not a claim of full
pixel identity; further work would need native-template and text-raster
normalization beyond the scoped layout correction.
