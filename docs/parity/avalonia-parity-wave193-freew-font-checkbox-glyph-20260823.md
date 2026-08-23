# Avalonia Parity Wave 193: FreeW Font Checkbox Glyph Handoff

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, `initial`, `populated`, and `validation-error` states
Authority: FreeW WPF `FontDialog`

## Implementation slice

The shared compact checkbox template now takes its checkmark stroke thickness from
`AvaloniaCompactDialogChromeStyle`, with the existing `1.4` value retained as the shared default.
The Font route selects the WPF-authority `1` device-pixel glyph while continuing to use the shared
indicator, checked/indeterminate state painting, and Font/Paragraph checkbox realization. No local
Font checkbox template or platform-specific replacement was added.

The WPF renderer, shared planner semantics, validation behavior, other compact-dialog styles, and
the Wave192 effect-lane registration correction are unchanged. The Font route remains bounded to
the existing `460 x 340` logical target and the existing `421 x 321` painted-bounds contract.

## Evidence status

This worktree is intentionally ready for the build/capture lane, but that lane is held by resource
coordination. Wave192's canonical comparison, provenance bundle, freshness sidecar, and generated
reports therefore remain the current pixel authority: `34,196` aggregate changed pixels across
the three Font states, with exact `421 x 321` painted bounds. No new metric, classification, source
revision, capture-manifest identity, or canonical row hash is claimed here.

After the build lane is released, refresh only the three `font.*` rows from fresh WPF/Avalonia
captures, verify every state improves or holds, verify every non-Font row is byte/structure-stable,
and then regenerate the Wave193 provenance/source hashes from the actual capture revision. Keep all
three rows as `genuine-visual-mismatch` unless the measured evidence independently proves otherwise.
