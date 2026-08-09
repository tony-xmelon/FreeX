# FreeW native print-date field parity

## Scope

- Refresh imported `PRINTDATE` fields from the preserved `/docProps/core.xml` `cp:lastPrinted` timestamp.
- Preserve the cached result when the package has no valid last-printed timestamp.
- Apply Word date-time picture switches through the shared culture-aware formatter.
- Preserve both complex and `w:fldSimple` forms through DOCX save and reopen.
- Offer `Print Date (PRINTDATE)` in the shared field picker and resolve its initial value in WPF and Avalonia.

## Word contract

Microsoft Word lists `PRINTDATE` as a native field and documents `\@` date-time pictures against it. OOXML `lastPrinted` records the date and time the package was last printed. FreeW already preserves that unmodeled core-property element, so the field reads the serialized timestamp without inventing print state.

## Acceptance

- Model contracts cover availability, source-backed formatting, and missing-source fallback.
- DOCX contracts cover complex and simple field forms plus `cp:lastPrinted` preservation after save and reopen.
- Shared picker, WPF, and Avalonia contracts cover insertion and F9 refresh from the same resolver.

Focused Release verification:

- `ComplexFieldEngineTests`: 76/76.
- `ComplexFieldUpdateRoundTripTests`: 8/8.
- `FieldPickerDialogPlannerTests`: 4/4.
- WPF `ComplexFieldEditorTests`: 22/22.
- Avalonia `FieldDisplayParityTests`: 14/14.
