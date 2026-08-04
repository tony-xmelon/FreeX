# FreeW WPF Ribbon Combo Selected-Value Contract

## Scope

The shared WPF ribbon renderer executes combo commands with
`RibbonCommandContext.ForSelectedValue`. Several WPF commands still read only the older lowercase
`value` dictionary key, so their unit tests passed while the live ribbon route silently did nothing.

Affected controls were:

- font family and font size;
- line spacing and paragraph style;
- exact left/right paragraph indents;
- exact paragraph space before/after;
- header-from-top and footer-from-bottom distances.

## Change

All affected commands now resolve the shared `SelectedValue` contract first and retain the legacy key as
a compatibility fallback. Font family, font size, line spacing, and paragraph style also expose their
effective caret or paragraph value through `IRibbonStatefulCommand`, so loaded documents and re-renders update the controls.
No formatting, parsing, undo, or model semantics changed after value resolution.

## Verification

- `RibbonComboCommandContractTests`: 2/2 passed against the actual shared selected-value context. The tests
  execute all nine affected commands, assert the resulting run, paragraph, style, and page settings, and
  verify initial/post-apply font-family, font-size, line-spacing, and paragraph-style ribbon values, plus
  paragraph-style state after loading another document.
- Focused adjacent compatibility tests for font family, font size, and header/footer distance: 7/7 passed
  with `--no-build`.
- WPF host and test projects compiled in Release with 0 errors.

## Acceptance

The live WPF combo route now reaches the same model-backed, undoable command behavior that existing legacy
tests exercised. The fallback keeps older programmatic callers compatible while the renderer contract is
authoritative.
