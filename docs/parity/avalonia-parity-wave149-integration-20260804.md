# Avalonia parity Wave 149 integration

Date: 2026-08-04

Final upstream base before the final remote check: `40016cec15`.

## Accepted slices

- FreeX Avalonia now treats a single selected cell as a valid Print/Export
  selection, matching the WPF `SelectedRange is not null` contract instead of
  exposing Selected Range only for multi-cell ranges.
- FreeW Avalonia Print Layout now applies Center and Bottom page vertical
  alignment to body text, tables, inline images, drawings, caret geometry,
  selection/hit targets, and wrap geometry while leaving headers, footers,
  notes, and continuous views anchored to their existing regions.
- FreeP WPF and Avalonia now offer an explicit atomic "Apply format to all
  Summary Zoom tiles" scope while retaining per-tile editing as the default.
- Shared WPF and Avalonia backstage frames now consume one neutral rail
  contract for navigation padding, typography, icon size, icon-label spacing,
  back-button metrics, and top-navigation margin.

## Integration review

The FreeW slice was returned before acceptance because image-only paragraphs
were shifted without contributing their image height to the page's used body
extent. The follow-up includes inline image rectangles in free-space
measurement and proves both true-bottom calculation and matching rect shift.
Its focused tests also no longer swallow headless-session exceptions.

The concurrent upstream merge added FreeP Zoom frame geometry and FreeW WPF
floating-table placement. Integration found two Zoom regressions that narrow
tests had not exposed: the expanded WPF dialog declared too few grid rows, and
the package reader projected native default `rect` geometry as an explicit
model override. The final integration gives every control a distinct row and
normalizes only the native rectangle default back to null; authored
`roundRect` and `ellipse` remain explicit and editable.

## Evidence boundary

FreeW vertical alignment uses the current document-level page geometry. Full
per-section metrics and Word's Justified paragraph-spacing distribution remain
separate. The shared backstage contract removes duplicated renderer constants
but does not claim identical native templates, focus visuals, font
rasterization, DPI, or compositor output. FreeP still lacks PowerPoint-native
preview bitmap generation, and FreeX native printer-properties UI remains a
platform workflow boundary.

## Verification

The combined initial focused lane passed `83/83` tests:

- FreeX selection gate and export/print planners: `3/3` and `10/10`.
- FreeW Avalonia vertical layout and shared planner: `3/3` and `5/5`.
- Shared Avalonia backstage contract: `3/3`.
- FreeP WPF, Avalonia, and shared Zoom lanes: `4/4`, `4/4`, and `51/51`.

After the concurrent-merge repair, the complete Zoom round-trip class passed
`33/33`, the shared Zoom planner lane passed `51/51`, and the complete affected
FreeP WPF host assembly passed `2,043/2,043`.

The serialized default lane initially exposed four default-rectangle Zoom
round-trip failures in that host assembly. Substituting the complete green
affected-assembly rerun gives current-source default evidence of `36,451`
passed across `21` assemblies, `134` benchmark or explicit skips, and zero
failures.

Repository preflight passed over `220` JSON files, `261` XML-backed files,
`90` PowerShell scripts, `125` .NET projects, `92` solution entries, `22`
default-test entries, and `11,062` text files. FreeP whole-window evidence
remained `33/33` paired after regenerating its `173`-artifact manifest. The
full `Release` solution build completed with zero warnings and zero errors.
