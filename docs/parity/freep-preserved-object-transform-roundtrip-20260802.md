# FreeP Preserved-Object Transform Round-Trip

## Scope

Preserved modern graphic frames are still editable `SlideShape` objects. Move, resize,
rotate, and flip commands update the shared shape geometry even when FreeP keeps the
native payload verbatim for rendering or future editing.

## Fix

`PptxPackageWriter` now synchronizes the root transform for every preserved object with a
recognized `p:graphicFrame/p:xfrm` or `p:sp/p:spPr/a:xfrm`, not only for Zoom objects.
Payloads without one of those root transforms remain unchanged. This keeps Ink, 3D, and
unknown preserved objects consistent with the existing Zoom behavior, including
`mc:AlternateContent` fallbacks.

## Evidence

`ModernObjectsRoundTripTests.Model3dGraphicFrame_RoundTrips_VerbatimXmlAndGlbBytes`
mutates a preserved 3D frame through position, size, rotation, and both flips before
writing and verifies all values after readback. The focused Host test class passed 28/28.

This is a functional/package-parity fix. It does not claim new native rendering for
preserved payloads that still use their existing preview fallback.
