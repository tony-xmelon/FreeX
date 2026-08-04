# FreeP Print Comments and Ink Markup

## Scope

The shared vector PDF notes-page and handout exporters now honor
`PresentationPrintRequest.IncludeCommentsAndInkMarkup`.

When the option is enabled, persisted slide comments are emitted as anchored
callouts and readable InkML strokes are replayed as vector lines. When it is
disabled, both layers are omitted. The ordinary slide PDF exporter keeps its
existing default surface and does not emit review markup implicitly.

## Verification

- `PresentationExportPlannerTests.PrintMarkupOption_ControlsCommentCalloutsAndInkStrokesOnNotesAndHandouts`
  covers enabled and disabled notes/handout output.
- `PresentationExportPlannerTests`: 78/78.
- Release `FreeP.App.Presentation` build: 0 warnings, 0 errors.

This is a functional print-route slice. Exact PowerPoint review-pane styling,
thread UI, and host raster comparison remain separate work.
