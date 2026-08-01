# FreeW Legal Notices Visual Parity Wave 94

Date: 2026-08-01
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures
Scope: FreeW Avalonia Legal Notices long-document template at 620x600

## Change

The shared Avalonia read-only document template now reserves the WPF-sized 18-pixel
vertical scrollbar lane. This keeps the long-document text viewport from becoming wider
under the Fluent template and reduces wrapping drift across all four long tabs. The helper
also restores WPF's top/left multiline content alignment and focused document border color
(`RGB 86,157,229`), with an idempotence guard because the dialog reapplies the template after
opening. Tabs, scrolling, focus, copy, default/cancel behavior, and automation metadata remain
unchanged.

## Fresh Four-State Evidence

The WPF authority and final Avalonia captures were freshly rendered from this worktree. Both
hosts captured all four scenarios at 620x600; no row was unsupported or content-gate invalid.
Raw captures and the paired report are outside the repository under
`%TEMP%\freex-wave94-legal`:

- `before-wpf/wpf_dialog_capture_manifest.json`
- `final-avalonia/avalonia_dialog_capture_manifest.json`
- `final-compare/freew_dialog_visual_comparison.json`
- `final-compare/heatmaps/`

| State | Before changed | Final changed | Delta | Before mean | Final mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `tab-legal-notices` | 19.4097% | 19.3906% | -0.0191 pp | 21.363 | 21.271 |
| `tab-privacy-notice` | 16.6530% | 16.5629% | -0.0902 pp | 18.120 | 18.049 |
| `tab-third-party-license-texts` | 18.8288% | 18.6140% | -0.2148 pp | 20.558 | 20.543 |
| `tab-third-party-notices` | 19.8530% | 19.6634% | -0.1895 pp | 22.445 | 22.423 |
| **Average** | **18.6861%** | **18.5577%** | **-0.1284 pp** | **20.621** | **20.572** |

All four rows remain `genuine-visual-mismatch`. The reduction is measurable but bounded;
remaining differences are cross-framework Consolas glyph rasterization, native scrollbar
painting, tab/control template pixels, and focus/chrome details. No comparator threshold or
classification was changed.

## Verification

Focused runtime tests passed 3/3:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"
```

Fresh evidence commands used the four-state inventory from Wave93 and a newly captured WPF
authority. The capture commands returned 4/4 scenarios; the comparator returned exit code 1
because all four rows are intentionally still genuine visual mismatches.
