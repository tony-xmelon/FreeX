# Avalonia Parity Wave 186 Integration

Date: 2026-08-23

Wave 186 completes one bounded parity slice per application and brings the
cumulative processed app-slice count to **558**. Generated command inventories
continue to report zero actionable Avalonia-missing commands across FreeX,
FreeW, and FreeP. The remaining work is physical workflow breadth and visual
fidelity, not missing top-level command routes.

## FreeX

The production Linux/X11 AutoFilter text-criteria lane now passes 2/2 physical
workflows. Begins With `North` preserves `North,Northwest,` and serializes
`North*`; Equals `East` preserves `East,,` and serializes `East`. Both save
cleanly and reopen with the same visible rows. XLSX loading now reapplies
supported `customFilters` when row-hidden replay bits are absent, with focused
equality, wildcard, and numeric round-trip coverage.

The generated dashboard remains at 568/574 command-inventory parity with zero
Avalonia-missing commands and zero classified real behavior gaps. All 57 dialog
routes and 94 paired dialog surfaces remain represented. Number, date, color,
multi-column/composite, and clear/reapply AutoFilter workflows remain outside
the physical evidence set.

## FreeW

The seven-state Table Properties comparison received route-local antialiased
text rendering. Average changed pixels improved from 8.259991% to 8.136310%; six
states remain genuine visual mismatches and one remains a pass. Mean RGB delta
moved slightly from 5.827145% to 5.834648%, so the accepted change is explicitly
bounded to the stronger changed-pixel result rather than presented as universal
improvement.

The generated command inventory still reports zero actionable gaps. The visual
tail remains substantial: 141 paired dialog mismatch rows and 94 of 99 current
Word-baseline comparisons remain outside tolerance. `legal-notices` is the next
largest canonical dialog residual, followed by the classified font,
pagination, drawing/object, chart, table, and WordArt families.

## FreeP

Cached vertical-list SmartArt arrow geometry now uses the authored-compatible
adjustments accepted by the focused corpus. For
`15-smartart-grouped-list/slide-10`, WPF/Office improved from 2.5120% to 1.7356%
and Avalonia/Office from 2.3744% to 1.5956%; the renderer-pair metric moved only
from 1.6288% to 1.6302%.

Across the 53-slide PowerPoint corpus, current averages are 1.0447% WPF/Office,
1.0124% Avalonia/Office, and 0.6248% WPF/Avalonia. Generated command parity
remains 689/689, and all 61 app-owned paired visual scenarios remain local-gate
passes. Remaining high-value targets are Surface3D camera/mesh rendering and
the slide-09 SmartArt residual.

## Verification

- FreeX physical Docker/X11 lane: 2/2; Core.IO focused tests: 11/11; Avalonia
  source guards: 2/2; production Release build: zero warnings and errors.
- FreeW focused tests: 8/8; WPF and Avalonia comparison harness builds passed.
- FreeP focused tests: 41 presentation and 14 Avalonia tests; production build
  passed; slide-01 and `06-charts` controls remained byte-identical.
- Cross-app dashboard generation, generated-file check, and schema/evidence
  aggregation guards passed.
- Repository preflight passed, including generated documentation and all
  architecture/source guards. The exact integration tip built in Release with
  zero warnings and errors using serialized, non-shared compilation.
- Integration gating caught and corrected native hidden-row fallback ownership
  for unsupported AutoFilter metadata (20/20 focused R38/R65/R98 tests) and a
  private FreeP test workspace walker (6/6 shared-locator source guards).
- The complete default non-UI lane then cleared every product and architecture
  failure. Its only remaining failure is the established headless limitation
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`, where
  the render target produces an empty PNG without a graphical host; the
  containing Avalonia project reported 2,157 passes and one failure.

These metrics prove the named routes, workflows, artifacts, and comparison
results only. They do not establish pixel-level Microsoft Office equivalence.
