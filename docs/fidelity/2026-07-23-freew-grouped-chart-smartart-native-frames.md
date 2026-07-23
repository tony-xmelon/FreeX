# Native grouped chart and SmartArt frames

## Scope

`DrawingGroup` supports `Chart` and `SmartArt` children in the model, but the DOCX writer previously emitted
gray marker `wps:wsp` placeholders for both. The child type round-tripped only because the marker name encoded
it; Word did not receive a live chart or diagram payload in the group.

## Package change

The writer now allocates grouped charts and SmartArt objects through the ordinary chart/diagram part pipelines.
It emits each child as a native `wpg:graphicFrame` containing `wpg:cNvPr`, `wpg:cNvFrPr`, `wpg:xfrm`, and the
same `a:graphic` relationship payload used by standalone objects. The reader now consumes the native
`wpg:xfrm`, while retaining its former `a:xfrm` compatibility fallback.

## Verification

- `dotnet test freew\\FreeW.Core.IO.Tests\\FreeW.Core.IO.Tests.csproj --configuration Release --filter
  FullyQualifiedName~DrawingGroupRoundTripTests --logger "trx;LogFileName=grouped-drawings.trx"`: 13/13 passed.
- Related grouped/chart/SmartArt regression set: 69/69 passed.
- The package contract asserts two native graphic frames, chart/diagram relationship payloads, chart and
  SmartArt part presence, child types/data, and child offsets after read-back.

No Word COM export was run for this slice because the shared Word instance was actively exporting another
lane's `picture-alpha-38000.docx`. The package structure follows the native grouped-object representation;
the queued live-open check must use a free Word session.
