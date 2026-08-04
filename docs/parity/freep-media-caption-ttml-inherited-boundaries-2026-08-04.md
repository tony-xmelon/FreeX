# FreeP TTML Inherited Timing Boundaries - 2026-08-04

This slice closes a playback-semantics gap in shared TTML/DFXP transcript planning.

Previously, `PresentationMediaTranscriptPlanner` accumulated `begin` values from
`body`/`div` ancestors but allowed a child paragraph cue to continue beyond an
ancestor's `end` or `dur`. The planner now follows the TTML timing relationship:

- `begin` and `end` are resolved against the parent clock.
- `dur` is resolved from the element's effective begin.
- A paragraph cue is clamped to the earliest active ancestor boundary.

This is shared planner behavior consumed by both WPF and Avalonia playback surfaces;
it does not change caption package bytes or introduce renderer-specific timing logic.

Verification:

- `PresentationMediaTranscriptPlannerTests`: 11/11.
- `MediaFieldsTests`: 28/28.
- Regression fixture: a cue beginning at 850 ms with a containing `div` ending at
  900 ms now ends at 900 ms instead of outliving its parent.

Remaining media boundaries are real-deck PowerPoint caption baselines, advanced caption
styling/layout/accessibility semantics, and device-backed capture/playback behavior.
