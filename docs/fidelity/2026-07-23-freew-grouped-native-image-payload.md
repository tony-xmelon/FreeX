# Grouped Native Image Payload

## Accepted behavior

`DrawingGroup` image children now serialize as native `pic:pic` payloads with a document media relationship, rather than a gray `wps:wsp` marker. The reader decodes native `pic:pic` group children before generic image dispatch, preserving the image bytes and group offsets on reopen.

## Verification

- `DrawingGroupRoundTripTests`: 12/12 after a fresh Release build and again with `--no-build`.
- Package contract confirms `word/media/image1.png`, `wpg:wgp/pic:pic`, and the embedded `a:blip` relationship.
- MS Word COM opened the generated valid `group-image.docx` successfully without repair.

## Scope boundary

Probes using `wpg:graphicFrame` for grouped chart or SmartArt children were rejected: Word refused to open both generated packages. The writer deliberately retains its existing valid placeholders for those child kinds until their supported Word package form is established. The reader still recognizes external native group graphic frames when present.
