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

The local FreeP notes preview for the same package remains 540 x 720 pt but emits 2 pages. PowerPoint includes the slide thumbnail and the complete notes block on the first page, then continues the overflowing notes onto a second page; the second slide occupies the third page. This establishes a concrete remaining notes-pagination gap and supplies an authoritative PDF baseline for future ROI work.

Renderer source and controls were unchanged by this harness slice.
