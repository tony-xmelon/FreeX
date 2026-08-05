# Avalonia Parity Wave 158: FreeW Visual Evidence And Disabled Combo Chrome

Date: 2026-08-05
Worktree: `codex-avalonia-parity-wave158-freew-visual-20260805`
Authority: app-owned FreeW WPF dialog harness at 96 DPI

## Fresh route evidence

The real `FreeW.DialogVisualHarness` capture and comparison flow was run with foreground,
single-node, build-server-disabled commands. Temporary route inventories were mechanically
filtered from the tracked evidence inventory; no metrics or images were hand-authored.

- `table-properties`: **7/7 WPF** and **7/7 Avalonia** captures passed all content gates.
- `options`: **8/8 WPF** and **6/6 Avalonia** captures passed all content gates. The two WPF-only
  `Replace` and `With` metadata states remain truthful `state-not-applicable` rows.
- Both routes were merged into the tracked report through `--baseline` and `--refresh-route`.
- The canonical report and dashboard remain at **158 genuine visual mismatches, 25 passes,
  105 Avalonia extensions, and 7 state-not-applicable rows** across 295 rows.

Selected refreshed route metrics include:

| Route/state | Changed ratio | Mean channel delta | Classification |
| --- | ---: | ---: | --- |
| `options.initial` | 5.5327% | 4.1138 | genuine visual mismatch |
| `options.tab-auto-correct` | 8.0116% | 5.6465 | genuine visual mismatch |
| `table-properties.tab-cell` before this wave | 12.2143% | 8.0737 | genuine visual mismatch |

## Bounded visual fix

`table-properties.tab-cell` was selected as the highest-impact actionable residual after the
route refresh. WPF paints disabled Positioning ComboBox fields as one uniform light input
surface. Avalonia's realized Fluent template retained a `Border` named `Background` with a
semi-transparent black fill (`#33000000`) over the trailing dropdown slot, even though the
dialog had already normalized the main `PART_LayoutRoot` surface.

`AvaloniaCompactDialogChrome.ApplyWpfDisabledComboSurface` now normalizes that named template
surface to the ComboBox's existing WPF-matched background. The change is used only by the four
disabled Positioning ComboBoxes on the Cell tab; enabled controls and other dialogs are
unchanged.

| State | Before ratio / mean | After ratio / mean |
| --- | ---: | ---: |
| `table-properties.tab-cell` | 12.2143% / 8.0737 | **11.4702% / 7.6023** |
| Other six table-properties states | unchanged | unchanged |

The Cell state improved by **0.7441 percentage points** and **0.4714 mean channel delta**.

## Verification

- Avalonia focused parity tests: **18/18 passed** (`LegalNoticesDialogVisualParityTests` and
  Table Properties WPF-authority tests).
- WPF focused authority tests: **12/12 passed** (`FreeWHelpInfoTests` and
  `TablePropertiesDialogTests`).
- WPF and Avalonia route captures: all listed captures passed content gates.
- `Test-FreeWDialogVisualEvidence.ps1`: passed.
- `Test-CrossAppParityDashboard.ps1`: passed.
- `Test-GeneratedDocs.ps1`: passed.
- `git diff --check`: passed.

## Residuals

The largest remaining paired rows are the long Legal Notices tabs. Fresh route-local captures
still show `tab-legal-notices` at approximately **18.19% / 19.67** and the other long tabs in
the **16.89%-17.19%** changed-pixel range. Their remaining delta is primarily WPF ClearType
versus Avalonia/Skia glyph rasterization plus native scrollbar/template pixels. The existing
12.1px Consolas compensation remains the measured best host-local choice; a 12.0px trial was
rejected because it worsened every state. No threshold or classification was weakened.
