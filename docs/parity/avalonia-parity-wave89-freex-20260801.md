# FreeX Avalonia parity Wave 89: external-reference token preparation

Date: 2026-08-01

## Scope

Wave 88 left live source-workbook point selection open. Full cross-window pointer capture needs a
shared edit-session/source-window contract that the current WPF and Avalonia registries do not yet
provide, so this wave implements the shared prerequisite that directly prepares that workflow:
external-workbook references are now recognized as atomic formula tokens by the shared presentation
parser used by both hosts.

## Change

- `FormulaReferenceHighlightPlanner` recognizes both quoted and unquoted external qualifiers:
  `'[Data File.xlsx]Sheet1'!A1` and `[Data File.xlsx]Sheet1!A1`.
- The shared `FormulaReferenceSheetQualifier` and `FormulaReferenceHighlight` carry the decoded
  external workbook name separately from the sheet name.
- External tokens remain colored in the formula bar and inline editor, while their `GridRange`
  stays unresolved. This prevents a same-named local sheet from receiving a false reference box
  until a live source-workbook resolver exists.
- Reference scanning runs before structured-selector skipping, so `[Data File.xlsx]Sheet1!A1`
  is highlighted as one token instead of losing its qualifier and highlighting only `A1`.
- Shared F4 cycling is covered for an external-qualified token and preserves the complete
  workbook/sheet qualifier while changing the cell's absolute/relative anchors.

## Exact proof

- WPF paired host tests: `R89_ExternalFormulaReferenceParityTests`, **2/2 passed**.
- Avalonia paired host tests: `R89_ExternalFormulaReferenceParityTests`, **2/2 passed**.
- Existing shared formula/highlight/range-entry tests: **50/50 passed**.
- Wave 88 external point-edit regression, WPF: `R93_ExistingFormulaCrossSheetPointingTests`,
  **2/2 passed**.
- Wave 88 external point-edit regression, Avalonia: `R93_ExistingFormulaCrossSheetPointingTests`,
  **2/2 passed**.

Commands:

```text
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R89_ExternalFormulaReferenceParityTests" --logger "console;verbosity=minimal"
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R89_ExternalFormulaReferenceParityTests" --logger "console;verbosity=minimal"
dotnet test tests\FreeX.App.Host.Logic.Tests\FreeX.App.Host.Logic.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~FormulaReferenceHighlightPlannerTests|FullyQualifiedName~ExcelTextEditorPlannerTests|FullyQualifiedName~FormulaRangeEntryPlannerTests" --logger "console;verbosity=minimal"
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R93_ExistingFormulaCrossSheetPointingTests" --logger "console;verbosity=minimal"
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R93_ExistingFormulaCrossSheetPointingTests" --logger "console;verbosity=minimal"
```

## Residuals

- External workbooks are still cached-link metadata. The registries do not yet route a live
  point-mode gesture across two workbook windows or bind an external workbook token to a source
  window and source sheet.
- External tokens intentionally receive no local grid highlight or formula-reference grip until
  that source-window resolver is added. Text highlighting and F4 token cycling are available now.
- The unquoted form stops the workbook name at the first `]`; quoted workbook/sheet qualifiers are
  preserved verbatim for names that need spaces or other punctuation.
- This wave used focused foreground tests only; it did not claim full-solution or physical
  cross-window UI proof.
