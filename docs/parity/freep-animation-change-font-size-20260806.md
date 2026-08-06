# FreeP Native ChangeFontSize Playback - 2026-08-06

PowerPoint's Change Font Size emphasis is serialized as an emphasis Grow/Shrink
entry with a preserved `style.fontSize` numeric behavior. FreeP retained that
payload but previously played it as whole-shape Grow/Shrink, changing the
shape geometry instead of the text.

This slice gives the shared playback planner a distinct ChangeFontSize identity
when that native payload is present. WPF and Avalonia clone the target text
body and multiply explicit run font sizes by the authored numeric factor,
revealing the styled text at the authored delay. If inherited run sizes or
unsupported content make the target ambiguous, the existing whole-shape
Grow/Shrink fallback remains in force.

Evidence:

- Shared focused planner/round-trip tests: 152 passed.
- Full FreeP Presentation test lane: 3848 passed.
- WPF host source contract: 3/3 passed.
- Avalonia host source contract: 5/5 passed.
- WPF and Avalonia Release consuming builds: 0 warnings, 0 errors.

This is a functional playback contract. It makes no PowerPoint pixel or
timing equivalence claim; those remain a separate COM-baseline visual gate.
