# FreeW Avalonia Home formatting combo state parity (2026-08-04)

## Gap

The Avalonia Home font-family, font-size, and line-spacing combos executed selected values but used
write-only commands. Ribbon refresh therefore could not publish the effective caret formatting after
loading a document, moving the caret, applying formatting, or undoing a change.

## Change

All three commands now implement `IRibbonStatefulCommand` and read the effective formatting returned
by `DocumentView.GetCaretFormatting`. Font selections still use the existing undoable run-formatting
path, while line spacing still uses the paragraph command path. Non-positive and malformed numeric
values are rejected.

## Behavior

- Loaded document defaults publish as the current font family and point size.
- Applied font family and size values publish immediately and Undo restores the prior values.
- Line spacing publishes the current multiplier, including changes made through fixed aliases.
- Empty, malformed, and non-positive values do not mutate the model or displayed state.

## Verification

- `CommandRegistryTests` focused compiling and no-build runs.

## Process rule

For value-bearing ribbon controls, execution coverage is only half the contract. Read state from the
same effective model cascade used for rendering, then test loaded, applied, invalid, alias, and Undo
paths against that source of truth.
