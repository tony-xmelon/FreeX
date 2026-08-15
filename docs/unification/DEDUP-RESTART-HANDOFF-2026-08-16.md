# Deduplication restart handoff - 2026-08-16

## Integrated state

- Integration commit before this note: `986c9844f0`.
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
- The WPF parity baseline contains 116/116 captured surfaces with no capture failures.
  A post-integration current capture was not rerun before restart and remains the first
  visual-verification step.

## Residual scope

A final read-only scan reported 1.172% exact duplication overall. Most large FreeP
matches are native renderer realization rather than duplicated application behavior.
The remaining actionable candidates are:

1. Share FreeX measured print-text wrapping and ellipsis policy between
   `PrintRenderer.DrawingObjects.cs` and `PrintCommentSummaryPlanner.cs`.
2. Share FreeP output filename-stem normalization across print packages, video-frame
   packages, and image export, preferably in `Free.Shared.IO`.
3. Share finite-matrix, scale, and canvas-coordinate helpers used by
   `WpfXpsTextOverlayExtractor` and `PdfDocumentExporter`.
4. Route `PortablePdfDocumentExporter` destination writes through the shared atomic
   file/export executor.
5. Hoist the duplicated FreeP WPF/Avalonia `PresentationFileCommandSession`
   composition into a neutral factory.
6. Review the small FreeP asset-import picker/read projection for a shared adapter.

Backstage print control trees, slideshow timers and overlays, slide/document drawing
sinks, focus/event wiring, accessibility peers, native dialogs, and OS-specific I/O
backends are the accepted renderer/backend floor unless a later audit finds semantic
decisions inside them.

## Restart sequence

1. Regenerate `dedup-residual-metrics.md` at current `main`.
2. Run the WPF parity capture and compare all 116 surfaces with the saved baseline.
3. Take the six residual candidates above in small, independently verified slices.
4. Re-run repository preflight, the Release solution build, default tests, and the
   partitioned UI lane before declaring the exhaustion goal complete.
