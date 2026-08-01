# Avalonia parity Wave 97 integration

Date: 2026-08-01

## Integrated slices

- **FreeX physical column Group/Outline:** the Linux X11 harness now selects B:D through the
  production column-header drag path, invokes Group from the shared column context menu, verifies
  the rendered horizontal outline bracket, physically collapses and expands the group, and reads
  all seeded values back through layout-independent keyboard navigation. The focused
  `outline-group` selector and the default physical lane both require the column probe alongside
  the existing row probe.
- **FreeW Style dialog:** WPF and Avalonia now consume shared compact metrics for dialog margins,
  field spacing, Name editor height, and action-row spacing. Initial, populated, and
  validation-error captures were refreshed by the implementation worker.
- **FreeP OMML paragraph binary breaks:** the shared parser and renderer-neutral math model now
  preserve `m:brkBin` (`before`, `after`, and `repeat`) and `m:brkBinSub` (`--`, `+-`, and `-+`).
  Width-aware shared layout applies the policy before the common WPF/Avalonia render planner.
- **Concurrent mainline work:** the integration branch includes incoming FreeW manual-hyphenation
  and nested grouped-shape formatting plus FreeP SmartArt relationship repair and motion-path
  editing. The FreeP whole-window source fingerprint was regenerated after that sync.

## Verification

- FreeX interaction source contract: **9/9 passed**.
- FreeX focused physical row and column Group/Outline route: **2/2 passed**. The column
  postcondition proved the rendered outline, collapse and expand screen changes, and exact
  restoration of `OutlineColumn2`, `OutlineColumn3`, and `OutlineColumn4`.
- FreeW Style dialog: presentation **5/5** and focused Avalonia dialog/source coverage **11/11**
  passed; three route-state captures completed.
- FreeP math: shared presentation **254/254**, Avalonia renderer **41/41**, and WPF renderer
  **40/40** passed.
- Repository preflight: **passed** after refreshing the incoming FreeP whole-window fingerprint.
- Full serialized Release solution build: **0 warnings**, **0 errors**.
- Serialized `FreeX.DefaultTests.slnx`: all **20 assemblies passed with 0 failures**. Intentional
  benchmark/platform skips remain skips.

## Remaining depth

- FreeX physical Group/Outline still lacks nested-group, filtered-range, save/reopen, and paired
  WPF screenshot evidence. Wave 96's complete family physical baselines remain the broad baseline;
  Wave 97 reran the changed focused route.
- The canonical FreeW all-dialog bundle still retains its previously generated mismatch queue
  until a complete bundle refresh. Native text rasterization remains a Style-dialog pixel residual.
- FreeP binary-break support is shared structural and render-plan evidence. Exact PowerPoint
  line-breaking heuristics, universal text-frame width propagation, and PowerPoint-authoritative
  raster baselines remain open.

No machine-wide process termination or build-server shutdown was performed. Docker execution was
serialized on port 6097, and only the Wave 97 container, app image, publish payload, worktree, and
branch are in the cleanup scope.
