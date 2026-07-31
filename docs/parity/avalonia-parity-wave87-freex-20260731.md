# FreeX Avalonia parity Wave 87: existing formula cross-sheet pointing

Date: 2026-07-31

## Concrete divergence

WPF keeps an existing formula Edit session alive when the user clicks a sheet tab, including a
Shift-click that seeds a 3-D sheet span for the next reference. Avalonia preserved the edit
session itself, but only ran the shared sheet-span planner for fresh `=` point mode. An existing
formula edit followed by sheet-tab navigation and F2 therefore lost the selected sheet span and
inserted only the final sheet qualifier.

## Change and evidence

Avalonia now routes any active formula-reference editor through the shared
`FormulaSheetSpanEntryPlanner`, matching WPF. Existing formula Edit mode, sheet-tab navigation,
F2 point mode, and the final cell pick now produce the same quoted 3-D reference.

Paired runtime regression coverage:

- WPF `R93_ExistingFormulaCrossSheetPointingTests`.
- Avalonia `R93_ExistingFormulaCrossSheetPointingTests`.

The change is limited to the Avalonia sheet-tab lifecycle, paired host tests, and this parity note.
