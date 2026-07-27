# Avalonia parity Wave 31

Date: 2026-07-27

## Scope

Wave 31 advanced one focused visual or evidence slice in each app:

- FreeX Scenario Manager range pickers now wrap fields hosted by either a
  `StackPanel` or `Grid` while retaining Grid placement metadata.
- FreeW Font dialog now keeps the editable Size field at full width and
  consumes the Avalonia tab-content inset through shared compact-dialog chrome.
- FreeP Review Comments pane now follows the unchanged WPF authority layout,
  typography, spacing, and compact control geometry.

## Evidence

### FreeX

- Focused Avalonia source tests: 2/2 passed.
- Focused WPF capture guard: 1/1 passed.
- WPF Scenario Manager capture: 360x420 with all lower controls visible.
- A post-fix Linux recapture was not completed because its publish was
  interrupted. The prepared Docker image produced the earlier 360x420 Linux
  capture successfully; this remains an evidence limitation, not a parity-pass
  claim.

### FreeW

- Focused Font/shared-chrome tests: 33/33 passed on the integrated branch.
- Fresh captures: 5/5 WPF and 5/5 Avalonia at matching logical dimensions.
- The collapsed editable Size field and horizontal tab-pane inset are fixed.
- Advanced changed ratio improved from 15.919% to 15.844%, mean channel delta
  from 12.190 to 11.041, and p95 from 97.667 to 80.667.
- Correcting content width exposes more compared pixels in four states, so
  their changed ratios rise slightly. The dialog remains a genuine visual
  mismatch rather than a pixel-parity pass.

### FreeP

- Focused Review Comments pane test: 1/1 passed on the integrated branch.
- WPF evidence pixels and source implementation remain unchanged.
- Target mismatch improved from 18.91% / mean 15.40 to 16.23% / mean 14.10.
- Whole-shell mismatch improved from 29.63% / mean 23.03 to 11.42% / mean 8.81.
- Semantic dimensions, focus, buttons, enabled state, and nonblank gates pass.

## Integrated verification

- FreeX Avalonia, FreeX WPF, FreeW Avalonia, and FreeP Avalonia affected test
  projects built with zero warnings and zero errors.
- Repository preflight passed: JSON, XML, scripts, project/solution inventories,
  packaging, generated documentation, evidence manifests, and conflict markers.
- FreeP whole-window evidence remains current at 33/33 paired captures with
  zero explicit product mismatches and zero capture limitations.

The overall Avalonia parity goal remains active. These three slices improve
specific surfaces but do not establish whole-product functional or visual
parity.
