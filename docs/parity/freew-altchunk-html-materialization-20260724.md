# HTML, RTF, MHTML, and Nested DOCX altChunk Materialization

## Scope

Word materializes supported package-local body-level `w:altChunk` payloads into editable document content when it opens a document. FreeW follows that behavior for `text/html` HTML, `message/rfc822` MHTML, both RTF MIME types, and ordinary nested Word-package payloads, importing them into native paragraphs, tables, and inline images.

HTML chunk-local image relationships and relative image paths resolve within the chunk part. MHTML resolves its own CID and content-location image resources from the MIME payload, independently of the Open Packaging Convention relationship graph. Once materialized, saving the document writes ordinary WordprocessingML content and no longer retains the consumed chunk marker or part.

Nested DOCX content carries its own resolved document defaults and style chain into unique host styles, so a source font/spacing default or colliding style id does not inherit formatting from the outer document. Malformed nested packages and packages that require document-global identity (notes, comments, section breaks, preserved drawings, numbering, or nested altChunks) remain `AltChunkBlock` instances so their original relationship graph is preserved verbatim.

## Verification

- `AltChunkRoundTripTests`: 7/7 passed, including nested DOCX style collisions, source defaults, malformed-package retention, and HTML/MHTML/RTF controls.
- Existing HTML/MHTML IO tests: 17/17 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a package and functional-parity slice. It has no Word COM visual metric because Word consumes the HTML payload before page rendering.
