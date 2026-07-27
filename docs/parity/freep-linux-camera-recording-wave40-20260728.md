# FreeP Linux Camera Recording Parity Wave 40

Date: 2026-07-28

## Selected mismatch

The WPF slideshow's default recording backend composes narration and camera
capture through `WindowsRecordingCaptureBackend` and
`WindowsHostRecordingCaptureEngine`. The Avalonia Linux slideshow previously
created only `LinuxNarrationCaptureBackend`, so its production capabilities
always reported `CanCaptureCamera == false` and camera recording could never
produce a persisted media artifact.

The PowerPoint Table Layout `Distribute Rows`/`Distribute Columns` fallback was
reviewed but not selected for this wave because the camera mismatch was directly
confirmed in the default host composition and was locally closable without
PowerPoint COM or hardware-specific code in the shared contract.

## Implementation

- Added Linux V4L2 camera discovery under `/dev/video*`.
- Added FFmpeg software-encoder probing and a shared camera command planner for
  1280x720, 30 fps MP4 capture.
- Added a Linux camera backend with startup/stop/cancel lifecycle handling,
  MP4 validation, SHA-256 materialization, package-path normalization, and
  cleanup of temporary recordings.
- Added a composite Linux backend so narration and camera devices are exposed
  together through the existing FreeP recording contract.
- Wired the Avalonia Linux slideshow to the composite backend while retaining
  the WPF native camera backend as the parity reference.

## Verification

- `FreeP.App.Recording.Tests`, filter `LinuxCameraCaptureBackendTests`: 3/3
- `FreeP.App.Recording.Tests`, filter `FullyQualifiedName~Linux`: 41/41
- `FreeP.App.Avalonia.Tests`, filter `LinuxCameraCaptureWiringTests`: 2/2
- `FreeP.App.Host.Tests`, filter `WpfCameraCaptureParityTests`: 1/1
- `git diff --check`: clean

All tests were run serially in the isolated worktree with build servers
disabled and shared compilation/node reuse disabled.

## Remaining scope

The implementation has not been exercised against a real camera device inside
the Linux container. Runtime validation still needs a host exposing a usable
`/dev/video*`, FFmpeg with one of the supported software encoders, and the
required device permissions. Camera selection remains the first discovered
V4L2 device; a future slice can add explicit device selection and richer camera
format negotiation if the harness requires it.
