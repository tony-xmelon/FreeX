# FreeP Rich Editor List Continuation - 2026-07-24

## Reproduced discrepancy

The shared compositor kept a per-level number alive through a non-list or
character-bullet paragraph. A later numbered paragraph with an authored
`startAt` was therefore rendered as a continuation instead of a restart.
The model also could not distinguish an authored `startAt=1` from an omitted
attribute.

## Implemented contract

- `Paragraph.AutoNumStartAtSpecified` preserves OOXML `startAt` presence,
  including an explicit value of 1; legacy programmatic non-default values
  remain serialized.
- `PresentationListMarkerContinuationState` is shared by slide and notes
  layout. It continues through nested levels, restarts on explicit starts,
  numbering-format changes, and non-numbered marker boundaries.
- Shared rich-editor mutation keeps explicit restart intent on the first
  lineage paragraph and clears it on split continuations. Joins retain the
  leading paragraph metadata.
- WPF and Avalonia continue to consume the same shared `BulletText` and
  `BulletImage` values. No platform-specific marker renderer was added;
  WPF's editable FlowDocument and Avalonia's rich overlay both keep markers
  out of logical editor text, matching the existing authority contract.

## Verification

- `FreeP.App.Presentation.Tests`: 73 passed, focused `BulletsAutofitTests` and
  `InCanvasRichTextEditBufferTests`.
- `FreeP.App.Host.Tests`: 40 passed, focused `RichTextEditorTests`.
- `FreeP.App.Rendering.Avalonia.Tests`: 8 passed, focused
  `AvaloniaRichTextEditorTests`.

Remaining limitation: native WPF/Avalonia rich-editor overlays do not paint a
separate editable list marker; marker visibility is verified through the
shared slide layout contract, where both hosts draw the same resolved marker.
