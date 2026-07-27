# Avalonia parity Wave 23

Date: 2026-07-27

Wave 23 advanced one bounded parity slice in each app and refreshed the
repository-wide generated evidence.

## FreeX

- Aligned the Avalonia Options General page with WPF geometry, content, and
  editable state.
- Added Collapse Ribbon state projection through the shared options planner.
- Corrected the editable font-size field so the full `11` value renders.
- Refreshed both `dialog.Options` and `dialog.Options.General` Linux captures.
- Reduced the paired Options General triage score from `0.111494` to
  `0.032147`.
- The next FreeX visual outlier is `dialog.SortOptions` at `0.110625`.

## FreeW

- Aligned the Avalonia Style dialog field widths, labels, focus states, and
  compact control chrome with the WPF authority.
- Added exact WPF/Avalonia Style harness states for initial, populated, and
  validation-error captures.
- Reduced changed-pixel ratios:
  - `style.initial`: `0.184939` to `0.160613`
  - `style.populated`: `0.186767` to `0.162677`
  - `style.validation-error`: `0.186982` to `0.160613`
- The three states remain honestly classified as genuine visual mismatches.
  The current all-dialog report still contains 171 mismatch states, 12 passes,
  4 not-applicable states, and 96 Avalonia extensions.

## FreeP

- Added shared Grow/Shrink amount choices for 25%, 50%, 150%, and 400%.
- Modeled and round-tripped the PresentationML `p:animScale` behavior instead
  of encoding amount in `presetSubtype`.
- Preserved authored `from`, `to`, `by`, X/Y, and custom tokens through clone,
  undo, read, and write paths.
- Routed the shared scale plan through both WPF and Avalonia animation panes
  and slideshow hosts.
- Added direct tests for the four Office-valid value combinations:
  `from_to`, `from_by`, `to_only`, and `by_only`.
- Imported asymmetric custom X/Y scale values are retained; exact asymmetric
  slideshow playback remains a follow-up because the current host plan has one
  scale track.

## Verification

- FreeX Options planner: 34 passed.
- FreeX Avalonia Options parity guards: 4 passed.
- FreeW Style/shared chrome focused lane: 13 passed.
- FreeP animation planner, IO, and playback lane: 202 passed.
- FreeP WPF host lane: 19 passed.
- FreeP Avalonia focused lane: 3 passed in the independent integration filter.
- FreeP round-trip review lane, including the four valid scale combinations:
  24 passed.
- Repository preflight passed, including generated-document checks,
  122 project references, all three solutions, macOS readiness, Linux
  packaging, and conflict-marker validation.
- Generated FreeP evidence is current at 28/28 dialog/pane passes and 33/33
  paired whole-window scenarios.

## Generated state

- FreeX: 531 functional commands, 0 actionable Avalonia gaps, 57/57 dialog
  routes, and 94 paired screenshot surfaces.
- FreeW: 870 commands and 0 actionable command gaps.
- FreeP: 346 commands, 344 shared, 2 platform-only, and 0 actionable command
  gaps.
