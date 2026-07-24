# FreeP Camera Video Export

The WPF and Avalonia video exporters now consume persisted `CameraVideo` recording artifacts.
Each captured clip is trimmed to its recorded duration, shifted to its authoritative slide start,
scaled to 25% of the slide width, and composed in the bottom-right corner with a 32-pixel inset.
Narration tracks continue to use the existing delayed/mixed audio path.

The shared `PresentationVideoMediaMuxPlanner` owns input materialization and ffmpeg graph
construction so both host exporters produce the same composition contract. Camera media is only
included when a captured artifact with payload bytes is supplied; video-only export remains
available when no recording artifacts are present.

Verification on the Windows host:

- `FreeP.App.Recording.Tests`: 47/47
- `FreeP.App.Presentation.Tests`: 2241/2241
- `FreeP.App.Host.Tests`: 1428/1428
- `FreeP.App.Avalonia.Tests`: 276/276

The remaining recording work is PowerPoint COM baselines, permission/error evidence, and broader
real-deck media/caption comparison. This slice does not claim a PowerPoint visual baseline for the
default camera framing.
