# FreeW Style Dialog Visual Parity Wave 28

Date: 2026-07-27

## Scope

The canonical FreeW paired-dialog report ranked `style.initial` as the next
actionable non-semantic row after excluding Paragraph, Legal Notices, and the
Backstage rows whose remaining difference includes action-button ordering.

The Avalonia Style dialog now opts into a 21 logical-pixel control height. WPF
authority captures show the compact combo fields at that height; the shared
Avalonia dialog defaults remain 22 pixels for other dialogs.

## Fresh paired evidence

All captures used the WPF-authority frame size and were generated after the
change for `style.initial`, `style.populated`, and `style.validation-error`.

| State | Before changed ratio | After changed ratio | Before mean delta | After mean delta | Avalonia painted height |
| --- | ---: | ---: | ---: | ---: | ---: |
| initial | 16.0613% | 12.9601% | 10.3654 | 10.3003 | 371 -> 366 |
| populated | 16.2677% | 13.12% | 10.5772 | 10.57 | 371 -> 366 |
| validation-error | 16.0613% | 12.96% | 10.3654 | 10.30 | 371 -> 366 |

The initial row is a 19.3% relative reduction in changed pixels. The other
states show the same compacting effect, with only a small mean-raster delta
change because Linux text and native control rendering remain different.

## Residuals

The dialog still differs in Avalonia combo-box chrome, checkbox glyph raster,
font anti-aliasing, and button/control template details. This slice does not
claim complete Style-dialog parity and does not change shared defaults.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~DesignDialogParityTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"` -> 6 passed.
- Fresh WPF/Avalonia paired harness captures: three states, all captured and content-valid.
