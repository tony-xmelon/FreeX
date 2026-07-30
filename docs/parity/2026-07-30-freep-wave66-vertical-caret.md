# FreeP Wave66: Vertical visual-line caret navigation

## Scope

Avalonia in-canvas rich text now moves Up/Down through measured wrapped visual
lines with a stable preferred horizontal position. Shift+Up/Shift+Down uses the
same route while retaining the existing shared selection-anchor and grouped-child
editing identity behavior. Visual Home/End uses the same measured-line contract.

The shared planner receives renderer-measured visual-line caret points and owns
line choice, wrap-boundary ownership, preferred-X retention, paragraph/newline
crossing, and document-edge no-op behavior. Avalonia supplies only its
`TextLayout` measurements. WPF remains on its native `RichTextBox` route.

## Evidence

- Shared planner tests cover wrapped-boundary ownership in both directions,
  unequal-width repeated Down/Up preferred-X round trips, paragraph crossings
  with newline offsets, visual Home/End endpoints, and first/final-line no-op
  clamping.
- Avalonia headless tests cover wrapped and cross-paragraph Up/Down, repeated
  Shift navigation, anchor retention, and preferred-X reset after horizontal,
  Home/End, pointer, and mutation input.
- WPF STA evidence lays out a wrapped native `RichTextBox`, drives native
  vertical key routing, verifies movement between visual lines, and pins native
  Up-at-first-line / Down-at-final-line logical no-op behavior.

## Physical status

The existing Linux grouped-child probe passed its five-row contract after being
extended with repeated Down/Up and Shift+Up/Shift+Down injection plus
screenshots. Evidence:
`artifacts/freep-wave66-vertical-caret-20260730/freep/sessions/20260730T085936838Z/freep-rich-text-shortcut-validation/results.json`.

The probe can reliably prove focused physical input routing and visible state,
but this harness has no reliable caret-offset or clipboard readback contract
(`xclip`/`xsel` are not available here). Its `vertical-input-route` field is
therefore intentionally not semantic proof; the managed shared/Avalonia/WPF
tests are the semantic evidence for this slice. The fixture also remains a
bounded two-paragraph grouped-child document rather than an exhaustive
unequal-width visual-line corpus.
