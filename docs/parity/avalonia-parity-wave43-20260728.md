# Avalonia Parity Wave 43

Date: 2026-07-28

## Functional slices

- FreeX: the modal Avalonia Cell Styles gallery now uses the same guarded command
  path as the WPF-equivalent ribbon and native-menu entries. Applying a preset
  honors opening/saving state and commits a pending formula edit before the
  undoable style mutation.
- FreeW: pressing Enter while a non-text floating object is selected no longer
  falls through to body editing and inserts a paragraph. Shape selections retain
  the existing route into shape-text editing.
- FreeP: named custom-show slideshow windows now use the visible Avalonia editor
  as their owner, matching the WPF owner policy, with an unowned fallback when
  the editor is not visible.

## Validation

- Post-merge focused regression tests: 34 passed, 0 failed. This includes the 33
  Wave 43 tests plus the upstream native Windows video-export contract.
- Full `FreeX.slnx` Release build: 0 warnings, 0 errors.
- Repository preflight: passed, including generated documentation, solution and
  project references, packaging, conflict markers, 28/28 FreeP dialog/pane
  evidence surfaces, and 33/33 paired FreeP whole-window evidence surfaces.
- Linux Docker physical interaction suites: FreeX 24/24, FreeW 37/37, and FreeP
  22/22, for 83/83 passed.
- Final default test lane: 33,007 total, 32,874 executed, 32,857 passed, 17
  failed, and 133 not executed. The 17 failures match the established
  source-order/portability baseline: six Avalonia dialog/chrome source guards,
  one host screenshot-tour source guard, one localization ownership guard, two
  presentation portability/source guards, and seven app-services
  portability/source guards.

## Generated coverage checkpoint

- FreeX: 531 functional commands, 473 command-inventory parity rows, 0
  Avalonia-missing commands, 0 real classified binding gaps, 57/57 dialog routes
  captured on both hosts, and 94 paired screenshot surface ids.
- FreeW: 870 commands with 0 actionable WPF-missing and 0 actionable
  Avalonia-missing rows.
- FreeP: 519 commands with 0 actionable WPF-missing and 0 actionable
  Avalonia-missing rows, plus 101 workflow-evidence rows.

These generated counts prove route and evidence coverage only. They do not prove
pixel-level visual parity or exhaustive real-world workflow parity.

## Remaining work

- FreeX: continue manual and pixel-level visual review of paired WPF/Avalonia
  surfaces and interactive workflow depth beyond the generated route inventory.
- FreeW: capture authoritative Microsoft Word baselines for drawing, object,
  chart, table, page-composition, print, and export surfaces.
- FreeP: capture PowerPoint-authoritative visual baselines; broaden SmartArt,
  OMML, chart-family, media/caption, PDF, and animation evidence; and validate
  recording workflows on real microphone and camera hardware.
