# FreeP Media Rewind After Playing

## Scope

PowerPoint's media playback options include **Rewind after playing**. FreeP previously kept the media at its terminal frame after a non-looping audio or video ended, and the setting was not retained in the presentation package.

This slice adds the option to the shared `MediaInfo` model, the undoable playback-options command, the WPF and Avalonia media panes, and both native playback controllers.

## Package Contract

The option is stored on the media timing common time node as `p:cTn/@autoRev="1"`. The reader accepts the standard boolean forms and defaults the omitted attribute to false; the writer omits the false default and emits `1` when enabled. Trimmed media rewinds to the authored trim start so the playback and edit-time contracts remain consistent.

## Runtime Contract

The shared slideshow planner resolves a media end to exactly one action: `Stop`, `Rewind`, or `Loop`. Both WPF and Avalonia use that decision for natural media end and trim-end enforcement. Rewind seeks to the trim start, applies the existing fade/volume calculation, pauses, and restores the poster visibility according to `Show when stopped`.

## Verification

- `FreeP.App.Presentation.Tests`: 60/60 focused tests.
- `FreeP.App.Host.Tests`: 34/34 focused media/package and WPF pane tests.
- `FreeP.App.Avalonia.Tests`: 1/1 focused media-pane test.
- Release builds completed as part of each focused test command.

This is a functional/package parity slice; no raster comparison claim is made.
