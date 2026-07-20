# FreeP native notes-master geometry and retention

## Scope

The PPTX reader now retains the native `ppt/notesMasters/notesMaster1.xml`
part and its relationships, parses `p:notesStyle` into the presentation
model, and exposes notes-master placeholder shapes to the shared notes-page
planner. Native body, header, date/time, footer, and slide-number geometry is
used before the existing deterministic fallback geometry.

When a native notes master is present, the writer emits the retained XML and
relationships instead of replacing it with the minimal synthetic notes master.
New presentations without a native part continue to use the existing valid
fallback.

## Verification

- `NotesMasterRoundTripTests`: 2/2
- `MasterLayoutRoundTripTests`: 15/15
- `FreeP.App.Host.Tests` Release build: 0 warnings, 0 errors

This is a package/semantic and shared notes-layout slice. PowerPoint COM
notes-page captures and exact native print-preview raster calibration remain
separate evidence work.
