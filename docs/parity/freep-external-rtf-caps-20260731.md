# FreeP external RTF capitalization preservation

Date: 2026-07-31

## Scope

External RTF paste now preserves `\\caps`, `\\scaps`, and their explicit
off-values through the existing renderer-neutral `Run.Caps` property. This
keeps Word's all-caps and small-caps inline semantics available to the shared
WPF and Avalonia editing paths.

## Evidence

- `ExternalRichTextClipboardTests`: the capitalization contract passes with
  the complete external-RichText focused set (24 tests).
- The existing WPF and Avalonia clipboard suites continue to pass against the
  same shared payload path.

## Boundary

This preserves the authored capitalization state; font-specific small-caps
metrics and PowerPoint-authoritative rich-editor visual baselines remain
separate fidelity work.
