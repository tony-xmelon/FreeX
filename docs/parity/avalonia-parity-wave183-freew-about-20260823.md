# Avalonia Parity Wave 183: FreeW About Dialog

Date: 2026-08-23  
Scope: FreeW About `initial`, `populated`, and `validation-error` paired visual slice

## Diagnosis

The retained canonical comparison row was a genuine visual mismatch at `0.1450595238`
changed pixels, with mean absolute channel delta `15.68762698` and pHash distance `3`.
Fresh WPF authority capture was required because the tracked comparison images are not
authority baselines for this slice and are not changed here.

The fresh pre-edit pair showed exact outer painted bounds but different realization inputs:
Avalonia used a wider text viewport (`right padding 0` versus WPF's native 8-DIP TextBox
inset), a 12.3-DIP font size, a 4-DIP excess top inset, a slightly tall line box, and a neutral
OK border where the FreeW WPF default button uses the theme accent. There was no About icon or
other product branding asset in the captured surface to correct; the content contract was
already identical and all semantic fields matched.

## Correction

`AboutDialogPresentation` now carries optional Avalonia realization inputs so the shared About
host remains reusable without changing WPF or other product defaults. FreeW supplies the measured
WPF-aligned values: 8-DIP right padding, 12-DIP text, 9-DIP top padding, 16.6-DIP line height,
and an accent default-button border. The WPF `SharedAboutDialog` and its metrics are unchanged.

The focused Avalonia authority test protects those FreeW inputs, while the presentation test
protects the shared host contract and renderer-neutral About content.

## Fresh Evidence

Fresh artifacts were captured under:

- `artifacts/wave183-freew-about-before-wpf`
- `artifacts/wave183-freew-about-before-avalonia`
- `artifacts/wave183-freew-about-final-wpf`
- `artifacts/wave183-freew-about-final-avalonia-v2`
- `artifacts/wave183-freew-about-final-comparison-v2`

The WPF authority was captured both before and after the Avalonia-only correction; WPF source and
metrics were intentionally unchanged, and the before/final metrics below are stable across the
fresh paired runs. All six final images passed the existing pixel-content gates at `560x600`; the
comparison threshold and classification logic were not changed.

| State | Before changed pixels | After changed pixels | Before ratio | After ratio | Before mean channel delta | After mean channel delta | Before pHash | After pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `about.initial` | 57,179 | 49,286 | 17.0175595% | 14.6684524% | 18.4823333 | 14.4326052 | 7 | 6 |
| `about.populated` | 57,179 | 49,286 | 17.0175595% | 14.6684524% | 18.4823333 | 14.4326052 | 7 | 6 |
| `about.validation-error` | 57,179 | 49,286 | 17.0175595% | 14.6684524% | 18.4823333 | 14.4326052 | 7 | 6 |

`p95AbsoluteChannelDelta` also improved from `151.6666667` to `126`. WPF and Avalonia painted
bounds were unchanged in every state: before `x=16,y=16,width=513,height=531`; after
`x=16,y=16,width=513,height=531`. Semantic difference remained `null` before and after. The
final rows remain honestly classified as `genuine-visual-mismatch` because cross-toolkit glyph
rasterization and native text/control chrome still produce visible residual pixels.

Commands used for the fresh route evidence:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --output artifacts/wave183-freew-about-before-wpf --route about
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf-authority artifacts/wave183-freew-about-before-wpf/wpf_dialog_capture_manifest.json --output artifacts/wave183-freew-about-before-avalonia --route about
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --output artifacts/wave183-freew-about-final-wpf --route about
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf-authority artifacts/wave183-freew-about-final-wpf/wpf_dialog_capture_manifest.json --output artifacts/wave183-freew-about-final-avalonia-v2 --route about
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj --configuration Release --no-build -- compare --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf artifacts/wave183-freew-about-final-wpf/wpf_dialog_capture_manifest.json --avalonia artifacts/wave183-freew-about-final-avalonia-v2/avalonia_dialog_capture_manifest.json --output artifacts/wave183-freew-about-final-comparison-v2
```

The tracked canonical aggregate and cross-app dashboard were not regenerated or edited.

## Verification

- FreeW Dialog Visual Harness WPF build: passed, 0 warnings/errors.
- FreeW Dialog Visual Harness Avalonia build: passed, 0 warnings/errors.
- `FreeWProductInfoTests`: 3/3 passed.
- `WpfAuthoritySurfaceParityTests.About_uses_the_full_WPF_authority_content_and_modal_keyboard_shape`: 1/1 passed.
- `FreeWHelpInfoTests.AboutDialog_ExposesStableAutomationMetadata`: 1/1 passed.
