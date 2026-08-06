# FreeP Native Change Font Style Animation Pane Options

Date: 2026-08-06

Imported PowerPoint `Change Font Style` emphasis effects already retained the
native `style.fontStyle`, `style.fontWeight`, and
`style.textDecorationUnderline` setter group, and slideshow playback consumed
those setters. The Animation Pane previously exposed no editable effect options
for the imported behavior.

The shared pane planner now projects on/off choices for each setter present in
the native behavior. Selecting one choice rewrites only that setter's
`p:strVal`, preserving the other setters, target metadata, timing, and the rest
of the behavior XML. The edit remains undoable and survives PPTX write/reopen.
Malformed or unknown setter names remain on the existing disabled/fallback path.

This is a functional package/editing slice. It makes no new PowerPoint pixel or
playback-timing equivalence claim.

Verification:

- Focused Animation Pane tests: **110/110**.
- Full FreeP Presentation tests: **3,852/3,852**.
- WPF Animation Pane host contracts: **18/18**.
- Avalonia Animation Pane host contracts: **4/4**.
- WPF and Avalonia Release builds: **0 warnings, 0 errors**.
