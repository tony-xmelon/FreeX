# Avalonia parity Wave 173: FreeX physical validation

Date: 2026-08-22

## Scope

This slice reconciles fresh Linux Docker/X11 evidence with the previously
committed FreeX split-pane authority and removes a harness hang discovered while
running the broad physical lane. No Avalonia product change is claimed because
the fresh failures did not isolate a product behavior defect.

## Evidence and authority

- The committed Wave104 report records the original split-pane pointer authority:
  four physical rows passed at 1280x820 and 96 DPI. That evidence was produced
  against the split-pane implementation introduced by `c740620ecb`.
- A fresh Wave173 `split-pane-pointer` run at the same 1280x820/96-DPI target
  produced 0/4. The screenshots show the View ribbon, but the current probe's
  fixed `(925,98)` click did not establish the Split postcondition. This is a
  contradictory harness result, not sufficient evidence to mark the Avalonia
  split-pane behavior regressed. It remains an explicit follow-up rather than a
  relabeled pass or failure.
- Fresh `grid-drag` evidence passed 3/3: autofill, selection-border move, and
  selection-border copy.
- Fresh `grid-autofit` evidence passed 3/3: column boundary, visible row
  boundary, and contiguous hidden-row boundary.
- Fresh `outline-nested-group` evidence failed 0/2 and
  `outline-nested-filter-save-reopen` failed 0/1. The screenshots and saved XLSX
  package show the expected visible collapse/expand and filter persistence, but
  the probe's clipboard readback returns concatenated visible slots after hidden
  rows/columns. Those assertions remain failures; this note does not reinterpret
  them as passes.
- The broad `all` lane stopped in ImageMagick's unbounded
  `connected-components` diagnostic during selection readback, before its
  manifest completed. This is the reproducible harness defect fixed in Wave173.

## Change

`run-freex-input-probes.sh` now bounds the selection-box ImageMagick diagnostic
with `FREEX_X11_IMAGE_TOOL_TIMEOUT_SECONDS` (default five seconds). A timeout
leaves the existing selection assertion false and lets the probe emit its normal
failure evidence instead of wedging the X11 session. No assertion or required
evidence row was weakened.

## Verification

- `grid-drag`: 3 passed, 0 failed.
- `grid-autofit`: 3 passed, 0 failed.
- `split-pane-pointer`: 0 passed, 4 failed; unresolved coordinate/harness
  contradiction against the Wave104 4/4 authority.
- `outline-nested-group`: 0 passed, 2 failed; honest readback failures retained.
- `outline-nested-filter-save-reopen`: 0 passed, 1 failed; honest readback
  failure retained, with package and screenshots recorded in the run artifacts.
- Source contract test added for the bounded ImageMagick diagnostic.

## Remaining

The next FreeX slice should reconcile the split command's current physical
coordinate/key-tip route against the Wave104 evidence, then replace the hidden
range clipboard readback with an address-aware physical readback while preserving
the exact row/column assertions. No new product defect was proven in this wave.
