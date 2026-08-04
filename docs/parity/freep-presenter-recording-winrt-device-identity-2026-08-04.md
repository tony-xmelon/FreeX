# FreeP presenter recording WinRT device identity - 2026-08-04

## Scope

The Windows camera recorder uses `Windows.Media.Capture.MediaCapture`, whose device
selection is keyed by WinRT `DeviceInformation.Id`. The shared SetupAPI catalog used
to feed the host readiness surface can expose a different interface identifier, and
the old recorder then fell back to the first enumerated camera when the identifiers
did not match.

## Change

Windows WPF and Windows Avalonia now use a Windows-native catalog backed by
`DeviceInformation.FindAllAsync(DeviceClass.VideoCapture/AudioCapture)`. The catalog
passes the exact WinRT camera identity to the recorder. If that identity is no longer
available, the recorder reports a deferred capture result instead of silently recording
from another camera; a matching device name remains a controlled recovery path for a
device whose stable id changed.

This is a functional device-selection correction. It does not claim live hardware
capture, camera permissions, or a PowerPoint recording baseline; those still require a
machine with usable devices and fresh application evidence.

## Gates

- `WindowsRecordingCaptureBackendTests`: focused recording contract passed.
- WPF `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- Windows Avalonia `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.
