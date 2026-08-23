# Avalonia Parity Wave 187 Integration

Date: 2026-08-23

Wave 187 processes one bounded slice per application and brings the cumulative
processed app-slice count to **561**. Two slices produced accepted visual
corrections. The FreeX slice produced blocker evidence only: its unexercised
product and harness changes were reverted, so numeric AutoFilter parity does
not advance in this wave. Generated command inventories continue to report
zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP.

## FreeX

The intended production Linux/X11 coverage was Number Filters -> Greater Than
and Equals, including visible rows, clean save, exact package state, and
production reopen. No run reached that acceptance boundary. One run clicked
the A/B boundary and produced a false menu-open signal; later runs either used
an invalid resume invocation or calibrated against the default workbook before
the numeric fixture became usable. The physical result schema also rejected
the new result ids before a final report could be written.

The direct `Border.PointerPressed` experiment and provisional numeric harness
were reverted because no valid B1 glyph run exercised them. Numeric criteria
remain **0/2 accepted**, classified as
`blocked-before-valid-fixture-run`, rather than as a product failure. The next
slice must repair deterministic fixture readiness and result-schema mapping,
then obtain one fresh 2/2 physical run before accepting a product-route change.

Focused verification before cleanup: Avalonia Release build passed with zero
warnings and errors; Core.IO `R38/R65/R98` passed **20/20**.

## FreeW

The Avalonia Legal Notices document host now reserves one additional trailing
pixel only for overflowing notice text, aligning long-state scrollbar/content
registration without changing the two short states. Fresh six-state paired
captures improved from **326,094** to **324,936** aggregate changed pixels:
all four overflowing states improved, both short states were unchanged, and
all six remain genuine visual mismatches at 620 x 600.

Focused verification: Avalonia visual/WPF-authority tests passed **32/32**;
both harness Release builds passed; WPF and Avalonia each captured **6/6**
states. The canonical inventory remains 512 scenarios, with 221 WPF captures,
291 Avalonia captures, 141 genuine mismatches, 80 passes, and 70 classified
Avalonia extensions.

## FreeP

The exact authored-camera Surface3D signature changes one shared facet vertex
from `(283,133)` to `(247,133)`. Direct deck25 evidence improves WPF/Office
from **2.7438%** to **2.7032%**, Avalonia/Office from **2.6220%** to
**2.5815%**, and WPF/Avalonia from **1.0805%** to **1.0804%**. Deck26 and four
ordinary-chart controls remain stable.

Focused verification: presentation tests passed **277/277**, Avalonia
rendering tests passed **285/285**, and the render-compare Release build passed.
The exploratory reconstructed-corpus estimates are diagnostic only. The
dashboard correctly retains the canonical Wave186 summary of 1.0447%
WPF/Office, 1.0124% Avalonia/Office, and 0.6248% WPF/Avalonia.

## Integration Gates

- Cross-app dashboard generation, check mode, schema validation, and evidence
  aggregation guards passed.
- Repository preflight passed, including generated-document checks and 13,615
  text files checked for conflict markers.
- The serialized full Release build passed with **0 warnings and 0 errors**.
- The default non-UI lane completed with one established headless limitation:
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`
  produced an empty PNG. `FreeX.App.Avalonia.Tests` otherwise passed
  **2,157/2,158**, and every other default-test project completed without a
  failure. This is the same environment-only residual recorded in Wave186 and
  is unrelated to the Wave187 changes.

## Remaining

- FreeX: repair physical fixture startup/calibration and result-schema mapping;
  obtain numeric criteria 2/2, then cover date, color, multi-column, and
  clear/reapply workflows.
- FreeW: continue the Legal Notices glyph/template raster tail or move through
  the remaining font, pagination, drawing/object, chart, table, and WordArt
  mismatch families.
- FreeP: exercise a genuinely new Surface3D topology or the slide-09
  SmartArt/text residual while preserving the renderer-pair metric.
