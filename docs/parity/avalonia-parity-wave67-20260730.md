# Avalonia parity Wave67

Wave67 advanced one bounded parity slice in each app and was integrated on top of
`origin/main` through the Round 94 core fixes.

## FreeX: Name Box navigation list

- Added a renderer-neutral `NameBoxDropdownPlanner` shared by WPF and Avalonia.
- The list now projects active-scope defined names, structured tables, and visible
  named shapes, pictures, text boxes, and charts in deterministic order.
- WPF and Avalonia select range targets through their normal navigation routes and
  object targets through their normal drawing-object selection routes.
- Avalonia uses an explicit focusable popup because `DropDownButton`/`MenuFlyout`
  activation was not reliable on Linux X11. Keyboard navigation commits only on
  Enter; pointer release commits the selected row.
- Typed A1, cross-sheet, defined-name, table-name, and define-name behavior remains
  separate from dropdown item identity, preserving existing collision precedence.

Combined verification:

- Shared planner: 3 passed.
- WPF production route: 1 passed under the repository STA runner.
- Avalonia Name Box class: 12 passed.
- Linux physical selector: 2/2 passed from neutral `G10`.
  - Defined name copied exactly `Region`.
  - Third dropdown item copied the table body exactly `North<TAB>120`.
  - Evidence:
    `artifacts/linux-interactive/freex/interaction-validation/20260730T110953Z`.

The first physical attempt had incorrectly treated an already-selected `Region`
cell as a pass while the popup was closed. The final probe explicitly starts from
neutral `G10`, requires popup-surface/focus evidence, and requires two distinct
exact clipboard postconditions.

## FreeW: Font and Paragraph dialogs

- Added opt-in shared compact-dialog metrics for text fields, combo boxes, tabs,
  buttons, foreground, borders, and focus adorners.
- Applied WPF-owned dimensions and chrome to the Avalonia Font and Paragraph
  dialogs.
- Corrected the Avalonia evidence reader so scrollbar `RepeatButton` controls are
  not reported as dialog action buttons.
- Added focused geometry/chrome tests.

Fresh paired visual evidence improved without changing thresholds or
classifications:

| Family | Changed pixels before | Changed pixels after | Mean delta before | Mean delta after |
| --- | ---: | ---: | ---: | ---: |
| Font, five-state average | 16.980% | 14.045% | 13.313 | 12.573 |
| Paragraph, five-state average | 16.123% | 9.844% | 16.176 | 11.063 |

Combined focused Avalonia verification passed 6/6. Detailed per-scenario metrics
are in `docs/parity/avalonia-parity-wave67-freew-font-paragraph-20260730.md`.
All ten paired rows remain honestly classified as genuine visual mismatches.

## FreeP: physical vertical-caret semantics

- Added a caret-specific native PPTX fixture with unequal-width wrapped lines.
- Extended the existing five-row grouped-caret Linux contract with bounded
  `xclip` clipboard transcripts.
- Exact selected text is now checked after Shift+vertical movement, preferred-X
  roundtrip movement, and physical save/reopen.
- Missing tools, stale clipboard payloads, timeouts, missing artifacts, or byte
  mismatches fail closed.

Combined verification:

- Shared preferred-X planner: 4 passed.
- Avalonia rich-text geometry/navigation: 3 passed.
- WPF vertical-navigation authority: 2 passed.
- Linux physical contract: 5/5 passed.
- Evidence:
  `artifacts/wave67-combined-freep-r2/freep/sessions/20260730T111500021Z/freep-rich-text-shortcut-validation/results.json`.

The first combined physical run caught a stale reopen clipboard payload. The
final probe retains the X11 reopened-editor command transition before performing
the bounded authoritative copy; the rerun passed all five rows.

## Residuals

- FreeW Font and Paragraph remain genuine visual mismatches, principally in text
  rasterization, combo-arrow templates, checkbox baselines, and one-pixel pane
  positioning.
- FreeX object selection is covered through both production hosts in managed
  tests; this wave's bounded Linux lane physically exercises defined-name and
  table rows, not every object kind.
- FreeX's new Avalonia popup still needs a dedicated paired WPF/Avalonia visual
  capture before claiming visual fidelity for the dropdown itself.
- FreeP physical clipboard evidence proves observable selection semantics but
  does not expose a numeric caret X coordinate; managed geometry tests remain the
  direct preferred-X proof.
- Overall Avalonia/WPF parity remains active beyond these three slices.
