# FreeW native template fields (2026-08-09)

## Scope

- Refresh imported `TEMPLATE` fields from the preserved `docProps/app.xml` `Template` value.
- Refresh `DOCPROPERTY Template` through the same package-authoritative path.
- Expose `Template (TEMPLATE)` in the shared Insert Field picker and resolve its initial result in WPF and Avalonia.
- Preserve the cached Word result for `TEMPLATE \\p`; the full attached-template path belongs to the preserved external relationship graph and is not yet a modeled FreeW value.

## Word contract

Microsoft documents `TEMPLATE` as the attached document template's file name and `\\p` as the switch that includes the file location. Open XML defines `ap:Template` as the name of the document template.

- https://support.microsoft.com/en-us/word/field-codes-template-field
- https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.extendedproperties.properties.template

## Acceptance

- Shared model: plain `TEMPLATE`, `DOCPROPERTY Template`, general text formats, cached `\\p`, and malformed/missing package fallback.
- DOCX: field instructions and `app.xml` survive save/reopen before recomputation.
- Editors: WPF and Avalonia F9 refresh the same imported values; picker insertion starts with the package value instead of an empty result.
- Full FreeW Release solution build.
