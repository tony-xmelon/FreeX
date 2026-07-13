# FreeP Visible Media Caption Authoring - 2026-07-13

This bounded no-COM slice adds visible media-caption authoring workflow evidence for WPF and Avalonia over the shared FreeP caption/transcript/package layer.

Covered:

- `PresentationMediaTranscriptPlanner` now owns caption-authoring pane state, command enablement, selected-track normalization, and create/replace/delete mutation planning.
- WPF and Avalonia expose thin right-side media-caption panes for selected media shapes, with label, language, package path, transcript text, and track selection state.
- Both hosts route create, replace, and delete through shared planner/mutation helpers instead of duplicating caption validation or package policy.
- Authored caption text is normalized to internal WebVTT bytes through the existing shared caption-track builder.
- Accessibility checker media rows can select a media shape and open the caption authoring workflow without requiring Microsoft PowerPoint COM.

Validation:

- Shared planner test coverage: caption-authoring pane command state for internal, external, and missing selection cases.
- WPF host coverage: visible media-caption pane create, replace, and delete workflow over a selected media shape.
- Avalonia headless coverage: matching visible media-caption pane create, replace, and delete workflow over the same shared planner path.

Remaining:

- Real PowerPoint COM-backed caption-authoring baselines remain deferred on this machine.
- Broader PowerPoint-authored deck coverage still needs representative media-caption fixtures beyond the focused package and workflow tests.
- Native capture, recording, microphone, and camera caption-authoring integrations remain separate follow-up work.
