# Native VML Picture Watermark Import

## Scope

`DocxReader` now imports Word's native VML picture watermark when FreeW custom
watermark properties are absent. The reader recognizes
`PowerPlusPictureWaterMarkObject` in a header, resolves its image through that
header part's own relationship map, and retains the source image, opacity, and
horizontal or diagonal orientation.

## Source Authority

The header-local VML payload is the fallback authority for documents created by
Word or another producer. FreeW custom watermark metadata remains authoritative
when present, so FreeW-authored documents keep their existing semantic path.

Both common VML image encodings are accepted:

- `v:fill/@r:id`
- `v:imagedata/@r:id`

## Verification

`WatermarkOptionsRoundTripTests` passes 17/17. The native-picture test writes a
picture watermark, removes `docProps/custom.xml`, and verifies that `DocxReader`
rehydrates the original bytes from `word/_rels/header1.xml.rels`, along with
the VML opacity and rotation.
