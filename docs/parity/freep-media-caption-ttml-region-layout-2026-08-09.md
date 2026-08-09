# FreeP TTML Region Layout - 2026-08-09

This slice closes the native TTML/DFXP caption-placement gap for media tracks.

The shared transcript planner now resolves `xml:id` regions and inherited
`tts:*` layout attributes instead of falling back to the default bottom-center
caption placement:

- `origin` and `extent` map to position, line, and size percentages.
- `textAlign` and `displayAlign` map to the existing caption alignment model.
- `writingMode` maps horizontal, vertical-left-to-right, and vertical-right-to-left tracks,
  including the corresponding coordinate transpose.
- The authoring path writes the same layout fields back to TTML/DFXP paragraphs.

The behavior is shared by the WPF and Avalonia caption surfaces through the
existing `PresentationMediaTranscriptPlanner`; no host-specific layout fork or
model-only display glyph is introduced.

Verification:

- `PresentationMediaTranscriptPlannerTests`: 24/24 focused tests.
- `FreeP.App.Presentation.Tests`: 3,870/3,870.
- `dotnet build FreeX.slnx --configuration Release`: 0 warnings, 0 errors.

Remaining media-caption work is broader real-deck PowerPoint caption evidence,
advanced accessibility/styling semantics, and device-backed capture/playback;
this slice does not claim pixel identity against a PowerPoint COM baseline.
