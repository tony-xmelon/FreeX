# Avalonia parity Wave 73

Date: 2026-07-31

## Scope

Wave 73 advanced one bounded WPF-authority slice in each app:

- FreeX Pivot Value Field Settings validation and focus recovery.
- FreeW Page Setup action semantics and launcher geometry.
- FreeP Review Comments resolve, reopen, reply, and selection drift guards.

## FreeX

Avalonia Show Values As validation now resolves the shared validation plan
through `UiText`, matching WPF's localized missing-base-field and
missing-base-item messages. After the warning, Avalonia selects the Show Values
As tab and restores the WPF invalid-input focus target: the base-field combo or
the selected base-item text.

Focused Pivot Value Field Settings coverage passed 18/18. A targeted production
Linux run opened catalog route 90 and passed all 3 interaction rows: the dialog
opener, dialog inventory, and routed keyboard/focus contract. Evidence is under
`artifacts/linux-interactive/freex/wave73-pivot-value-settings/`.

## FreeW

Avalonia Page Setup now keeps the WPF action row first in logical child order,
uses the WPF Unicode ellipsis launcher labels, and aligns launcher width and
spacing. Default and cancel semantics remain on the shared action row.

The final route-scoped comparison removes all six
`default-button,cancel-button,action-button-order` residuals. Across the six
Page Setup states, average changed pixels improved from 14.83% to 12.11% and
average mean channel delta improved from 7.90 to 7.03. The report still
classifies all six as genuine visual mismatches.

The production Linux app opened Page Setup from the Layout ribbon, rendered the
Layout tab, and exposed `OK`, `Cancel`, `Line Numbers...`, and `Borders...`
through AT-SPI using the expected Unicode ellipsis names. Clicking Line Numbers
closed the modal and dirtied the document, proving the launcher callback path.
Screenshots are under
`artifacts/linux-interactive/freew/wave73-page-setup/`.

Focused verification passed 13/13 Avalonia WPF-authority tests and 3/3 WPF Page
Setup tests.

## FreeP

The audit found no bounded production deficiency in the shared Review Comments
resolve, reopen, reply, selection, and replyability paths. A paired source
contract now locks both hosts to `PresentationReviewWorkflowSession` and checks
their host-specific selection and reply-state hooks. Focused Avalonia coverage
passed 2/2 on the integrated branch. Because this slice changes no production
code, the prior physical Linux family baseline remains applicable.

## Residuals

This wave does not establish whole-product or pixel-perfect parity. FreeW Page
Setup retains six genuine visual mismatches, FreeP still needs
PowerPoint-authoritative live comments/review baselines, and the broader
cross-app dashboard backlog remains active.
