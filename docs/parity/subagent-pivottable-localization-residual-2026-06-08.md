# PivotTable Localization Residual - 2026-06-08

## Scope

- Addressed the bounded satellite-resource gap for PivotTable Analyze `Field Headers` and `+/- Buttons` labels/tooltips.
- Added the six missing neutral resource keys to every `Strings.*.resx` satellite using neutral English values as fallback-safe placeholders.
- Added a focused EU satellite resource test that guards these PivotTable field-header/plus-minus keys directly, alongside the broader neutral-key parity check.

## Keys

- `MainWindow_Content_FieldHeaders`
- `MainWindow_Content_PlusMinusButtons`
- `MainWindow_TooltipDescription_ShowOrHideExpandCollapseButtonsForTheSelectedPivotTable`
- `MainWindow_TooltipDescription_ShowOrHideFieldCaptionsAndFilterDropDownsForTheSelectedPivotTable`
- `MainWindow_TooltipTitle_FieldHeaders`
- `MainWindow_TooltipTitle_PlusMinusButtons`

## Verification

- Worker verification: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~EuLocalizationResourceTests|FullyQualifiedName~BulgarianLocalizationTests" --logger "trx;LogFileName=pivottable-localization-tests.trx" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` passed: 137 passed, 0 failed.

## Remaining Gap

The added satellite values are neutral English fallback-safe placeholders, not a human translation pass.
