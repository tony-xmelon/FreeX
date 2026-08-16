# Deduplication restart handoff - 2026-08-16

## Integrated state

- Architecture-residual integration commit before this update: `047144c3be`.
- FreeX, FreeW, and FreeP now route application semantics through shared planners,
  sessions, coordinators, and portable services. WPF and Avalonia retain native
  control construction, input translation, drawing, accessibility, and OS backends.
- The campaign covered adaptive ribbon state, the common application frame and
  workareas, Backstage workflows, dialogs and localization, editors and status bars,
  QuickAnalysis and PageLayout, chart/table/textbox/shape flows, slideshow and
  presenter state, and file/open/save/import/export/print/scan/recording workflows.
- I/O now has shared picker/read/lifecycle contracts, atomic export execution, print
  selection/submission planning, temporary-resource ownership, output-package
  execution, and recording/export sessions. Native WPF/Avalonia pickers, Windows/CUPS
  printing, WPF/Skia rendering, screen capture, and ffmpeg integration remain adapters.

## Verification completed

- Release solution build: 0 warnings and 0 errors before the final upstream sync.
- FreeX Avalonia tests: 2,050 passed.
- FreeP presentation tests: 5,008 passed.
- Focused shared-workflow wrap-up: 20 passed, covering filter routing, macOS atomic
  export readiness, documentation metrics, autofill routing, and status-bar
  accessibility.
- Additional focused slices passed for sheet movement (3), autosave ownership (3),
  source-hygiene/native-print guards (5), and validation-circle rendering (1).
- The final six architecture candidates were closed with 381 focused pure tests:
  measured print wrapping (13), PDF transform math (206), atomic output/path policy
  (31), and FreeP file/asset composition plus export ownership (131).
- Release compile-only builds for the FreeX and FreeP WPF and Avalonia applications
  passed with 0 warnings and 0 errors after the four slices were integrated.
- The WPF parity baseline contains 116/116 captured surfaces with no capture failures.
  A post-integration current capture was not rerun before restart and remains the first
  visual-verification step.

## Residual scope

A current-tree scan reports 1.161353% exact duplication overall, down from 1.225863%
in the prior generated report. All six previously listed actionable candidates are
closed:

1. `MeasuredTextWrapPlanner` now owns FreeX measured wrapping and ellipsis policy.
2. `OutputFileNameStemPolicy` now owns FreeP print/video/image filename normalization.
3. `PdfTransformMath` now owns affine finiteness, scale, and canvas-coordinate policy.
4. `PortablePdfDocumentExporter` now writes through `AtomicExportExecutor`.
5. `PresentationFileCommandSessionFactory` now owns WPF/Avalonia session composition.
6. `PresentationAssetPickerAdapter` and `PresentationAssetReaderAdapter<TSource>` now
   own the common asset-import native-port projection and source lifetime contract.

The largest remaining lexical matches are native window/control construction,
slideshow/presenter timing and overlay realization, canvas drawing, dialog layout,
focus/event wiring, accessibility peers, and OS-specific backend adapters. These are
the accepted renderer/backend floor unless a behavioral audit identifies a semantic
decision inside one of them; lexical similarity alone is not sufficient reason to
combine toolkit-native code.

Backstage print control trees, slideshow timers and overlays, slide/document drawing
sinks, focus/event wiring, accessibility peers, native dialogs, and OS-specific I/O
backends are the accepted renderer/backend floor unless a later audit finds semantic
decisions inside them.

## Restart sequence

1. Run the WPF parity capture and compare all 116 surfaces with the saved baseline.
2. Review any visual or behavioral failures for renderer-owned semantic policy; add
   new shared slices only where the evidence demonstrates such policy.
3. Re-run repository preflight, the Release solution build, default tests, and the
   partitioned UI lane before declaring the exhaustion goal complete.
