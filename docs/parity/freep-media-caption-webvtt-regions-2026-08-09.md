# FreeP WebVTT Region Semantics

Date: 2026-08-09

## Scope

FreeP already parsed WebVTT cue timing and cue-level placement settings, but it discarded `REGION` blocks and `region:<id>` cue ownership. Those cues consequently used the default caption placement in both WPF and Avalonia playback.

## Change

- The shared transcript planner now retains WebVTT region definitions: width, line count, region and viewport anchors, and scroll mode.
- Cue descriptors retain `region:<id>` and resolve matching regions before the legacy position/line/size placement path.
- WPF and Avalonia pass the selected track's region table to the shared placement planner.
- Authored WebVTT replacement preserves existing regions, and typed cue replacement re-emits region headers and cue ownership.
- Missing or unknown regions retain the existing default cue behavior.

## Verification

- `PresentationMediaTranscriptPlannerTests`: 26/26.
- New region parser/placement and typed-replacement tests: 2/2.
- WPF region-consumption source contract: 1/1.
- Avalonia region-consumption source contract: 1/1.
- WPF and Avalonia Release test-project builds: 0 warnings, 0 errors.

This is a functional caption-semantics slice; no raster comparison was used as an acceptance gate.
