# Avalonia Parity Wave 165 Integration

Date: 2026-08-06

## FreeX hidden-row AutoFit slice

The Avalonia row-header parent and overlay handle now share the resolved target
for a boundary immediately before a contiguous hidden run. A collapsed-boundary
press may begin resize capture so manual drag-to-unhide remains available, but a
sub-threshold release is restored and released without a command; the second
press can therefore reach the real contiguous AutoFit path for rows `4:5`. The
deterministic host coverage pins the planner range and this click-versus-drag
behavior.

The physical probe retains its strict schema-v2 contract. Its B5 follow-up now
uses the calibrated handle inset when translating the outlined B4 height into
the next row's selection origin. This corrects the measured selection-outline
geometry; it does not relax any positive-height, unhidden, or selector-count
assertion.

## Bounded physical evidence

All sessions used the production Avalonia desktop at 1280x820 and 96 DPI. No
session produced an authoritative focused `3 passed, 0 failed` result, so Wave
165 does **not** claim physical selector closure.

The two resumed attempts were bounded as follows:

- `20260806T024559831Z`: calibration passed; column `70 -> 70`, visible row
  `26 -> 26`; hidden rows reached `66,66`, `hiddenRowsAfter=[]`,
  `unhidden=true`, and `sized=true`. Strict selector result: `0/3`.
- `20260806T025241981Z`: interrupted before manifest completion; its retained
  postcondition also recorded hidden rows `66,66` and `hiddenRowsAfter=[]`,
  while column and visible row remained `70 -> 70` and `26 -> 26`. It is not
  credited as a selector result.

Earlier retained attempts show the same bounded input-injection residual: the
calibrated column and visible-row double-clicks intermittently did not trigger
growth, while the corrected hidden-row interaction reached both positive row
heights. The remaining failure is flaky X11 input injection for the column and
visible-row cases, not evidence to weaken the gate around hidden rows.

## Focused verification

- `FreeX.App.Avalonia.Tests`: 25/25 passed, including the row-header source and
  hidden-boundary AutoFit regressions.
- `FreeX.App.Presentation.Tests`: 18/18 passed, including the shared drag
  threshold and collapsed-boundary positive-size planner coverage.
- `FreeX.App.Services.Tests`: 13/13 passed, including the strict selector/tool
  contract and corrected B5 geometry assertion.
- `git diff --check`: passed.

## Review correction

The initial Wave165 implementation consumed the first press whenever the
resolved target differed from the visible row or its displayed height was zero.
That preserved the double-click path but incorrectly blocked manual drag-to-
unhide/resize. The follow-up correction restores `BeginHeaderResize` for every
boundary, including collapsed runs, and applies the shared four-pixel movement
threshold during preview and commit. A sub-threshold click now restores,
detaches, and releases without a command or `RefreshShell`; a positive drag
still commits its requested height. No physical X11 rerun was used for this
review correction.

## Honest residual

Physical hidden-row AutoFit now has genuine retained evidence of rows `4:5`
becoming positive `66,66` and unhidden through the user interaction. The strict
focused selector remains open because the bounded X11 runs did not obtain
column growth and visible-row growth in the same authoritative manifest. No
`3 passed, 0 failed` selector closure is claimed in this wave.

## FreeW Cross Reference dialog

Avalonia now uses the WPF-authoritative three-list layout and modal validation
contract rather than platform-local combo boxes and an inline status row. Fresh
560x600, 96 DPI captures improved all three canonical states from
`9.5050595%` changed pixels / `5.7631349` mean channel delta to
`6.1699405%` / `4.8313780`. The states remain genuine visual mismatches because
native list templates, scrollbar edges, and text rasterization differ; no
threshold, crop, mask, or fixture was changed.

Integrated Cross Reference verification passed 3/3 Avalonia dialog tests,
70/70 shared model tests, 11/11 WPF host tests, and 11/11 core IO tests. The
larger counts include the caption-reference work merged concurrently from
`origin/main`.

## FreeP Zoom reflection blur

Zoom frame reflection blur is now authorable through WPF and Avalonia and
projected through a shared renderer-neutral blur-pass plan consumed by both
renderers. The existing model, undo command, and native DrawingML writer remain
the package authority; `a:reflection/@blurRad="12700"` survives undo/redo and
PPTX reopen while unsupported native payload remains preserved.

Integrated Zoom/reflection verification passed 132/132 presentation tests,
15/15 WPF host/package tests, and 6/6 Avalonia tests. PowerPoint-authoritative
pixel fidelity for the bounded halo approximation and other unsupported Zoom
effect families remain outside this slice.

## Integration gate

- Repository preflight passed after regenerating the two expected FreeP
  whole-window MainWindow source hashes made stale by concurrent media work.
- FreeP whole-window evidence is current at 33/33 paired captures with zero
  explicit product mismatches or capture limitations.
- FreeW evidence consistency is current at 295 rows: 159 genuine visual
  mismatches, 24 passes, 105 Avalonia extensions, and 7 not-applicable rows.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and
  0 errors.

Wave 165 advances three bounded parity surfaces. It does not claim complete
functional or visual parity for FreeX, FreeW, or FreeP.
