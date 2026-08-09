# Extended Document Property Fields

## Scope

FreeW now refreshes Word `DOCPROPERTY Company` and `DOCPROPERTY Manager`
fields from the source document's extended properties part (`docProps/app.xml`).
The shared field engine remains the single F9 owner, so WPF and Avalonia produce
the same result and continue to honor Word text general-format switches.

Missing values, a missing part, or malformed extended-property XML retain the
field's cached Word result instead of blanking visible content. A custom
property with the same name remains a fallback when the built-in extended
property is absent.

## Package Ownership

The existing preserved `app.xml` bytes are authoritative. FreeW parses them
through the shared secure OPC reader for field evaluation but does not rebuild
or normalize the part. Save/reopen therefore retains its package-root
relationship, content type, and unmodeled application properties.

Microsoft's Open XML documentation identifies Company and Manager as extended
application properties and demonstrates reading them from a Word document's
`ExtendedFilePropertiesPart`:

- [Retrieve application property values from a Word document](https://learn.microsoft.com/en-us/office/open-xml/word/how-to-retrieve-application-property-values-from-a-word-processing-document)
- [Company extended property](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.extendedproperties.company?view=openxml-3.0.1)
- [Manager extended property](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.extendedproperties.manager?view=openxml-3.0.1)

## Verification

- Shared complex-field engine regression class: 71/71
- Package field-update round-trip class: 4/4
- WPF complex-field editor class: 14/14
- Avalonia field-display parity class: 6/6

The package test reopens fields and the package-root extended-properties part,
then recomputes both values from the preserved payload. Host tests combine
core, extended, and document-variable fields in one update pass.
