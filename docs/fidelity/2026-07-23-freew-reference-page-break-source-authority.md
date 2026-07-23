# Reference Page-Break Source Authority

## Scope

`references-heavy-fields.docx` contains an explicit empty paragraph with
`PageBreakBefore` immediately after its first marked authority. The serialized
break is the layout authority: Word leaves the first citation and authority
block on page 1 and starts the second authority on page 2.

`DocxReader` previously rewrote that empty break by moving it backward across
the contiguous citation/authority block. That changed the source document's
pagination and caused regenerated table-of-authorities entries to report the
wrong physical page references.

## Change

Removed the reader-side reference page-break normalization. The reader now
preserves the serialized empty page-break paragraph, and the round-trip
contract asserts both that placement and the regenerated TOA page references.

## Visual Evidence

Comparison used the persistent matching Word COM PNG baseline at 1280x720 and
a fresh Release `FreeW.FidelityRender` candidate. Metric is mean absolute RGB
channel delta on a 0-255 scale; lower is better.

| Page | Before | After |
| --- | ---: | ---: |
| 1 | 2.4666 | 2.4989 |
| 2 | 28.3157 | 15.6936 |
| 3 | 15.0459 | 14.5556 |
| Sequence mean | 15.2761 | 10.9160 |

The tiny page-1 movement is pre-existing typography/raster variance. The
structural owner moves page 2 from the incorrectly relocated citation block to
Word's second authority, reducing sequence error by 28.5 percent while page 3
also improves.

## Verification

- `dotnet build freew\\FreeW.Core.IO.Tests\\FreeW.Core.IO.Tests.csproj --configuration Release --no-restore -v:minimal`
- Focused `TableOfAuthoritiesRoundTripTests`: 7/7 passed.
- `dotnet test freew\\FreeW.Core.IO.Tests\\FreeW.Core.IO.Tests.csproj --configuration Release --no-build --logger "trx;LogFileName=core-io-tests.trx"`: 1066/1066 passed.
- `dotnet build freew\\tools\\FreeW.FidelityRender\\FreeW.FidelityRender.csproj --configuration Release --no-restore -v:minimal`: clean.
