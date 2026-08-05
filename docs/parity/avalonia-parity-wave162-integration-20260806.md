# Avalonia parity Wave162 integration

Date: 2026-08-06

## Integrated slices

- **FreeX context validation:** corrected the executable Linux validation fixtures for Worksheet
  Show Notes and all AutoFilter criteria. Show Notes no longer waits for a dialog it never opens;
  AutoFilter validation now uses the production Filter Family entry, named operator control, required
  operand fields, and the production completion rule.
- **FreeP XamlPackage lists:** the shared external clipboard writer now emits native WPF `List` and
  `ListItem` blocks, including supported marker families, numbering starts, and nested levels. Shared
  parsing, native WPF `TextRange.Load`, and Avalonia `DataTransfer` all consume the same package.
- **FreeW paragraph evidence:** fresh paired captures proved that removing the 12-DIP client inset
  worsens all four Paragraph metrics. The probe was reverted, the mismatch remains honest, and a
  geometry regression protects the current WPF-aligned control placement.
- **Broad-lane fixes:** verification exposed an invalid FreeP WPF media fixture and an Avalonia Chart
  Style capture deadlock. The media tests now use a valid seekable WAV and shared shape ID. Chart Style
  now focuses its gallery scroll host, matching WPF and avoiding re-entrant bring-into-view layout while
  a headless bitmap is rendered; owned modal cleanup is also explicit.

## Verification

- FreeX affected context regression: **1/1 passed**; worker class: **14/14 passed**.
- Linux Docker full context catalog at 1280x820, 96 DPI: **13,801 passed, 0 failed,
  157 skipped, 13,958 total**. The Wave161 54-failure Show Notes/AutoFilter clusters are gone.
- FreeP external clipboard: shared **58/58**, native WPF **1/1**, Avalonia transfer **1/1**.
- FreeW paragraph geometry guard: **1/1 passed**. Fresh WPF and Avalonia captures completed for all
  four states; the production margin probe was rejected because every image metric regressed.
- FreeP host after the seekable fixture correction: **2,082/2,082 passed** on the then-current merged
  head; the media-controller class separately passed **37/37**.
- FreeX Avalonia capture cohort: **18/18 passed**. VSTest hang evidence recorded **1,434 passing**
  non-capture tests before isolating Chart Style. After the lifecycle fix, the Chart Style row passed
  three consecutive watchdog runs and `MissingParityDialogsTests` passed **4/4**.
- Final current-head repository preflight passed, including generated docs and the FreeW canonical
  **159 mismatch / 24 pass / 105 extension / 7 N/A** counts. An earlier refresh was externally
  terminated once and then hit its nested-wrapper ceiling; the direct final invocation completed.
- Final current-head `FreeX.slnx` Release build passed with **0 warnings and 0 errors**.
- Final touched-area reruns passed: FreeX **5/5** under a 30-second hang watchdog, FreeP shared
  **58/58**, FreeP native WPF/media host **2/2**, FreeP Avalonia transfer **1/1**, and FreeW paragraph
  geometry **1/1**.

## Honest residuals

- FreeP external XamlPackage still leaves OLE and image bullets in the private payload. WPF marker
  styles preserve numbering families but cannot preserve every parenthesis punctuation variant.
- The four FreeW Paragraph states remain genuine visual mismatches caused by capture-surface bounds and
  native rasterization, not a justified control-offset change.
- The default solution wrapper reached its ceiling while running the large Avalonia assembly. Completed
  project TRXs were green after the FreeP fixture correction; the Avalonia remainder did not produce a
  complete aggregate TRX. Focused watchdog runs prove the identified Chart Style lifecycle fix without
  skipping or reclassifying any surface.
