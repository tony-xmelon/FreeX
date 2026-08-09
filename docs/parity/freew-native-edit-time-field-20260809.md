# FreeW native edit-time field parity

## Scope

- Refresh imported `EDITTIME` fields from the preserved `/docProps/app.xml` `TotalTime` value.
- Interpret `TotalTime` in its OOXML-defined default unit of minutes.
- Preserve the cached field result when the package source is absent or malformed.
- Preserve both complex and `w:fldSimple` forms through DOCX save and reopen.
- Offer `Edit Time (EDITTIME)` in the shared field picker and resolve its initial value in WPF and Avalonia.
- Honor Roman and alphabetic general-number switches through the existing integer field formatter.

## Word contract

Word defines `EDITTIME` as the document's total editing time in minutes, corresponding to the Total editing time statistic. OOXML serializes that source as `TotalTime` in `/docProps/app.xml`, whose default unit is minutes. FreeW already preserves that part byte-for-byte, so the field resolver reads the serialized source rather than maintaining a competing timer.

## Negative path evidence

A live owned Word probe rejected `DOCPROPERTY` statistic aliases such as `Number of Words`, `Number of Characters`, and `Number of Paragraphs` with `Error! Unknown document property name.` No aliases were added from that hypothesis. The owned automation process was reaped by its exact PID and no `WINWORD` process remained.

## Acceptance

- Model contracts cover availability, package-backed minutes, numeric general formatting, and missing-source fallback.
- DOCX contracts cover complex and simple field forms plus `TotalTime` preservation after save and reopen.
- Shared picker, WPF, and Avalonia contracts cover insertion and F9 refresh from the same resolver.

Focused Release verification:

- `ComplexFieldEngineTests`: 75/75.
- `ComplexFieldUpdateRoundTripTests`: 7/7.
- `FieldPickerDialogPlannerTests`: 4/4.
- WPF `ComplexFieldEditorTests`: 20/20.
- Avalonia `FieldDisplayParityTests`: 12/12.
