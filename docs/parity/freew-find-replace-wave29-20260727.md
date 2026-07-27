# FreeW Find/Replace Dialog Wave 29

Scope: bounded visual parity correction for the Avalonia `find-replace.initial` dialog.

The WPF authority renders compact 14px checkbox indicators. Avalonia was using its default checkbox template, which rendered larger indicators and pushed the option labels to the right. The Avalonia dialog now uses the existing `AvaloniaCompactDialogChrome.ApplyCompactCheckBox` helper for Match case, Whole word, and Use wildcards only. Shared chrome defaults were not changed.

## Evidence

Both captures were rendered at the same 560 x 600 logical size.

| Metric | Before | After |
|---|---:|---:|
| Changed-pixel ratio | 15.1789% | 7.8673% |
| Mean absolute channel delta | 8.1110 | 5.4434 |
| P95 absolute channel delta | 34 | 25 |

The after frame remains a genuine visual mismatch because Avalonia and WPF still rasterize text and native control chrome differently; the checkbox geometry is materially closer.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter FullyQualifiedName~FindReplaceDialogPolicySourceGuardTests`
- Focused source guard: 1/1 passed.
- Fresh paired WPF/Avalonia captures and harness comparison completed from the same logical target size.
