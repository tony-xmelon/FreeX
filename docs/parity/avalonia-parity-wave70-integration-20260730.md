# Avalonia parity Wave70 integration

Date: 2026-07-30

Wave70 integrates one bounded parity slice for each app. It does not claim
whole-application 100% parity.

## FreeX

- The Avalonia Name Box opens its production autocomplete popup from the WPF
  gestures `Alt+Down` and `F4`.
- Popup keyboard input is handled through Avalonia's routed-event tunnel with
  handled events included, so the native list control cannot consume Enter
  before the selected item commits.
- Committing a dropdown item now clears pending Name Box edit state. Subsequent
  worksheet selection therefore restores the active address instead of leaving
  a stale table name in the field.
- Focused managed verification passed 15/15 Name Box tests and 8/8 Linux runner
  tests.
- Native X11 verification passed 8/8: keyboard and pointer table selection,
  defined-name and table navigation, and exact Chart, Picture, Shape, and
  TextBox object selection.

Authoritative local evidence:

- `artifacts/linux-interactive/freex/interaction-validation/20260730T173634Z`

## FreeW

- Ten canonical Font and Paragraph dialog states were recaptured against WPF
  authority at 96 DPI.
- Font changed pixels improved from `11.488%` to `8.016%`; mean channel delta
  improved from `10.302` to `7.519`.
- Paragraph changed pixels improved from `8.594%` to `8.345%`; mean channel
  delta improved from `10.032` to `9.807`.
- Focused verification passed 9/9.
- All ten states remain genuine visual mismatches. No threshold,
  classification, or WPF authority surface was weakened.
- `paragraph.tab-line-and-page-breaks` remains an explicit mixed result:
  changed pixels rose from `8.235%` to `8.249%`, mean delta improved from
  `11.021` to `10.759`, and perceptual hash distance remained `5`.

The detailed per-state audit is in
`avalonia-parity-wave70-freew-font-paragraph-20260730.md`.

## FreeP

- WPF and Avalonia rich-text selection colors now share the standard WPF
  selection contract: `#0078D7` background and white selected text.
- Avalonia repaints selected glyphs as well as the selection background.
- Focused managed verification passed 47/47.
- The physical Linux pointer-selection lane passed 5/5, including exact
  forward and reverse multiline clipboard text and byte-identical source
  package proof.
- A fresh managed whole-window run captured 33/33 WPF/Avalonia pairs with zero
  limitations. It currently reports 32 passes and one honest mismatch,
  `editor.rich-text-selection`.
- The complete-window pair for that state passes (`11.592%` changed pixels,
  mean channel delta `9.658`, perceptual hash distance `2`). Its strict
  selection crop still fails because the hosts place the editor at different
  coordinates and the crop differs (`62.713%`, `60.195`, `12`).

Authoritative local evidence:

- `artifacts/wave70-freep-selection`
- `artifacts/wave70-freep-whole-window`

The selection-crop residual remains active Wave70 work. The committed
cross-app dashboard is not refreshed until a fresh authoritative FreeP pair
passes or the residual is published honestly as a mismatch.
