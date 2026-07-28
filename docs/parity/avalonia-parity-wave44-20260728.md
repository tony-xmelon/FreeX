# Avalonia Parity Wave 44

Date: 2026-07-28

## Functional slices

- FreeX: the shared application-options model now persists
  `EnableFillHandleAndCellDragAndDrop`. WPF and Avalonia read the same setting,
  hide and disable the autofill handle when it is off, and gate selection-border
  move/copy gestures without disabling keyboard or ribbon fill commands.
- FreeW: Avalonia paragraph shading now exposes the same 12-color palette and
  `No Color` behavior as WPF instead of applying a fixed yellow toggle. Palette
  commands use the existing undoable shared document-model route.
- FreeP: closing normal or named custom-show playback preserves the editor's
  selected slide, matching WPF. The integration also retained upstream slideshow
  media, chart, SmartArt, animation, and clone-preservation work.
- FreeP evidence: the bending-process SmartArt parity test now removes the
  headless fixture's default shape and validates the five shared live draw
  operations directly instead of relying on obsolete generated shape ids.

## Validation

- Focused integration tests: FreeX 109/109, FreeW 3/3, FreeP slideshow/media
  50/50, plus 9/9 related bending-process SmartArt checks.
- Full `FreeX.slnx` Release build on the final rebased head: 0 warnings,
  0 errors.
- Linux Docker physical interaction suites: FreeX 24/24, FreeW 37/37, and
  FreeP 22/22, for 83/83 passed. The final FreeP lane was rerun after all
  upstream FreeP synchronization and the SmartArt test correction.
- Repository preflight: passed, including generated documentation, 122 project
  files, 88 solution entries, platform packaging, 28/28 FreeP dialog/pane
  surfaces, 33/33 FreeP whole-window pairs, and 9,350 conflict-marker inputs.
- Final default test lane: 33,040 total, 32,907 executed, 32,890 passed,
  17 failed, and 133 not executed. The 17 failures are the unchanged baseline:
  six Avalonia dialog/chrome source guards, one host screenshot-tour guard,
  one localization ownership guard, two presentation portability guards, and
  seven app-services portability/source guards.

## Generated coverage checkpoint

- FreeX: 531 functional commands, 473 command-inventory parity rows,
  0 Avalonia-missing commands, 0 real classified binding gaps, 57/57 dialog
  routes on both hosts, and 94 paired screenshot surface ids.
- FreeW: 883 commands with 0 actionable WPF-missing and 0 actionable
  Avalonia-missing rows. The 13 new profile-shape rows describe the paragraph
  shading palette choices rather than missing WPF behavior.
- FreeP: 521 commands, 519 shared-profile rows, 0 actionable WPF-missing and
  0 actionable Avalonia-missing rows, plus 101 workflow-evidence rows.

These generated counts prove route and evidence coverage only. They do not prove
pixel-level visual parity or exhaustive real-world workflow parity.

## Remaining work

- FreeX: continue manual and pixel-level review of paired WPF/Avalonia surfaces
  and deeper interactive workflows beyond generated route coverage.
- FreeW: capture authoritative Microsoft Word baselines for drawing, object,
  chart, table, page-composition, print, and export surfaces.
- FreeP: capture PowerPoint-authoritative visual baselines; broaden SmartArt,
  OMML, chart-family, media/caption, PDF, and animation evidence; and validate
  recording workflows on real microphone and camera hardware.
