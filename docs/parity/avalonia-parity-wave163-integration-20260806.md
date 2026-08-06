# Avalonia Parity Wave 163 Integration

Date: 2026-08-06

## Integrated slices

- **FreeX physical AutoFit and hidden boundaries:** Avalonia now gives a resize
  handle's second pointer press AutoFit precedence before beginning a resize,
  matching WPF. Both hosts use the shared resize-range planner for AutoFit, so a
  contiguous hidden row or column band is unhidden and sized together, while an
  ordinary partial cell selection no longer becomes a whole-row or whole-column
  resize band.
- **FreeW Table Properties:** Avalonia's Table Properties checkbox geometry and
  Cell-tab positioning inset now follow the WPF authority. The focused
  `table-properties.tab-cell` changed-pixel ratio moved from 11.4702% to 11.3622%
  and mean channel delta from 7.6023 to 7.5789. The already-passing Column tab
  remains classified as a pass.
- **FreeP packaged OLE activation:** slide and inline packaged-file objects now
  resolve a shared sanitized activation plan. Windows shell launch and macOS
  `open -W` retain tracked edit-back; Linux uses a detached `xdg-open` handoff,
  retains the payload for ten minutes, performs no false edit-back claim, and
  cleans stale sessions on later activation. Executable and script payload
  extensions are rejected before extraction or launch. Native in-place OLE
  remains the existing Windows-only path.

## Linux evidence

The new focused FreeX `grid-autofit` X11 selector ran the production Avalonia
desktop in the Ubuntu Docker harness at 1280x820 and 96 DPI. A real X11
double-click on the first column boundary widened the seeded column from 70 to
396 pixels. The schema-v2 manifest reports 1 passed, 0 failed, with retained
before/after screenshots and a text postcondition.

## Focused verification

- FreeX Avalonia AutoFit/input tests passed; shared resize planner: 9/9; WPF host
  Release build: 0 warnings and 0 errors.
- FreeW Table Properties: Avalonia 6/6, WPF 3/3; canonical evidence consistency
  passed with 295 rows, 159 genuine mismatches, 24 passes, 105 Avalonia
  extensions, and 7 not-applicable rows.
- FreeP packaged OLE: shared activation 20/20, Avalonia routing 2/2, WPF
  routing/host 8/8.
- The complete `FreeX.slnx` Release build passed with 0 warnings and 0 errors.
- Repository preflight validated JSON, XML, PowerShell tooling, workflow,
  project/solution wiring, macOS/Linux packaging, and generated documentation
  through the FreeP whole-window evidence gate. That gate initially found the
  expected stale host hashes from this wave; after regenerating the manifest,
  its focused check passed with 33/33 paired captures, 0 product mismatches, and
  zero capture limitations. A complete preflight retry and the default non-UI
  solution test wrapper each reached their 15-minute process bound without
  returning a result. Their exact Wave 163 child processes were reaped; no test
  assertion failure was reported.

## Honest residuals

- The physical X11 proof covers column-boundary AutoFit. Row-boundary AutoFit is
  covered by deterministic host/planner tests but does not yet have robust
  physical X11 geometry. The focused selector is additive and does not change the
  default exhaustive `all` selector counts.
- FreeW Table Properties remains a genuine visual mismatch. Native control and
  text rasterization, disabled-combo geometry, and the lower viewport still
  account for visible differences.
- Linux packaged-file OLE activation cannot reliably observe the lifetime of the
  application selected by `xdg-open`, so edit-back is intentionally not claimed
  there. Native COM/OLE server activation remains Windows-only.
- These slices advance the wider parity objective; they do not establish complete
  functional or visual parity for all three applications.
