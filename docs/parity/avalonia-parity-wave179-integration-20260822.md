# Avalonia Parity Wave179 Integration

Date: 2026-08-22
Base revision: `22b5fcefd57bb9fd2c4c7d53ae390b0aecd4934c`
Final revision before this note: `3626c737457d2494e81db33e6c8f8b7587de30b2`

## Integrated slices

### FreeX

- Managed core, context-menu, dialog, and ribbon validation now select the
  Validation host explicitly; physical X11 validation continues to select the
  packaged Application host explicitly.
- The corrected managed ribbon lane passed `715/715` rows: `641` command rows
  and `74` collapsed-group rows. It does not replace the Wave178 physical X11
  authority, which remains `32/32` production Application-host rows.
- Integration exposed an unbounded source-contract scan that entered repo-local
  `.worktrees` and `.claude/worktrees`. The scanner now visits only the seven
  authoritative C# source roots and has a regression test preventing generated
  or scratch-tree traversal.
- The scanner tests passed `2/2`. The complete Avalonia project then completed
  with `2150` passes and the one known Windows headless-renderer failure described
  below; the prior inactivity abort no longer occurs.

### FreeW

- The four long-document Legal Notices states now opt into grayscale antialiasing
  through a renderer-neutral presentation policy implemented by the shared
  Avalonia Legal Notices renderer. The FreeW app wrapper remains thin.
- Changed-pixel ratios improved in every state: `18.9164% -> 18.2040%`,
  `16.6406% -> 15.8863%`, `17.9546% -> 17.1739%`, and
  `17.9161% -> 17.1532%`.
- All four rows remain honest `genuine-visual-mismatch` rows because native WPF
  and Skia typography, tab, scrollbar, and focus pixels still differ.
- Shared ownership/presentation tests passed `6/6` and `2/2`; realized Avalonia
  Legal Notices tests passed `14/14`.
- Canonical evidence remains `291` rows: `141` genuine visual mismatches,
  `80` passes, and `70` Avalonia extensions.

### FreeP

- TTML caption opacity now survives inherited/inline parsing, decimal and
  percentage normalization, WPF/Avalonia playback rendering, authored TTML
  output, package round-trip, and reopened planner projection.
- Focused presentation tests passed `30/30`, WPF slideshow/media tests passed
  `38/38`, and Avalonia media tests passed `14/14`.
- Gate integration also removed an ordering-sensitive test hang. The export
  feedback test had opened a real modal WPF message box from a queued callback;
  it now uses the headless message seam and pumps the dispatcher explicitly.
  Focused tests passed `2/2`, and three Avalonia-then-host ordering runs passed.

## Repository gates

- Repository preflight passed, including generated documents, FreeP visual
  evidence, FreeW shell evidence, and FreeW canonical consistency.
- `dotnet build FreeX.slnx --configuration Release` passed from synchronized
  `main` with zero warnings and zero errors.
- In the final guarded default-solution run, every project outside
  `FreeX.App.Avalonia.Tests` completed green. FreeP Avalonia passed `719/719`
  immediately followed by FreeP host `2405/2405`, proving the fixed ordering.
- After the bounded source-scan fix, the complete `FreeX.App.Avalonia.Tests`
  project completed `2150` passing tests plus one known failure, with no hang.
- The known residual is
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`: the
  Windows headless renderer returns an empty PNG. The same machine-specific
  residual was recorded in Waves 175, 177, and 178 and is unrelated to the
  Wave179 changes.

## Honest residuals

- FreeX has no inventoried Avalonia-missing command or paired-dialog surface;
  deeper physical workflows and native renderer fidelity remain ongoing work.
- FreeW remains the largest measured visual backlog with `141` genuine visual
  mismatch rows. Many are framework rasterization residuals, but they remain
  classified honestly until route-level evidence justifies a pass.
- FreeP retains no command-routing gap. Remaining fidelity families include
  richer TTML style references/decorations, native media/device behavior,
  PowerPoint-authoritative SmartArt and 3-D rendering, and other native-host
  boundaries documented in the command inventory.

Wave179 advances all three applications and stabilizes the default evidence lane;
it does not declare whole-product pixel parity.
