# FreeP external RTF row-default cell padding

Word RTF can specify default cell insets for a row with `\\trpaddl`,
`\\trpaddr`, `\\trpaddt`, and `\\trpaddb`. FreeP already preserved explicit
cell overrides (`\\clpad*`) but ignored those row defaults in nested inline tables.

The parser now applies row defaults to captured cells only on sides without an
explicit cell override. The values materialize into the existing `TableCell`
inset model, so the shared clipboard codec and both WPF/Avalonia inline-table
paths consume the same semantics without changing ordinary flat-table fallback.

Focused coverage proves all four defaults, cell-side override precedence, and
the existing nested-table row-height behavior together. This is a functional
clipboard/package slice; it makes no PowerPoint raster-baseline claim.
