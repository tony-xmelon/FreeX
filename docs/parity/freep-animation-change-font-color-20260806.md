# FreeP Change Font Color animation preservation - 2026-08-06

PowerPoint's Change Font Color emphasis effect emits
`presetClass="emph" presetID="3"` and a native `p:animClr` payload. A short
PowerPoint COM fixture confirmed that this is distinct from the existing
`presetID="7"` color effect, but both use the same renderer-neutral color
behavior contract available in FreeP.

FreeP now maps imported `emph/3` to the existing `ChangeColor` playback
contract while retaining the native class, ID, subtype, and `p:animClr` XML for
write-back. This closes the generic-Pulse fallback without claiming that the
current host rasterizes font-only color changes pixel-identically to PowerPoint.

The shared Animations ribbon now also exposes Change Font Color as an authoring
command. New animations emit `emph/3`, target `style.color`, bind the selected
shape `spid`, and use PowerPoint's observed default `accent2` destination. The
operation is undoable through the existing animation command bus and remains
available to both WPF and Avalonia through shared command registration.

The host playback projection intentionally remains the existing renderer-neutral
color-effect contract; the native `style.color` target is retained as the
package authority until text-only effect painting is modeled separately.

Evidence: Microsoft documents `msoAnimEffectChangeFontColor` as effect value 56
and `msoAnimEffectChangeFillColor` as effect value 54; the COM-authored package
was inspected directly to establish their PresentationML IDs. See
https://learn.microsoft.com/en-us/office/vba/api/powerpoint.msoanimeffect.

The `style.color` target is the PowerPoint-valid `p:animClr` attribute name
specified by [MS-OI29500, section 19.5.2](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oi29500/9636f7f3-58e3-408d-9880-d0799fb26b0f).

## Verification

- Presentation animation planner/package filter: **131/131**.
- Ribbon definition profile: **24/24**; localization: **11/11**.
- Generated shared command inventory: **652/652**, with no actionable host gaps.
- WPF consuming Release build: **0 warnings/0 errors**; focused host checks:
  **147/147**.
- Avalonia consuming Release build: **0 warnings/0 errors**; focused host
  source checks: **5/5**.
- Full `FreeP.App.Presentation.Tests` Release no-build lane: **3823/3823**.
