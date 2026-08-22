# Avalonia Parity Wave178 Integration

Date: 2026-08-22
Base revision: `8a10ce470f34c0b2acc85a24bb64bc018208100b`

## Scope

Wave178 advanced one bounded parity slice in each application and kept the
evidence standards distinct: FreeX used production physical X11 interaction,
FreeW used paired WPF/Avalonia dialog captures, and FreeP used the committed
PowerPoint reference corpus plus both renderers.

## FreeX

- The final production `FreeX` Application-host run passed `32/32` physical
  X11 rows at 1280x820 and 96 DPI, with calibration passed and no skips.
- The authoritative packaged report is
  `artifacts/linux-interactive/freex/interaction-validation/20260822T104255Z/`.
- The complete progression was `27 -> 29 -> 30 -> 31 -> 32` without removing
  rows or substituting managed evidence.
- Window management now restores calibrated geometry, split-pane cleanup is
  proven before downstream probes, exact column-outline addresses replace
  whole-column clipboard ambiguity, and physical phase one launches the
  packaged Application host instead of the TestSupport executable.
- The focused split lane passed `4/4`; the final all-lane mini-scrollbar crop
  recorded 58 changed pixels against its confined 50-pixel threshold and
  `split-cleanup-restored=true`.

## FreeW

- The Paragraph dialog keeps its route-local visual metrics while matching the
  380x399 WPF authority and 24-DIP field/action geometry.
- Fresh initial/populated changed pixels improved from 17.7259% to 12.4284%;
  perceptual hash distance improved from 12 to 2. Validation improved from
  18.2634% to 13.1302%, also with hash distance 12 to 2.
- The corrected visual test measures and arranges the declared 399-DIP capture
  viewport. The focused suite passed `8/8`.
- The rows remain honest visual mismatches because native framework text and
  template rasterization still differ; this wave does not relabel them passes.

## FreeP

- No production renderer change was accepted for grouped-list corpus slides 09
  and 10 because both bounded candidates would replace authoritative
  PowerPoint cached geometry or risk sibling slides.
- Fresh slide 09 measured WPF/Office 1.6516%, Avalonia/Office 1.6879%, and
  WPF/Avalonia 1.6609% changed pixels.
- Fresh slide 10 measured WPF/Office 4.4798%, Avalonia/Office 4.6503%, and
  WPF/Avalonia 1.6260% changed pixels.
- The new fixture test locks the cached-authoritative
  `IncreasingCircleProcess` route, unsupported cached `vList6` route, and four
  authored bullet paragraphs. The focused suite passed `6/6`.

## Focused Verification

- FreeX interaction runner source contracts: `20/20` passed.
- FreeX Docker `bash -n`: passed.
- FreeW Paragraph dialog tests: `8/8` passed.
- FreeP SmartArt fixture evidence tests: `6/6` passed.
- Cross-app dashboard check: passed.
- FreeW canonical evidence consistency: 291 rows, 141 genuine visual
  mismatches, 80 passes, 70 Avalonia extensions, and 0 not-applicable rows.

## Integration Gates

- Repository preflight passed, including generated-document and cross-app
  dashboard checks.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings
  and zero errors in 3 minutes 54 seconds.
- The first default lane exposed a stale source-ownership assertion that still
  required the physical X11 phase to use the TestSupport executable. The guard
  now requires the packaged Application host while retaining the separately
  packaged TestSupport validation executable; its focused suite passed `3/3`
  and the rerun Services project passed `3459/3459`.
- The default lane retains the known Windows headless renderer residual:
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`
  receives an empty PNG. The other `2148` tests in that project passed in both
  full runs.
- One parallel rerun reported the FreeP slideshow window as still visible after
  its owner closed. That test passed in the first full lane and in `3/3`
  immediate isolated reruns, so it is recorded as non-reproduced headless
  timing noise rather than a Wave178 product regression.
