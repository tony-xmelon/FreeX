# FreeP Native ChangeFontStyle Playback - 2026-08-06

`AnimationPreset.ChangeFontStyle` already carried PowerPoint's native
`style.fontStyle`, `style.fontWeight`, and `style.textDecorationUnderline`
setters through the package reader/writer and authoring planner. Playback had
not consumed those setters: WPF pulsed the base shape and Avalonia fell
through to its generic fallback.

This slice resolves the preserved setters in the shared playback planner,
clones the target text body with the authored italic/bold/underline values,
and reveals that styled target through the authored timing in both WPF and
Avalonia. The source model and base slide remain unchanged; malformed,
non-text, or setter-free payloads retain the existing fallback behavior.

Evidence:

- Shared focused planner/round-trip tests: 151 passed.
- Full FreeP Presentation test lane: 3847 passed.
- WPF host source contract: 3/3 passed.
- Avalonia host source contract: 5/5 passed.
- WPF and Avalonia Release consuming builds: 0 warnings, 0 errors.

This is a functional playback contract. It makes no PowerPoint pixel or
timing equivalence claim; those remain a separate COM-baseline visual gate.
