# Avalonia parity Wave 60: FreeP internal-slide hyperlinks

This standalone slice adds physical Linux/X11 proof for FreeP internal-slide hyperlinks. The
validation-only startup seed creates two slides, adds and selects a visible blue rectangle on
slide 1, and adds a target marker on slide 2. X11 opens the real Insert Hyperlink dialog,
selects the seeded slide-2 id, commits the selected shape, starts slideshow from slide 1, and
clicks the transformed center of the seeded shape in the discovered slideshow window.

The retained evidence includes six screenshots, deterministic fixture bounds, an authoring
postcondition, the transformed physical click proof, and an activation postcondition. The
validator requires the authored target id, activated target id, and seeded slide-2 id to match,
plus `currentSlideIndex=1` after activation. The fixture assertion requires positive bounds and
the shape's presence on slide 1. The seed and postcondition hooks are disabled by default.

The first physical attempt failed before a window appeared because the fixture postcondition
directory did not exist; the app now creates that validation-only directory before writing it.
The final owned Docker/X11 pass was **1/1 passed**. This is physical Avalonia/X11 evidence, not
a PowerPoint COM pixel baseline.
