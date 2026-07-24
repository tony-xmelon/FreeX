# HTML and MHTML altChunk Materialization

## Scope

Word materializes supported package-local body-level `w:altChunk` payloads into editable document content when it opens a document. FreeW now follows that behavior for `text/html` HTML and `message/rfc822` MHTML chunks, importing them through the existing HTML and MHTML adapters into native paragraphs, tables, and inline images.

HTML chunk-local image relationships and relative image paths resolve within the chunk part. MHTML resolves its own CID and content-location image resources from the MIME payload, independently of the Open Packaging Convention relationship graph. Once materialized, saving the document writes ordinary WordprocessingML content and no longer retains the consumed chunk marker or part.

RTF, nested Word packages, malformed supported payloads, and unknown MIME types remain `AltChunkBlock` instances so their original relationship graph is preserved verbatim.

## Verification

- `AltChunkRoundTripTests`: 3/3 passed.
- Existing HTML/MHTML IO tests: 17/17 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a package and functional-parity slice. It has no Word COM visual metric because Word consumes the HTML payload before page rendering.
