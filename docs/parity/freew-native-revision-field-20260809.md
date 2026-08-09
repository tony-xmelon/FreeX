# FreeW native revision field parity

## Scope

- Refresh imported `REVNUM` fields from the preserved `/docProps/core.xml` `cp:revision` value.
- Preserve the cached field result when the package has no usable revision value.
- Preserve both complex and `w:fldSimple` forms through DOCX save and reopen.
- Offer `Revision Number (REVNUM)` in the shared field picker and resolve its initial value in WPF and Avalonia.
- Honor Word's numeric general-format switches for Roman and alphabetic revision display through the existing sequence formatter.

## Word contract

Microsoft documents `REVNUM` as the field that inserts the number of times a document has been saved. In OOXML packages that value is serialized as `cp:revision` in `/docProps/core.xml`. FreeW already preserves unmodeled core-property elements, so the field resolver reads that source payload without duplicating it into a second metadata model.

## Acceptance

- Model contracts cover availability, package-backed refresh, numeric formatting, and missing-source fallback.
- DOCX contracts cover complex and simple field forms plus `cp:revision` preservation after save and reopen.
- Shared picker, WPF, and Avalonia contracts cover insertion and F9 refresh from the same resolver.

Focused Release verification:

- `ComplexFieldEngineTests`: 73/73.
- `ComplexFieldUpdateRoundTripTests`: 6/6.
- `FieldPickerDialogPlannerTests`: 4/4.
- WPF `ComplexFieldEditorTests`: 18/18.
- Avalonia `FieldDisplayParityTests`: 10/10.
