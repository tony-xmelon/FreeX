# FreeP native notes-master geometry and retention

## Scope

The PPTX reader now retains the native `ppt/notesMasters/notesMaster1.xml`
part and its relationships, parses `p:notesStyle` into the presentation
model, and exposes notes-master placeholder shapes to the shared notes-page
planner. Native body, header, date/time, footer, and slide-number geometry is
used before the existing deterministic fallback geometry.

When a native notes master is present, the writer emits the retained XML and
relationships instead of replacing it with a synthetic notes master. New
presentations now emit the standard PowerPoint six-placeholder notes master
(header, date, slide image, notes body, footer, and slide number) using the
PowerPoint-authored 7.5 x 10 inch geometry. The reader distinguishes the
explicit `sldImg` placeholder from the notes body, so preview planning cannot
select the slide thumbnail as the notes text region.

## Verification

- `NotesMasterRoundTripTests`: 3/3
- `MasterLayoutRoundTripTests`: 15/15
- `FreeP.App.Host.Tests` Release build: 0 warnings, 0 errors

## Fresh PowerPoint Notes Pages comparison

The rebuilt `21-comments-notes.pptx` was exported through PowerPoint COM using
`ppPrintOutputNotesPages`, then rasterized at 96 DPI alongside the FreeP notes
PDF. Both artifacts emitted two pages. Mean channel differences were 1.1455%
(page 1) and 0.9536% (page 2), average 1.0496%; slide-image regions measured
1.3350% and 2.3119%, while notes-body regions measured 4.0334% and 2.2746%.
The ordinary slide control remained 0.0738% WPF and 0.0914% Avalonia against
the same PowerPoint export.

The slice improves package/function parity and bounded notes-page geometry; it
does not claim pixel-identical notes text rasterization.
