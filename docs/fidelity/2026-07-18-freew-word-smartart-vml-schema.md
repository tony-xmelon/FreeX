# Word SmartArt And VML Schema Validity

FreeW previously wrote the private SmartArt preset IDs as unqualified attributes on
`dgm:styleDef` and `dgm:colorsDef`. Those attributes are outside the DrawingML schema
and can cause Word package validation or repair failures.

The writer now stores non-native preset metadata in the schema-supported
`dgm:extLst/a:ext` extension list. The reader prefers that payload, remains compatible
with the older attributes, and preserves the native `uniqueId` gallery identifier.
Empty/default metadata does not create an extension list.

The same validation sweep found an unrelated VML issue in the WordArt watermark
shapetype: `o:lock` requires `v:ext="edit"`, not an unqualified `ext`. The writer now
uses the standard VML namespace for that attribute.

Verification on the matching Release artifact:

- `SmartArtRoundTripTests`: 33/33 passed.
- `WordComparableDrawingFixtureDocxPassesOpenXmlSchema`: 5/5 passed, including the
  WordArt watermark fixtures that exercise the VML lock element.

This is a package/functionality slice. It does not claim a fresh Word COM raster
comparison while the external persistent Word baseline wrapper owns the document host.
