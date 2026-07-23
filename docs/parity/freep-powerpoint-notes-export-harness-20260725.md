# FreeP PowerPoint Notes Export Harness

Date: 2026-07-25

## Scope

`FreeP.RenderCompare` now has a `--powerpoint-notes-export` mode that asks the installed PowerPoint COM server for its native notes-page PDF. The helper uses `Presentation.ExportAsFixedFormat` with `ppPrintOutputNotesPages` and an explicit all-slide `PrintRange`, then cleans up only the PowerPoint process it created.

This is an evidence and baseline tool. It does not change FreeP rendering.

## Fresh Probe

Input: `tools/FreeP.RenderCompare/corpus/21-comments-notes.pptx`

Command:

```text
dotnet tools/FreeP.RenderCompare/bin/Release/net10.0-windows10.0.19041.0/FreeP.RenderCompare.dll --powerpoint-notes-export tools/FreeP.RenderCompare/corpus/21-comments-notes.pptx <out.pdf>
```

Fresh PowerPoint COM output:

- creator/producer: Microsoft PowerPoint for Microsoft 365
- page size: 540 x 720 pt
- page count: 3
- output size: 88,605 bytes

The current FreeP notes export for the same package is also 540 x 720 pt and emits 3 pages. Fresh raster comparisons against the native PDF are `0.1587%`, `0.2218%`, and `0.1637%` mean channel delta for pages 1-3. PowerPoint and FreeP both place the first slide's two note lines on pages 1-2 and the second slide on page 3. The remaining small delta is primarily PDF font realization/width, not missing notes pagination or slide content.

The corpus cardinality is protected by `NotesSlideTests.Corpus_CommentsNotes_ReportsImportedSlidesAndNotesPageCardinality`, which asserts the imported note-line counts (`2`, `1`) and rendered page counts (`2`, `1`).

Renderer source and controls were unchanged by this harness slice.
