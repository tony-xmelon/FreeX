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

Evidence: Microsoft documents `msoAnimEffectChangeFontColor` as effect value 56
and `msoAnimEffectChangeFillColor` as effect value 54; the COM-authored package
was inspected directly to establish their PresentationML IDs. See
https://learn.microsoft.com/en-us/office/vba/api/powerpoint.msoanimeffect.
