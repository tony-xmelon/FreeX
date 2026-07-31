# FreeP external RTF baseline-offset preservation

Date: 2026-07-31

## Scope

External RTF paste now preserves the common superscript and subscript controls
that Word uses for inline chemistry, footnotes, and equation text. `\\super`,
`\\sub`, `\\nosupersub`, and the half-point `\\upN`/`\\dnN` controls map to the
existing renderer-neutral `Run.BaselineOffset` field; the shared WPF and
Avalonia paste routes therefore keep the same inline semantics.

## Evidence

- `ExternalRichTextClipboardTests`: the new baseline-offset contract passes,
  alongside the full external-RichText focused set (23 tests).
- `WpfRichTextClipboardTests`: 8 focused tests pass.
- `PresentationClipboardInteropTests`: 30 focused Avalonia tests pass.

## Boundary

This covers inline vertical positioning, not complete RTF list-template
numbering, inline picture/object runs, or unsupported destination semantics.
