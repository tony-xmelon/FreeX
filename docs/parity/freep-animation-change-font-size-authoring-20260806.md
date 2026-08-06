# FreeP Change Font Size animation authoring - 2026-08-06

PowerPoint's Change Font Size emphasis effect uses `presetClass="emph"`,
`presetID="4"`, `presetSubtype="2"`, and a numeric `p:anim` targeting
`style.fontSize`. The measured COM payload ends at `to="1.5"`.

FreeP now exposes Change Font Size in the shared Animations ribbon. The
undoable authoring command emits the native `emph/4` identity and preserves
the numeric behavior instead of converting it to the renderer-neutral
`p:animScale` used by ordinary Grow/Shrink effects. Both WPF and Avalonia
consume the shared plan and registration.

This closes the authoring/package/function gap. Text-only font-size raster
parity remains a separate visual-rendering capability and is not claimed here.

## Verification

- Presentation planner/package focused lane: **134/134**.
- Ribbon definition profile: **24/24**; localization: **11/11**.
- WPF and Avalonia Release consumers: **0 warnings/0 errors**.
- WPF focused host animation/ribbon lane and Avalonia source lane are covered
  by the post-sync verification for this authoring path.
