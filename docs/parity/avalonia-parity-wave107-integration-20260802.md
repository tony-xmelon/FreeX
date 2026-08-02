# Avalonia Parity Wave107 Integration

Date: 2026-08-02

## Delivered

- FreeX Scenario Manager now uses the WPF spacing rhythm, compact 22px dialog
  chrome, aligned checkbox margins, and matching range-picker button styling.
- FreeW Legal Notices now realizes the WPF-measured 14.6px line box for short
  and overflowing documents.
- FreeP slide-pane thumbnails now consume one shared centering policy in both
  WPF and Avalonia.
- The newly merged FreeP video-export capability source guard now verifies the
  current shared planner contract instead of the obsolete no-argument call.

## Measured Evidence

- FreeX Scenario Manager triage score improved from `0.103523` to `0.063362`;
  non-background delta improved from `0.044216` to `0.015949`. It is no longer
  a leading FreeX paired outlier. The generated FreeX dashboard now reports
  `0.103141` as the highest remaining triage score and still has zero candidates
  at the `0.4` review threshold.
- All six FreeW Legal Notices states improved in fresh WPF/Avalonia captures.
  Reductions ranged from `0.826` to `2.092` percentage points. The two largest
  long-document rows now measure `19.574%` and `19.898%`, down from `21.665%`
  and `21.736%`.
- FreeP whole-window evidence remains `33/33` paired with zero explicit product
  mismatches; dialog/pane evidence remains `28/28` pass.

## Linux Evidence

- FreeP physical X11 family lane: `24/24` passed. The run covered key tips,
  Backstage, slide-pane selection/navigation, New Slide, undo/redo, duplicate,
  delete, keyboard and pointer context menus, and the animation pane. The
  captured slide-pane frame shows the thumbnail stack centered.
- FreeX production Linux parity capture emitted a valid
  `dialog.ScenarioManager.png` at 96 DPI with the complete Close row visible
  and no bottom clipping.
- Both harness-owned containers exited or were stopped; no interactive parity
  container remained running after evidence collection.

## Verification

- Focused FreeX: `7/7` passed.
- Focused FreeW: `20/20` passed; fresh captures `6/6` WPF and `6/6` Avalonia.
- Focused FreeP slide pane: `411/411` passed across shared, WPF, and Avalonia
  lanes.
- Repository preflight: passed on the final integrated source.
- Release solution build: passed with `0` warnings and `0` errors.
- Default solution: `35,447` passed, `0` failed, `133` skipped; `35,580` total.

## Remaining

- FreeX's next generated visual outlier is `dialog.ErrorChecking` at `0.103141`.
- FreeW still has `166` genuine visual mismatches, `17` paired passes,
  `96` Avalonia extensions, and `4` state-not-applicable rows. Legal Notices
  still retains native font, tab, border, and scrollbar raster differences.
- FreeP still needs PowerPoint-authoritative thumbnail and richer slide-content
  baselines, broader real-deck/COM evidence, and additional SmartArt/math/media
  depth. Local paired coverage remains evidence of host agreement, not proof of
  exact PowerPoint fidelity.
