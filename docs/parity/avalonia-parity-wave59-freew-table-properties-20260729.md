# Wave 59 FreeW Table Properties Parity

Date: 2026-07-29  
Authority: WPF capture on the same 800 x 420 harness surface  
Base: `3e2cb12d55` (current `origin/main`, including the FreeP-only upstream change)

## Scope

This slice covers the seven canonical FreeW `table-properties` visual states and the directly shared Avalonia compact dialog chrome. FreeX and FreeP production code was not changed.

The checked-in evidence before this slice was stale after Wave 58 shared dialog typography and button-row changes: all seven rows were classified as `genuine-visual-mismatch` with `focus`. A fresh pre-edit recapture confirmed the visual mismatches, but the focus classification was setup drift rather than a product difference. The WPF authority capture now targets the same tab-specific text box by automation ID for every state, and the Avalonia route uses the same initial-focus contract.

## Before/after evidence

`changedRatio` is the fraction of compared pixels and `meanAbsoluteChannelDelta` is the mean RGB channel delta. The comparison thresholds and classifications were not weakened.

| State | Fresh pre-edit | Final | Final classification | Semantic difference |
|---|---:|---:|---|---|
| initial | 13.3961% / 8.4407 | 9.2119% / 6.7175 | genuine-visual-mismatch | none |
| populated | 13.5286% / 8.6327 | 9.2780% / 6.8179 | genuine-visual-mismatch | none |
| tab-cell | 9.6438% / 6.6459 | 6.6964% / 4.8618 | genuine-visual-mismatch | none |
| tab-column | 3.1131% / 2.5677 | 2.7295% / 2.1526 | pass | none |
| tab-row | 6.9783% / 5.0199 | 4.5557% / 3.7787 | genuine-visual-mismatch | none |
| tab-table | 13.3961% / 8.4407 | 9.2119% / 6.7175 | genuine-visual-mismatch | none |
| validation-error | 14.1872% / 9.1652 | 10.0577% / 7.5083 | genuine-visual-mismatch | none |

The focused family changed from 7 focus-bearing genuine mismatches to 1 pass and 6 unclassified genuine visual mismatches. Average final difference is 7.3916% changed pixels and 5.5078 mean channel delta, versus 10.6062% and 6.9875 on the fresh pre-edit captures.

## Changes

- Matched Table Properties tab-pane margins, row spacing, heading margins, label foreground, compact checkbox metrics, and WPF-authority label column widths.
- Matched WPF initial focus for the table, row, column, and cell tabs; added automation IDs used by the WPF capture harness.
- Normalized shared Avalonia dialog TextBlock and checkbox typography/foreground, and made compact dialog ComboBoxes stretch like the WPF fields.
- Refreshed the canonical HTML, JSON, Markdown, and freshness manifests using the final paired captures.

## Residuals

Six rows remain `genuine-visual-mismatch` because their changed-pixel ratios remain above the existing threshold. Paired images and heatmaps show matching content, control structure, tab state, validation state, focus target, and principal geometry. The remaining differences are concentrated in Avalonia/Skia versus WPF text rasterization and small template/border/button anti-aliasing and coordinate differences. They are documented as residuals here; they were not relabeled as passes and no threshold was changed.

## Shared chrome coverage

The shared TextBlock, checkbox, and ComboBox changes are covered by `CommonDialogChromeParityTests`, including a non-Table `ChromeProbeDialog` that is opened and laid out through the common `AvaloniaDialogWindow` route. This protects other FreeW dialogs from silently losing the shared typography/foreground contract.

## Verification

Focused tests:

```text
dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter "FullyQualifiedName~CommonDialogChromeParityTests|FullyQualifiedName~TablePropertiesDialogTests|FullyQualifiedName~WpfAuthoritySurfaceParityTests"
  21 passed, 0 failed

dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj -c Release --filter "FullyQualifiedName~TablePropertiesDialogTests"
  3 passed, 0 failed
```

Capture commands, run once per state in `initial populated validation-error tab-table tab-row tab-column tab-cell`:

```text
dotnet run --project freew\tools\FreeW.DialogVisualHarness.Wpf\FreeW.DialogVisualHarness.Wpf.csproj -c Release -- --inventory artifacts\wave59-table-properties-inventory.json --output artifacts\wave59-table-properties\final-wpf\<state> --scenario "wpf.table-properties.<state>"
dotnet run --project freew\tools\FreeW.DialogVisualHarness.Avalonia\FreeW.DialogVisualHarness.Avalonia.csproj -c Release -- --inventory artifacts\wave59-table-properties-inventory.json --wpf-authority artifacts\wave59-table-properties\final-wpf-authority.json --output artifacts\wave59-table-properties\geometry-avalonia\<state> --scenario "avalonia.table-properties.<state>"
```

Canonical refresh:

```text
dotnet run --project freew\tools\FreeW.DialogVisualHarness\FreeW.DialogVisualHarness.csproj -c Release -- compare --inventory docs\parity\freew-dialog-harness\freew_dialog_evidence_inventory.json --wpf artifacts\wave59-table-properties\final-wpf-authority.json --avalonia artifacts\wave59-table-properties\geometry-avalonia-authority.json --baseline docs\parity\freew-dialog-harness\freew_dialog_visual_comparison.json --refresh-route table-properties --output docs\parity\freew-dialog-harness
```

The canonical compare exits nonzero by design because other routes in the full inventory still contain genuine mismatches; it wrote the refreshed report successfully. All seven Table Properties capture commands reported `captured: 1; unsupported: 0`.
