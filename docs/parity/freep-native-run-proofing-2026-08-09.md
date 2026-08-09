# FreeP native text-run proofing metadata

PowerPoint stores two ordinary DrawingML run-state flags on `a:rPr`:
`noProof` suppresses proofing for the run and `err` marks an authored spelling
or grammar error. FreeP previously dropped both values during import and could
not retain an explicit `0` versus an omitted token on save.

`Run.NoProof` and `Run.Error` are nullable model properties. The reader,
writer, model/edit clones, and in-canvas clipboard now preserve the authored
presence and value. This is a function/package-preservation slice; it does not
claim to implement a proofing engine or add visual comparison evidence.

Focused verification:

- `MediaFieldsTests`: 37/37, including PPTX save/reopen.
- `InCanvasRichClipboardTests`: 8/8 compiled and 8/8 no-build.

