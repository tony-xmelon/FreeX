# FreeW live citation-style application

Date: 2026-08-04

## Result

Changing References > Citation Style now applies to the current document immediately in both WPF and Avalonia. One shared `ApplyCitationStyleCommand` updates the selected style, recomputes every existing native `CITATION` field cache, and rebuilds an existing generated bibliography in place.

The operation is one undoable edit. Undo restores the prior style, the exact cached citation text, and the original bibliography block objects; Redo reapplies the new style. A style change does not insert a bibliography into a document that did not already contain one.

Citation traversal covers body paragraphs, table cells, shape text, nested drawing-group shape text, final-section headers and footers, and non-final section stories. Duplicate story references are suppressed by run identity.

## Verified example

An existing APA citation `(Smith, 2024)` and APA bibliography were changed to IEEE. The citation became `[1]`; the bibliography became `References` plus `[1] Smith, "A Work," Press, 2024.`. Undo restored APA content and style.

## Verification

- Shared citation style command: 2/2 focused tests, including header-story refresh, no-bibliography control, Undo, and Redo.
- Citation and complex-field model lane: 127/127.
- WPF citation editor lane: 19/19.
- Avalonia References lane: 59/59.
- Bibliography and citation package lane: 36/36.
- Full Core Model: 1659/1659.
- Full Core IO: 1445/1445.

## Process rule

A ribbon state change is not functional parity when structured fields keep stale cached results. Apply document-wide semantic settings through one shared undoable command, refresh only already-present generated regions, and verify body plus alternate story ownership before host integration.
