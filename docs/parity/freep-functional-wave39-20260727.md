# FreeP Functional Wave 39

## Selected production mismatch

The WPF transition-sound command opened a file picker filtered for seven audio
formats: MP3, M4A, WAV, WMA, AAC, OGG, and FLAC. The equivalent Avalonia
command advertised only MP3, M4A, WAV, and WMA. As a result, a valid
WPF-authored presentation containing an AAC, OGG, or FLAC transition sound
could not be selected through the same command on Linux.

## Implementation

- Added `PresentationMediaFileTypeCatalog` to the shared FreeP presentation
  layer with the canonical audio patterns and MIME types.
- Updated the WPF transition-sound picker to build its filter from the shared
  catalog.
- Updated the Avalonia transition-sound picker to build its native file type
  from the same catalog.
- Added shared catalog coverage plus WPF and Avalonia host wiring tests.

## Verification

Focused tests passed serially with build servers disabled:

- `FreeP.App.Presentation.Tests`: 2 passed for
  `PresentationMediaFileTypeCatalogTests`.
- `FreeP.App.Avalonia.Tests`: 1 passed for
  `MainWindowHeadlessTests.TransitionSoundPicker_UsesSharedAudioFileTypeCatalog`.
- `FreeP.App.Host.Tests`: 1 passed for
  `FileCommandsSourceTests.MainWindow_UsesSharedTransitionSoundAudioFilter`.

The Avalonia and WPF production projects compiled as part of their focused
test runs.

## Residuals

The native picker chrome and codec availability remain platform-owned. This
change aligns the file types exposed by the two hosts; it does not guarantee
that every installed media backend can decode every accepted format.
