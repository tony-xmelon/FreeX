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

- WPF and Avalonia rich-text selection colors now share one contract for the
  nominal WPF palette, native selection opacity, and realized 96-DPI colors.
- Avalonia repaints selected glyphs as well as the selection background.
- Both editors now honor the shared `TextBody.Wrap` model policy. The physical
  grouped-child fixture exercises wrapped pointer selection, while the
  deterministic mixed-font visual pair explicitly exercises no-wrap clipping.
- Avalonia matches WPF horizontal selection reveal, text origin, and fractional
  left-edge raster placement.
- Selection adorners render above the active text editor, matching WPF's
  `AdornerDecorator` z-order without changing interaction coordinates.
- Focused managed verification passed 441/441 across the shared planner and
  visual contract, both editors, the Avalonia headless shell, harness source,
  and paired comparison tests.
- The physical Linux pointer-selection lane passed 5/5, including exact
  forward and reverse multiline clipboard text and byte-identical source
  package proof. Its probe now distinguishes the margined shape layer from the
  full-stage text-editor overlay and validates under Windows PowerShell 5.1.
- A fresh managed whole-window run captured 33/33 WPF/Avalonia pairs with zero
  limitations, zero duplicate captures, and 33 passes.
- The complete-window rich-selection pair passes at `10.358%` changed pixels,
  mean channel delta `8.102`, and perceptual hash distance `2`.
- Its strict `263x78` selection crop also passes at `18.860%` changed pixels,
  mean channel delta `8.612`, and perceptual hash distance `4`.

Authoritative local evidence:

- `artifacts/p71`
- `artifacts/wave70-freep-whole-window-final2`

The committed FreeP whole-window evidence and cross-app dashboard are refreshed
from the passing pair.

## Integration verification

- Repository preflight passed.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings
  and zero errors.
- The default non-UI lane completed 33,997 tests: 33,864 passed, 133 skipped,
  and zero failed.
- The documented `FreeX.UiTests.slnx` command currently exits without
  scheduling its two projects because those legacy project files do not set
  `IsTestProject`. Forcing `FreeX.App.UI.Tests` to execute ran 1,042 tests:
  1,011 passed, 27 skipped, and four unrelated existing FreeX grid/chart
  source-contract tests failed. Wave70 changes no FreeX UI source or those
  tests; the relevant FreeP WPF/Avalonia managed and physical lanes above are
  green.
