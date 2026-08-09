# FreeP native field metadata parity

## Scope

PowerPoint stores field identity and refresh state directly on DrawingML
`a:fld` elements. FreeP previously generated a new field ID on every save and
discarded the authored `dirty` token, so an otherwise unchanged field could
lose its package identity or refresh intent.

## Accepted slice

`FieldRun` now retains optional `a:fld/@id` and nullable `a:fld/@dirty` values.
The package reader/writer, model clone path, in-canvas clipboard payload, and
the WPF host round-trip preserve them. New fields still receive the existing
generated ID, and omitted `dirty` remains omitted while explicit `0` and `1`
round-trip distinctly.

## Gates

- `MediaFieldsTests`: 36/36
- consuming WPF Release build: clean

This is package/function parity; no raster claim is made.
