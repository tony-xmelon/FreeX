# FreeW native Word artistic-source retention

## Scope

Word-authored Office artistic effects use two image payloads:

- the ordinary `a:blip` relationship points to the baked preview Word paints;
- `a14:imgProps/a14:imgLayer/@r:embed` points to a separate editable HD Photo (`.wdp`) source.

FreeW already recognized the native effect and avoided filtering the baked preview twice, but save/reopen
reused the preview relationship for `a14:imgLayer` and dropped the editable source part. This slice retains
the imported WDP bytes as opaque model data and writes them back as a distinct image relationship.

## Package contract

- Reader accepts a distinct native `a14:imgLayer` relationship only when it resolves to a `.wdp` part.
- The WDP bytes are retained without decoding or mutation.
- Writer emits a unique `word/media/artisticSourceN.wdp` part and relationship.
- `[Content_Types].xml` declares `wdp` as `image/vnd.ms-photo`.
- The baked preview and editable source relationship ids remain distinct after save and reopen.
- Inconsistent unbaked model state cannot emit an orphan WDP part.
- Changing the artistic effect clears the now-stale baked/source provenance; undo restores both.
- Body, header/footer, comment, footnote, and endnote image relationship writers use the same source-part
  contract.

Newly authored FreeW effects still use FreeW's non-destructive source image plus private metadata. Creating
a Word-native baked preview and WDP encoding from those authored bytes remains a separate export feature;
this slice closes lossless retention for imported native payloads.

## Verification

- `ArtisticEffectRoundTripTests`: 54/54.
- Complete `FreeW.Core.IO.Tests`: 1489/1489.
- `ArtisticEffectCommand_RestoresBakedPreviewProvenanceOnUndo`: 1/1.
- `FreeW.App.Presentation` Release build: 0 warnings, 0 errors.

The focused package test builds a native-style preview/source pair, reads it, saves it, inspects the exact
XML relationships, content type, and WDP bytes, then reopens the output model. This is a functional package
slice; renderer output is intentionally unchanged.

## Process rule

Treat native Office effect satellites as opaque package-owned data until FreeW has a proven encoder. A
recognized effect element is not enough: preserve the distinct source relationship, exact bytes, content
type, and edit invalidation semantics, and assert both serialized XML and the reopened model.
