# FreeW native template fields (2026-08-09)

## Scope

- Refresh imported `TEMPLATE` fields from the preserved `docProps/app.xml` `Template` value.
- Refresh `DOCPROPERTY Template` through the same package-authoritative path.
- Expose `Template (TEMPLATE)` in the shared Insert Field picker and resolve its initial result in WPF and Avalonia.
- Refresh `TEMPLATE \\p` from the preserved `w:attachedTemplate` external relationship, converting file URIs to Word-style paths while retaining the cached result for missing or malformed relationship data.

## Word contract

Microsoft documents `TEMPLATE` as the attached document template's file name and `\\p` as the switch that includes the file location. Open XML defines `ap:Template` as the name of the document template.

- https://support.microsoft.com/en-us/word/field-codes-template-field
- https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.extendedproperties.properties.template

## Acceptance

- Shared model: plain `TEMPLATE`, `DOCPROPERTY Template`, path-aware `\\p`, general text formats, and malformed/missing package fallback.
- DOCX: field instructions, `app.xml`, and the attached-template relationship survive save/reopen before recomputation.
- Editors: WPF and Avalonia F9 refresh the same imported values; picker insertion starts with the package value instead of an empty result.
- Full FreeW Release solution build.
