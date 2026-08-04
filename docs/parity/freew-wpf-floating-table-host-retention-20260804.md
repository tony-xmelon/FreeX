# FreeW WPF floating-table host retention

## Scope

The DOCX model and package layer preserve the complete `w:tblpPr` and `w:tblOverlap` payload. This slice closes the WPF editor boundary: loading a document into `DocumentView` and committing an ordinary edit must not reconstruct a table without that authored state.

## Implementation

- `WpfTableTag` carries the immutable `TableFloatingPosition` and nullable overlap value alongside the existing style, formatting, and border payload.
- `BuildTable` stamps both values on every rendered table, including pagination segments.
- `ReadTable` restores both values when the FlowDocument is committed back to the model.

## Contract

The focused round-trip test uses non-default anchors, signed offsets, both alignment specifications, all four text distances, and `overlap=false`. A paired inline table remains null for both values, preventing the host from inventing floating state.
