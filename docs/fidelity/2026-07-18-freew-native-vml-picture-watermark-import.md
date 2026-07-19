# Native VML Picture Watermark Import

## Scope

`DocxReader` now imports Word's native VML picture watermark when FreeW custom
watermark properties are absent. The reader recognizes
`PowerPlusPictureWaterMarkObject` in a header, resolves its image through that
header part's own relationship map, and retains the source image, opacity, and
horizontal or diagonal orientation. It also preserves the VML shape's authored
width and height through save/reopen, including when FreeW metadata owns the
picture content.

## Source Authority

The header-local VML payload is the fallback authority for documents created by
Word or another producer. FreeW custom watermark metadata remains authoritative
when present, so FreeW-authored documents keep their existing semantic path.

Both common VML image encodings are accepted:

- `v:fill/@r:id`
- `v:imagedata/@r:id`

## Verification

`WatermarkOptionsRoundTripTests` passes 19/19. The native-picture tests write
picture watermarks, remove `docProps/custom.xml`, and verify that `DocxReader`
rehydrates the original bytes from `word/_rels/header1.xml.rels`, along with
the VML opacity and rotation for both relationship encodings.
