# FreeW Avalonia parity wave 171: manual hyphenation semantics

## Scope

This slice closes the FreeW manual-hyphenation semantic cluster:

- `manual-hyphenation.initial`
- `manual-hyphenation.populated`
- `manual-hyphenation.validation-error`

The WPF dialog is the authority for focus, default/cancel actions, accessible action names, and action order. No visual comparator threshold or mismatch label was changed.

## Staleness finding

The tracked canonical audit rows were stale in two ways. They still reported the pre-`7856b05908` focus mismatch, while current source already projected `Choices` as the initial focus target. The current Avalonia route still had a source-owned realization gap: Fluent rebuilt button automation names from visible `Yes`/`No`/`Cancel` content after the shared surface contract had applied the WPF names. The resulting fresh current-source comparison therefore reported only `default-button,action-button-order` as semantic differences before this fix.

Fresh WPF authority and final Avalonia semantics for all three states are now:

| Semantic | WPF | Avalonia after |
| --- | --- | --- |
| Focus | `ManualHyphenationChoices` | `ManualHyphenationChoices` |
| Default | `Accept hyphenation` | `Accept hyphenation` |
| Cancel | `Cancel` | `Cancel` |
| Action order | Accept, Skip, Cancel | Accept, Skip, Cancel |

## Implementation

`ManualHyphenationDialog` reapplies the shared/WPF-authority automation names in its `Opened` callback, after Fluent has realized the button templates. The cancel action uses the localized shell cancel automation name, while Accept and Skip use the planner's localized field names. A focused Avalonia parity test asserts the realized names, default/cancel flags, focus target, and close behavior.

## Controlled evidence

Commands used, with route-local output under `%TEMP%`:

```text
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --route manual-hyphenation --output %TEMP%\freew-wave171-manual-hyphenation-after\wpf
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --route manual-hyphenation --output %TEMP%\freew-wave171-manual-hyphenation-after-final\avalonia
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release -- compare --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf %TEMP%\freew-wave171-manual-hyphenation-after\wpf\wpf_dialog_capture_manifest.json --avalonia %TEMP%\freew-wave171-manual-hyphenation-after-final\avalonia\avalonia_dialog_capture_manifest.json --output %TEMP%\freew-wave171-manual-hyphenation-after-final\compare
```

The fresh before/after comparison used the same WPF capture and the same unchanged visual thresholds. The before semantic difference was `default-button,action-button-order` for each row; after it was empty and classification moved from `semantic-mismatch` to `pass`.

| Scenario | Before semanticDifference | After semanticDifference | Before/after changed pixels | Before/after changed ratio | Before/after mean channel delta |
| --- | --- | --- | --- | --- | --- |
| initial | `default-button,action-button-order` | empty | 8570 / 8570 of 336000 | 0.0255059524 / 0.0255059524 | 1.7887242063 / 1.7887242063 |
| populated | `default-button,action-button-order` | empty | 8696 / 8696 of 336000 | 0.0258809524 / 0.0258809524 | 1.7884394841 / 1.7884394841 |
| validation-error | `default-button,action-button-order` | empty | 8696 / 8696 of 336000 | 0.0258809524 / 0.0258809524 | 1.7884394841 / 1.7884394841 |

The tracked canonical rows remain untouched because generated dashboards/manifests are outside this wave's write scope. Their prior visual deltas were approximately 2.09% (`initial`) and 2.12% (`populated`/`validation-error`); those values are not relabeled or used as refreshed artifacts here. The route-local pixel deltas above are reported as captured, and the semantic correction does not claim a raster improvement.

## Best next FreeW slice

Refresh the route-local canonical aggregation for this manual-hyphenation cluster, then take the next highest-impact FreeW semantic row whose current capture still disagrees with WPF after excluding stale generated evidence.
