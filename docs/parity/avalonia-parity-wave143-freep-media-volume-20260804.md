# Avalonia Parity Wave 143 - FreeP Media Volume

Date: 2026-08-04
Scope: FreeP WPF/Avalonia slideshow media controls

## Proved divergence

The shared slideshow media contract documents volume as a 0-100 integer range.
WPF already clamped that value before converting it to WPF `MediaElement.Volume`
(0-1), but Avalonia passed the raw integer to its LibVLC session. A volume request
below 0 or above 100 therefore produced different host state for the same media
shape and command.

## Change

- Added `SlideShowMediaInteractionPlanner.NormalizeVolumePercent` as the shared
  boundary policy.
- Routed both WPF and Avalonia `TrySetVolume` adapters through that policy.
- Added matching host tests for `150 -> 100` and `-25 -> 0`.

## Evidence

- `freep/FreeP.App.Host.Tests/SlideShowTests.cs`:
  `TrySetVolume_ClampsToSharedZeroToHundredRange` proves WPF native volume becomes
  `1.0` and `0.0`.
- `freep/FreeP.App.Avalonia.Tests/AvaloniaMediaPlaybackAdapterTests.cs`:
  `Controller_ClampsVolumeToSharedZeroToHundredRange` proves the Avalonia session
  receives `100` and `0`.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~SlideShowMediaControllerTests"`: 34 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~AvaloniaMediaPlaybackAdapterTests"`: 10 passed.
- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PresentationMediaTranscriptPlannerTests|FullyQualifiedName~MediaPlaybackBackendTests"`: 19 passed.
- `dotnet build freep/FreeP.App.Presentation/FreeP.App.Presentation.csproj --configuration Release --no-restore --nologo`: 0 warnings, 0 errors.
- `git diff --check`: passed.

## Residuals

This closes the host-state boundary for modeled volume commands. It does not claim
native decoder availability, device behavior, PowerPoint COM media baselines, or
pixel parity for the native playback surfaces.
