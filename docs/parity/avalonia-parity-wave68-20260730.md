# Avalonia parity Wave68

Wave68 advanced one bounded parity slice in each app on top of the Round 95
source review fixes. Functional and physical contracts closed for FreeX and
FreeP; FreeW recorded a further visual improvement without weakening mismatch
classifications.

## FreeX: Name Box drawing objects

- The deterministic physical fixture now includes named chart, picture, shape,
  and text-box objects alongside the existing defined name and table.
- WPF and Avalonia project the same shared `NameBoxDropdownPlanner` order and
  route object selection through their production drawing-selection paths.
- Avalonia now preserves the selected object's name in the Name Box after shell
  refresh, matching WPF instead of displaying the object's anchor address.
- The Linux validator fails closed on exact item name, object kind, object ID,
  selected-object state, active cell, neutral baseline, and event sequence.

Verification:

- Focused managed tests: 30 passed.
- Linux physical contract: 6/6 passed.
- Evidence:
  `artifacts/linux-interactive/freex/interaction-validation/20260730T132717Z`.

## FreeW: Font and Paragraph dialogs

- Shared compact ComboBox chrome now normalizes the real Fluent dropdown glyph
  idempotently.
- Checkbox font/baseline alignment and one-pixel tab-pane positioning moved
  closer to the WPF captures.
- Font average changed pixels improved from 14.045% to 12.963%.
- Paragraph average changed pixels improved from 9.844% to 9.622%.

Verification:

- Focused Avalonia tests: 19 passed.
- All ten paired rows remain honestly classified as visual mismatches.
- Detailed metrics:
  `docs/parity/avalonia-parity-wave68-freew-font-paragraph-20260730.md`.

## FreeP: in-canvas pointer selection

- A shared planner now owns direction-preserving logical pointer selection.
- Avalonia hit-testing selects the nearest measured paragraph span across
  unequal wrapped lines and paragraph gaps.
- WPF native selection and Avalonia selection are checked against the same
  two-paragraph logical range.
- The physical lane performs forward and reverse X11 drags, exact bounded
  `xclip` readback, screenshots, geometry proof, and a byte-identical read-only
  package check.

Verification:

- Focused managed tests and source guards: 8 passed.
- Linux physical contract: 5/5 passed.
- Evidence:
  `artifacts/p68/freep/sessions/20260730T134045921Z/freep-rich-text-shortcut-validation`.

## Residuals

- FreeW Font and Paragraph remain visually different in text rasterization,
  native tab/scrollbar details, and a few compact control metrics.
- FreeX still needs a fresh automated paired WPF/Avalonia composite for the
  open Name Box popup itself; this wave closes its behavior and exact Linux
  object-selection evidence.
- FreeP physical evidence proves observable selection text and direction, while
  managed geometry tests remain the direct numeric hit-testing proof.
- Overall Avalonia/WPF parity remains active beyond these three slices.
