# Avalonia Parity Wave 164 Integration

Date: 2026-08-06

## Integrated slices

- **FreeX physical row AutoFit:** Avalonia row-header resize handles now map
  the visible boundary before a hidden run through the shared
  `GridResizePreviewPlanner`. A generated XLSX fixture and schema-v2 physical
  selector retain real column and visible-row measurements at 1280x820, 96 DPI.
- **FreeW Backstage Home:** Avalonia compensates the Fluent Home action-row
  footprint by one DIP while preserving the shared WPF authority metrics,
  action order, callbacks, and content. Fresh paired evidence improved from
  9.1386905% changed pixels / 6.19348115 mean delta to 6.5208333% /
  2.83760218. No threshold or classification changed.
- **FreeP relationship SmartArt:** the imported `relationship1` grammar now
  admits source-backed two-node caches alongside the existing three-node form.
  Admission requires flat ordered ellipses, exact text, equal square extents,
  the shared 0.58 overlap step, and no extra roles or unsupported effects.
  Drawing-cache regeneration now serializes ellipse geometry explicitly.

## Linux evidence

FreeX session `20260806T011033482Z` ran the production Avalonia desktop at
1280x820 and 96 DPI:

- column A: 70 -> 396 pixels at boundary `(88,226)`;
- visible row 2: 26 -> 66 pixels at boundary `(14,272)`;
- hidden rows 4:5: observed `66,0`, so the physical contiguous hidden-band
  result remains failed and is retained only as a diagnostic.

The focused physical result is 2 passed and 1 failed. The schema requires the
column and visible-row growth; it does not turn the hidden-band diagnostic into
a pass.

## Focused verification

- FreeX Avalonia AutoFit/input: 24/24; Linux runner/schema tooling: 13/13.
- FreeW Backstage: 40/40. Canonical evidence consistency passed with 295 rows,
  159 genuine mismatches, 24 passes, 105 Avalonia extensions, and 7 N/A rows.
- FreeP SmartArt: shared Presentation 401/401, WPF host/package 316/316,
  Avalonia renderer 12/12, and Avalonia host 33/33.
- All focused commands passed again after merging the latest `origin/main`,
  including Round 121, FreeP ChartEx, and FreeW bibliography changes.
- Repository preflight passed, including generated parity documents, packaging,
  workflow, source-fingerprint, and conflict-marker guards.
- The complete `FreeX.slnx` Release build passed with 0 warnings and 0 errors,
  and passed again after the final upstream SmartArt/FreeW sync.
  The default solution wrapper was not repeated because the same unchanged
  wrapper timed out and left a testhost in Wave 163; this wave uses the complete
  touched cohorts above plus preflight and the full solution build.

## Honest residuals

- FreeX physical contiguous hidden-row reopening remains unstable. The shared
  planner and deterministic host test cover rows 4:5, but the latest real X11
  probe only reopened/sized row 4.
- FreeW Backstage Home remains a genuine visual mismatch because native text
  rasterization and scrollbar templates differ. The canonical mismatch count
  therefore remains 159.
- FreeP relationship caches outside the exact two/three-node grammar remain
  preserved verbatim: malformed hierarchy, missing/reordered text, extra roles,
  wrong geometry or overlap, effects, pictures, and other relationship-family
  caches are not speculatively promoted.
- These slices advance the wider parity objective; they do not establish
  complete functional or visual parity for all three applications.
