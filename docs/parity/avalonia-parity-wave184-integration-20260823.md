# Avalonia/WPF parity Wave 184 integration

Date: 2026-08-23

Wave 184 processed one bounded parity slice per application, bringing the
cumulative app-slice count to 552. Generated command/profile inventories still
show zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP.
The wave closes another real Linux workbook workflow and reduces two visual
residual families; it does not claim complete functional or visual parity.

## FreeX: Linux AutoFilter physical workflow

The Avalonia Alt+Down route now anchors the AutoFilter flyout to the live
rendered header button, with the selected-cell border retained only as a
fallback. The X11 probe also fails closed when no flyout is visible before it
clicks a checklist item.

The exact final Docker selector passed 1/1 through open, apply, change, and
clear. Its dependent `SUBTOTAL(109,...)` postconditions were `30 -> 10 -> 20
-> 30`. Production Name Box evidence remains 1/1 visual and 8/8 interaction.

## FreeW: Table Properties Cell tab

The Avalonia Table Properties tab viewport now clips at the action-row
boundary and preserves the measured WPF spacing below the disabled overlap
row. The focused `table-properties.tab-cell` comparison improved from 41,127
to 40,659 changed pixels, or 12.240179% to 12.100893%; mean channel delta
improved from 7.7785923 to 7.6741369. The row remains honestly classified as a
genuine visual mismatch.

## FreeP: cached SmartArt matrix roles

The shared cached-SmartArt path now preserves native `lProcess2` group
containers and `matrix2` axes, including shared `quadArrow` geometry. On
`15-smartart-grouped-list`, slide 06 dropped from 4.2659% to 1.5481% for WPF
and 4.2721% to 1.5581% for Avalonia versus PowerPoint. Slide 08 dropped from
3.2298% to 1.1608% and 3.1952% to 1.1313%. Both WPF/Avalonia pair deltas also
improved.

Across all 53 tracked slides, WPF/PowerPoint now averages 1.0593%,
Avalonia/PowerPoint 1.0360%, and WPF/Avalonia 0.6283%. The respective maxima
are 3.0587%, 3.0055%, and 3.0952%.

## Verification

- Repository preflight passed: 270 JSON files, 305 XML-backed files, generated
  parity documents, and 13,598 text files in the conflict-marker scan.
- The Release solution build passed with zero warnings and errors.
- Focused lanes passed: 20 FreeX AutoFilter tests plus the 1/1 physical
  selector; 7 FreeW Avalonia and 4 WPF Table Properties tests; 1 FreeP cached
  role test, 216 SmartArt layout tests, and 60 shared drawing tests.
- The integrated default non-UI lane initially exposed one test-seam ownership
  regression, which was moved behind the existing optional-instrumentation
  boundary. Its focused guard passed, and the complete FreeX Avalonia rerun
  finished with 2,155 passed and one failure among 2,156 tests.
- That remaining failure is
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`; this
  Windows headless environment emits an empty PNG, matching the pre-existing
  Waves 182-183 limitation. No threshold or assertion was weakened.
- The cross-app dashboard generator check and aggregation guards passed.

## Remaining scope

Functional inventory routing remains complete for the generated inputs.
Continue FreeX physical coverage with broader AutoFilter criteria, sort,
color, or persistence; continue FreeW with the next classified Word/dialog
residual; and continue FreeP with the remaining high-value text, SmartArt,
chart, and 3-D corpus residuals while preserving pair parity.
