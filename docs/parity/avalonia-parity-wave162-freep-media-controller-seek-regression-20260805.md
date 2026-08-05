# Avalonia parity Wave 162: FreeP media-controller seek regression

Wave162 regression evidence for `FreeP.App.Host.Tests.SlideShowMediaControllerTests.TrySetVolumeAndSeek_UseSharedMediaShapeIds`.

## Diagnosis

The WPF and Avalonia slideshow controllers both key active media state by the shared `SlideShape.Id`. The WPF controller stores `shape.Id` in each `MediaSlot`, and `TrySetVolume`/`TrySeek` resolve the same value. No production shape-ID mapping or state fix was required.

The failing fixture supplied three arbitrary bytes while declaring `video/mp4`. WPF `MediaElement` could create the element, but it could not open that payload, so a seek could return through the controller without changing `Position` from its default value. The test now uses a generated five-second PCM WAV and shape ID `42`, which exercises the shared ID contract against playable media.

## Evidence

- `TrySetVolumeAndSeek_UseSharedMediaShapeIds` verifies volume and seek through the shared shape ID, rejects an unknown ID, and rejects negative seek positions.
- The focused WPF host test remains the authority for `MediaElement.Position`; the Avalonia adapter tests use the same shared shape-ID contract with an injected playback session.

Residual risk is limited to native WPF media-codec availability outside the test environment; the regression fixture uses the Windows-supported WAV path rather than an arbitrary placeholder payload.
