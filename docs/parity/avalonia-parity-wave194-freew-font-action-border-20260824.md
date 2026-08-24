# Avalonia/WPF FreeW Font Dialog Parity - Wave 194

Date: 2026-08-24
Source revision: `932b83881429565399548f4bcd0457daf0100df8`
Scope: FreeW Font dialog, all three canonical states (`initial`, `populated`, `validation-error`)

## Accepted correction

The Avalonia Font dialog now uses the Windows-style light non-default action-button border (`#C8C8C8`) instead of the darker generic border (`#707070`). The change is local to the FreeW Avalonia Font dialog and keeps the existing button dimensions, command semantics, focus behavior, and accessibility surface unchanged.

## Canonical evidence

Fresh WPF and Avalonia captures were taken for all three states at `460x383`. Every capture passed the content gate. The WPF and Avalonia painted bounds are identical for every state: `x=12, y=12, width=421, height=321`.

| State | Wave 193 changed pixels | Wave 194 changed pixels | Delta | Mean channel delta | p95 | pHash distance |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| initial | 10,782 | 10,599 | -183 | 5.643094 | 18 | 0 |
| populated | 10,939 | 10,756 | -183 | 5.731243 | 19 | 0 |
| validation-error | 11,140 | 10,957 | -183 | 5.885880 | 22.333333 | 0 |
| **aggregate** | **32,861** | **32,312** | **-549** |  |  |  |

The aggregate improvement is `1.6712%`. The canonical evidence remains `512` scenarios with `221` WPF captures and `291` Avalonia captures. All `288` non-Font rows are byte-for-byte unchanged.

## Residual classification

The remaining Font mismatch is distributed across native text and control rasterization: checkbox edge and glyph pixels, tab-template details, action-row text/chrome, and the host/native transparent-frame treatment. The accepted action-row probe removed its repeated border residual without changing the dialog bounds. A transparent-background probe was a no-op, and changing the Avalonia tab-pane top margin regressed each state by more than 3,400 changed pixels; both probes were rejected.

## Verification

- Focused build: `dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings/errors.
- Focused tests: `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~FontDialog"` - passed, 32/32.
- Inventory regeneration/check - passed, `512` scenarios and `180` routes.
- Canonical comparison refresh - produced the expected `141` genuine mismatches, `80` passes, and `70` Avalonia extensions; the route-only refresh exits `2` because the Font route remains a genuine visual mismatch.
- Canonical comparison `--check` - passed.
- Provenance is recorded in `docs/parity/freew-dialog-harness/freew_font_visual_provenance.json` with source, input, row, and fresh external manifest hashes.

The Wave193 cross-app dashboard/acceptance boundary was intentionally not run or modified; integration must reopen it after all app slices are merged.
