# HTML altChunk Materialization

## Scope

Word materializes package-local body-level `w:altChunk` HTML into editable document content when it opens a document. FreeW now follows that behavior for `text/html` chunks: HTML is imported through the existing HTML adapter into native paragraphs, tables, and inline images.

Chunk-local image relationships and relative image paths resolve within the chunk part. Once materialized, saving the document writes ordinary WordprocessingML content and no longer retains the consumed HTML chunk marker or part.

Non-HTML chunks, malformed HTML, nested Word packages, and unknown payloads remain `AltChunkBlock` instances so their original relationship graph is preserved verbatim.

## Verification

- `AltChunkRoundTripTests`: 2/2 passed.
- Existing HTML/MHTML IO tests: 16/16 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a package and functional-parity slice. It has no Word COM visual metric because Word consumes the HTML payload before page rendering.
