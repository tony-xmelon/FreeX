# FreeW Legal Notices pane registration — 2026-08-24

## Scope

This slice aligns the selected Legal Notices document pane with the WPF authority
without changing notice content, dialog semantics, tab headers, or shared metrics.
Ink/Draw and map-chart fidelity remain outside the active parity scope.

## Evidence

Fresh route-local WPF and Avalonia captures used the tracked dialog inventory and
the complete `legal-notices` route at 96 DPI. The WPF authority renders a shorter
tab header; Avalonia's compact header otherwise pushed the selected document pane
four pixels lower. `AvaloniaLegalNoticesDialog` now uses a local `-5` selected-pane
margin (instead of `-1`) so the document border and first text baseline register
with the WPF surface while the header remains unchanged.

| State | Before changed / mean delta | After changed / mean delta |
| --- | ---: | ---: |
| Initial / Project License | 8.96% / 10.16 | 8.57% / 9.76 |
| Legal Notices | 20.68% / 23.82 | 20.08% / 22.97 |
| Privacy Notice | 18.44% / 20.12 | 17.84% / 19.29 |
| Third-Party License Texts | 19.25% / 22.91 | 18.89% / 22.39 |
| Third-Party Notices | 18.42% / 21.59 | 18.38% / 21.60 |

The final `0.01` mean-delta variance in Third-Party Notices and perceptual-hash
movement are native WPF DirectWrite versus Avalonia Skia glyph rasterization; the
paired screenshots show aligned chrome, tabs, viewport, wrapping, scrollbar lane,
and action button. No further font or spacing distortion is justified by this
evidence.

## Verification

```
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"
```

Result: 14 passed, 0 failed.
