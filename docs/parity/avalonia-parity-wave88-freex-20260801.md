# FreeX Avalonia parity Wave 88: external-reference point editing

Date: 2026-08-01

## Concrete divergence

Avalonia recovered the authored trailing formula-reference token when a physical point-mode edit
lost its tracked selection span. WPF still inserted a picked cell at the caret. For an existing
external-workbook formula such as `=SUM('[Data File.xlsx]Sheet1'!A1)`, F2 followed by a cell pick
therefore replaced the token in Avalonia but appended the new reference in WPF.

## Change and evidence

The shared `FormulaRangeEntryPlanner` now resolves a valid tracked span or recovers the trailing
authored token from the editor caret. WPF and Avalonia use that same decision for point replacement
and disjoint Ctrl/Meta append. Paired host coverage proves an external reference can be replaced
with a local point reference, committed, and then restored unchanged by Escape:

- WPF `R93_ExistingFormulaCrossSheetPointingTests.ExistingExternalFormula_PointReplacementCommitsAndEscapeRestoresOriginal`.
- Avalonia `R93_ExistingFormulaCrossSheetPointingTests.ExistingExternalFormula_PointReplacementCommitsAndEscapeRestoresOriginal`.

## Remaining depth

FreeX still treats external workbooks as cached link metadata; it does not open an external source
workbook as a live point-selection surface. External-reference highlighting and reference cycling
remain separate follow-up depth for imported formulas, as do multi-window source-workbook picking
gestures.
