# FreeP native text-run metadata parity

PowerPoint stores the language and refresh state of ordinary text runs on
`a:rPr`. FreeP previously discarded both values on import and then rewrote
every run using hardcoded `lang="en-US"` and `dirty="0"`.

`Run.Language` and nullable `Run.Dirty` now preserve the authored tokens through
PPTX read/write, model and edit clones, and the in-canvas clipboard payload.
Omitted tokens remain omitted; explicit imported values remain authoritative.

The WPF `MediaFieldsTests` gate covers the native round-trip. This is a package
and text-semantics slice, not a visual raster claim.
