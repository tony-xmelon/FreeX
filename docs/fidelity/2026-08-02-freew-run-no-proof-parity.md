# FreeW Word no-proof run parity

Date: 2026-08-02

## Scope

FreeW now retains and applies Word's `w:rPr/w:noProof` run property across the DOCX package,
the portable proofing planner, and both live editors.

- `RunFormatting.NoProof` defaults to `false`.
- The DOCX reader accepts empty, `1`, `true`, and `on` as enabled and `0`, `false`, and `off`
  as disabled.
- The writer emits enabled state canonically as an empty `w:noProof` element and omits false state.
- Run, style, and document-default writers place `w:noProof` after `w:strike` and before
  `w:vanish`, `w:webHidden`, and `w:color` in the `CT_RPr` sequence.
- Document merge, nested altChunk styles/defaults, and ODT run overlays retain the property.

## Proofing ownership

The shared proofing planner resolves direct, paragraph-style-chain, and document-default `NoProof`
state for every source character. A token touching a no-proof run is excluded from spelling and
grammar diagnostics, and the protected token forms a grammar boundary so repeated-word diagnostics
do not leak across it.

Avalonia consumes those shared diagnostics for its squiggles and caret actions. WPF uses the same
planner for grammar and assigns the protected inline the `zxx` (no linguistic content) language for
its native spelling engine. The authoritative authored language and `NoProof` flag remain in the run
format marker, so live edit/commit restores the original model instead of persisting the WPF-only
suppression language. Adjacent proofed runs keep their normal dictionary language.

## Acceptance gates

- Focused compiling and no-build model proofing gates: `17/17`.
- Focused compiling and no-build DOCX/ODT package gates: `21/21`.
- Focused compiling and no-build WPF proofing gates: `5/5`.
- Focused compiling and no-build Avalonia proofing gates: `3/3`.
- Adjacent WPF run round-trip, character-format, and proofing controls: `75/75`.
- Adjacent Avalonia review/proofing controls: `49/49`.
- Adjacent model merge/proofing controls: `37/37`.
- Adjacent DOCX hidden-property, altChunk, and ODT controls: `42/42`.

No Word COM raster is required for this semantic slice: the package XML establishes the authored
property and the host tests exercise the effective proofing owner paths directly.
