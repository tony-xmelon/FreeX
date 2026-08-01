# Avalonia parity Wave 94 integration

Date: 2026-08-01

## Integrated slices

- **FreeX review commands:** Avalonia now keeps an open threaded-comment list current after
  mutations and separates `Show Comments` from `Show Notes`. `Show Comments` lists threaded
  comments only, while `Show Notes` uses the WPF-authority toggle-all legacy-note workflow.
- **FreeX command metadata:** the new `Show Notes` route is included in the canonical Avalonia
  extra-command inventory.
- **Shared ribbon popups:** WPF now finds submenu popups through the applied visual tree when a
  template does not expose `PART_Popup`, preserving the shared placement callback and keyboard
  behavior.
- **WPF UI gate:** seven Name Box tests and two multi-window autosave tests now run through the
  existing STA authority. The affected subset improved from 1/10 to 10/10; a second static audit
  found no remaining plain-xUnit tests that construct live WPF controls outside an STA runner.
- **FreeW export:** the final branch incorporates the concurrent `origin/main` export series.
  Avalonia PDF/XPS output now retains page borders, watermarks, line numbers, inline drawing
  objects, paragraph and run surfaces, run lines, header/footer images, character borders, and
  super/subscript positioning and column rules with focused operation and raster evidence.
- **FreeW dialogs and Backstage:** Style, Legal Notices, Find/Replace, Page Setup, Backstage Open,
  and Backstage Save As received bounded WPF-authority alignment. Find/Replace also restores
  focus-and-select behavior when switching modes.
- **FreeW visual evidence:** all three Multilevel List states are now verified passes at 2.77% to
  2.92% changed pixels. The full dialog inventory was refreshed from 158 routes/466 scenarios to
  161 routes/475 scenarios without classifying the nine newly inventoried uncaptured states as
  passes.
- **FreeP pane lifecycle:** already-open Animation and Comments panes now rebind after file
  replacement and relevant slide changes, matching the WPF host lifecycle.
- **FreeP video export:** the final branch also incorporates host-capability-aware video export
  planning, keeping Avalonia and WPF command behavior aligned with the available encoder.
- **Generated evidence:** the cross-app dashboard and FreeP whole-window source fingerprint were
  refreshed. FreeW now records 16 visual passes and 167 genuine visual mismatches.

## Focused verification

- FreeX review/comment runtime and capture lane: **30/30 passed**.
- FreeP pane lifecycle regressions: Animation **1/1**; Comments plus planner **5/5**.
- FreeW focused lanes: Backstage **35/35**, Style and Legal Notices **8/8**, Find/Replace **3/3**,
  Page Setup/chrome **45/45**, Multilevel List **3/3**, and merged PDF export **32/32**.
- FreeP merged export-planning lanes: planner **73/73** and host lifecycle **19/19**.
- WPF STA subset: **10/10 passed**.
- Shared ribbon UI lane: **40/40 passed** (24 shared/Avalonia and 16 WPF).
- The all-up clipboard test failed once under suite interaction, then passed **3/3** independently
  and passed in the complete default rerun; no suppression or product change was made.

## Broad verification

- Repository preflight: **passed**, including all generated documentation and visual-evidence
  freshness gates.
- Full `Release` solution build: **0 warnings**, **0 errors** across 98 projects.
- Default test lane: **35,064 passed**, **133 skipped**, **0 failed**, **35,197 total** across 19
  assemblies.
- Broad `FreeX.UiTests.slnx` diagnostic: **5,882 passed**, **55 skipped**, **203 failed** across
  6,140 tests. Host failures improved from 208 to 199; UI failures remain 4. The nine-test
  reduction exactly matches the STA corrections. Remaining debt is source-guard, localization,
  layout/render expectation, and product-behavior convergence rather than missing STA setup.
- Serialized Linux family lanes: **85/85 passed**: FreeX **24/24**, FreeW **37/37**, and FreeP
  **24/24**. FreeW's **37/37** and FreeP's **24/24** lanes were rerun after the final concurrent
  merges.
- Dedicated FreeP multi-selection physical X11 lane: **9/9 passed**.
- Every Linux manifest contract passed and every harness-owned container stopped.

## Remaining depth

- FreeW retains 167 genuine visual comparison mismatches. The refreshed inventory also has nine
  Avalonia-owned states without committed capture evidence.
- FreeW PDF export still needs decorative art/wave-border fidelity and authoritative Word PDF
  baselines.
- FreeX Avalonia's threaded-comment list uses portable `ListBox` chrome rather than WPF's exact
  two-column `GridView` presentation.
- The broad WPF UI solution still has 203 actionable or stale failures and remains a diagnostic
  lane, not a release gate.
- Native toolkit text/control rasterization and authoritative Microsoft Office baselines remain
  outside the current managed evidence.

No machine-wide process termination or build-server shutdown was performed. One orphaned
Wave94-owned ribbon testhost and its `dotnet` parent were stopped after a wrapper timeout; both
process command lines were verified to belong to this integration worktree. Unrelated review and
build sessions were not touched.
