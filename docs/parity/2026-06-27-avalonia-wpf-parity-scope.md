# Avalonia vs WPF Parity Scope - Updated 2026-07-01

## Purpose

This document tracks the repo-wide WPF vs Avalonia parity program across:

- FreeX - spreadsheet app.
- FreeW - word-processing app.
- FreeP - presentation app.
- Shared infrastructure, render/capture tools, generated evidence, and guardrails.

The target is 100% practical parity: shared policy where the platforms should behave the same, explicit platform-specific adapters where the UI stack requires them, and current evidence for any claim of visual or functional parity.

This update replaces the 2026-06-27 pre-dedup snapshot. The extensive dedup session has landed many items that were previously blockers; the remaining work is now mostly evidence, command-depth, renderer-edge fidelity, and app-specific workflow completion.

## Current Evidence

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- Audit worktree: `.worktrees/avalonia-wpf-parity-report-refresh-20260701`.
- `main` was clean and synced with `origin/main` at `11495483a` during this update.
- `AGENTS.md` requires isolated worktrees, no implementation in `main`, frequent sync, subagents for independent work, and merge/push/cleanup after completed slices.
- This report was produced from four read-only subagent audits plus local orchestration inspection. The only intended edit in this slice is this report.

## Worktree State

Several worktrees from the 2026-06-27 parity/dedup wave still exist locally, but their branches are merged into `main` and are not blockers. The old FreeP worktrees are cleanup candidates, not active owners:

- `.worktrees/freep-wpf-pptx-lifecycle-20260627`
- `.worktrees/freep-pptx-package-retention-20260627`
- `.worktrees/freep-render-harness-trust-20260627`
- `.worktrees/freep-avalonia-command-surface-20260627`
- `.worktrees/freep-parity-*`

The detached `dedup-visual-*` worktrees look like visual baseline snapshots.

Currently active or dirty lanes to coordinate with:

| Worktree/branch | Current status | Coordination note |
| --- | --- | --- |
| `FreeX-linux` / `codex/linux-port-20260616` | Dirty broad FreeW/Linux lane with many FreeW app, IO, model, dialog, packaging, and PDF changes. | Inspect before making final FreeW/Linux claims or touching overlapping FreeW Avalonia files. |
| `.worktrees/tester-release-20260627-r1` / `codex/daily-tester-release-20260627-r1` | Dirty tester-release lane touching workflow and generated FreeX parity artifacts. | Avoid staging its generated artifact state into unrelated report work. |

## Shared Spine Now In Place

The high-leverage pattern is established: neutral model/planner/policy plus thin WPF/Avalonia realizers.

Current shared infrastructure:

- `shared/Free.Shared.AppServices`
- `shared/Free.Shared.AppServices.Windows`
- `shared/Free.Shared.Commands`
- `shared/Free.Shared.Drawing`
- `shared/Free.Shared.IO`
- `shared/Free.Shared.Localization`
- `shared/Free.Shared.Opc`
- `shared/Free.Shared.Pdf`
- `shared/Free.Shared.Pdf.Skia`
- `shared/Free.Shared.Pdf.Wpf`
- `shared/Free.Shared.Ribbon`
- `shared/Free.Shared.Ribbon.Avalonia`
- `shared/Free.Shared.Ribbon.Wpf`
- `shared/Free.Shared.Shell`
- `shared/Free.Shared.Shell.Avalonia`
- `shared/Free.Shared.Shell.Wpf`
- `shared/Free.Shared.Theme`
- `shared/Free.Shared.Theme.Avalonia`
- `shared/Free.Shared.Theme.Wpf`
- `tests/SharedTestInfrastructure`
- `tools/FreeX.ToolsShared`
- `tools/FreeX.ToolsShared.Wpf`

Dedup items that were blockers in the prior report are now landed or intentionally closed:

- Shared Avalonia shell frame for sister apps: `shared/Free.Shared.Shell.Avalonia`.
- Shared drawing migration: `shared/Free.Shared.Drawing` owns shape geometry, shape kinds, DrawingML units/color/theme/preset helpers, and interaction planners.
- Shared ribbon policy/rendering spine: `shared/Free.Shared.Ribbon`, `.Wpf`, `.Avalonia`.
- Shared OPC/docprops substrate: `shared/Free.Shared.Opc`.
- Shared Avalonia file picker/workflow services.
- FreeP `.pptx` lifecycle, PPTX package snapshot/retention, and render-harness pixel-diversity trust checks.
- FreeX tooling helper dedup for value comparison, WPF image diff, side-by-side PNG, Excel COM helpers, and filename sanitizing.

## FreeX Status

### Covered

- Ribbon definitions and command registry are heavily shared through `src/FreeX.Ribbon.Definitions`, `shared/Free.Shared.Ribbon`, `shared/Free.Shared.Ribbon.Wpf`, and `shared/Free.Shared.Ribbon.Avalonia`.
- Command-binding parity remains strong:
  - `docs/parity/functional-parity.json`
  - `docs/parity/functional-parity.md`
  - Current snapshot: 531 commands, 473 parity, 0 Avalonia-missing, 48 WPF-missing, 10 both-missing.
  - Avalonia-missing commands and intentional Linux omissions are currently zero in the generated matrix.
- Dialog route inventory is generated and current:
  - 57 total routes.
  - 57 WPF captures.
  - 57 committed Avalonia captures.
  - 57 Avalonia harness routes.
  - 57 shared-or-presentation-backed routes.
  - `docs/parity/dialog-visual-evidence-summary.md` compares the committed WPF/Avalonia capture manifests: 15 WPF manifest surfaces all have Avalonia pairs, and Avalonia carries 78 additional captured variant surfaces.
- Much of the spreadsheet behavior now flows through shared or presentation planners:
  - Workbook lifecycle/open target: `src/FreeX.App.Services/WorkbookFileLifecycleCoordinator.cs`, `WorkbookOpenTargetPlanner.cs`.
  - Viewport/scroll planning: `src/FreeX.App.Services/WorkbookViewportScrollPlanner.cs`.
  - Backstage projection: `src/FreeX.App.Presentation/Backstage`.
  - Print render planning: `src/FreeX.App.Presentation/PageLayout/WorksheetPrintRenderPlanner.cs`.
  - Drawing and selection-pane policy: `src/FreeX.App.Presentation/DrawingUI`, `shared/Free.Shared.Drawing`.
  - Status bar and file workflow services: `shared/Free.Shared.AppServices`.

### Main Gaps

1. Dialog route evidence is no longer the leading inventory gap: the generated inventory is 57/57 for WPF captures, Avalonia captures, Avalonia harness routes, and shared/presentation-backed routes. Remaining work is qualitative visual review, foreground workflow proof, and pixel/interaction diffs rather than missing route assets.
2. Shell, backstage, and print/export are partly deduped at the policy layer but still have host-local renderer edges:
   - WPF keeps `MainWindow.xaml`, `PrintRenderer*`, and native `PrintDialog` behavior.
   - Avalonia keeps substantial `MainWindow.cs`, custom print/preview, Skia/PDF, and capture glue.
3. Keyboard routing remains split:
   - WPF: `src/FreeX.App.Host/KeyboardShortcutMatcher*.cs`.
   - Avalonia: `NativeMenuCatalog` plus local key handling.
4. Contextual chart/table/pivot/drawing commands have strong command binding coverage, but still need workflow evidence across WPF and Avalonia.

### FreeX Next Slices

1. Review the paired WPF/Avalonia dialog assets for qualitative visual diffs and record any concrete follow-up bugs.
2. Consolidate keyboard shortcut matching into a portable service and gate both hosts from one matrix.
3. Add print/export/render parity evidence around drawing/chart content and native print/export affordances.
4. Continue renderer-edge shell/backstage polish only after capture evidence identifies concrete diffs.

## FreeW Status

### Covered

- The shared project spine is now explicit in both WPF and Avalonia hosts:
  - `freew/FreeW.Core.Model`
  - `freew/FreeW.Core.IO`
  - `freew/FreeW.App.Presentation`
  - `freew/FreeW.Ribbon.Definitions`
  - `Free.Shared.*`
- Ribbon definitions are capability-profiled through `freew/FreeW.Ribbon.Definitions`; tests assert WPF/Avalonia tabs, contextual keys, and allowed command deltas.
- Avalonia ribbon construction delegates to the shared definition layer, with structured registry wiring in `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs`.
- The generated FreeW WPF/Avalonia command inventory is now present:
  - `docs/parity/freew-command-inventory.json`
  - `docs/parity/freew-command-inventory.md`
  - Current snapshot: 798 total commands, 0 actionable WPF gaps, 0 actionable Avalonia gaps, and 0 total actionable gaps. Raw WPF-only/Avalonia-only rows are profile-shape, alias, deferred, or platform-specific unless the generated classification says otherwise.
- Avalonia Options now uses shared option section/choice planning and a WPF-like grouped dialog surface instead of the earlier compact placeholder shape.
- Avalonia Backstage Info safety actions are now backed by shared planners and thin callbacks, and Backstage Print uses a shared direct-print capability/status policy.
- Review > Thesaurus now has shared presentation planning for lookup, selection, and replacement intent. Avalonia supports synonym Replace over that shared plan, while WPF keeps the fuller Insert/Copy pane actions.
- View > Side to Side now has read-only page-pair navigation in the shared paginated preview path; editable horizontal page view remains deferred.
- Recent dedup work moved shared behavior into planners/services:
  - `DocumentViewLayoutPlanner`
  - `BackstagePaneSurfacePlanner`
  - `DocumentPersistenceWorkflow`
  - dialog chrome
  - editor status planning
  - floating-object layout and z-order
  - color normalization boundaries

### Main Gaps

1. Command-count chasing is exhausted for the generated WPF/Avalonia matrix; new FreeW work should start from behavior, evidence, or renderer gaps rather than raw one-sided rows.
2. The FreeW inventory is a profile-surface inventory, not a behavior-completeness proof. Keep classification current when commands move, but do not treat classified profile-shape/platform-only rows as implementation targets.
3. Remaining behavior/evidence work should focus on Word-like results that are weakly proven, especially proofing/protection depth, source/cross-reference workflows, rich rendering, and visual evidence.
4. Avalonia Backstage Options and Info safety are now wired through shared planners. The remaining Backstage print limitation is direct native printer selection: WPF is host-backed through `PrintDialog`, while Avalonia exposes Print Preview and Create PDF because the current Avalonia target has no native printer dialog/service API.
5. Print/export parity is incomplete. Avalonia PDF export and preview fallback are backed, but direct native print remains deferred and renderer-fidelity evidence still needs broader print-pipeline coverage.
6. Rich rendering is improving, but SmartArt and other DrawingML-heavy surfaces are still simplified compared with WPF/Word.
7. Split and page-preview modes are backed as read-only snapshots, and Side-to-Side page-pair navigation is implemented for that read-only path. True dual-live split editing, editable responsive multi-page grids, and editable horizontal Side-to-Side page view remain deferred.
8. Full MS Word visual parity is not proven locally. Real Word PNG comparison remains limited by Word COM availability on this machine, so no-Word fallback evidence must not be read as an authoritative Word visual match.

### FreeW Next Slices

1. Keep the generated FreeW command inventory current as command slices move, but use it as a guard rather than a command-count backlog.
2. Reconcile or land the active `FreeX-linux` FreeW work before duplicating effort in the same files.
3. Continue the Avalonia Backstage print lane by adding real native print only if the target exposes a printer API; otherwise keep the shared capability/status policy, Print Preview, and Create PDF fallback honest while broadening print/export evidence.
4. Close one high-value behavior family with shared planning plus Avalonia UI where Word-like results are still weakly proven.
5. Add a WPF/Avalonia render or print evidence lane using the same DOCX fixture and a documented tolerance model, then run real Word PNG baselines on a machine with Word COM installed.

## FreeP Status

### Covered

- FreeP is no longer blocked on foundational file lifecycle work:
  - `.pptx` is the shared/default lifecycle path.
  - `.fxp` remains legacy-compatible.
  - `freep/FreeP.App.Presentation/PresentationFilePersistenceWorkflow.cs` owns shared persistence decisions.
- PPTX package snapshot/retention is on `main`:
  - `freep/FreeP.Core.Model/PptxPackageSnapshot.cs`
  - `freep/FreeP.Core.IO/PptxPackageReader.cs`
  - `freep/FreeP.Core.IO/PptxPackageWriter.cs`
- WPF/Avalonia ribbon definitions are now single-sourced through `freep/FreeP.Ribbon.Definitions`.
- The generated FreeP WPF/Avalonia command inventory is now present:
  - `docs/parity/freep-command-parity-inventory.json`
  - `docs/parity/freep-command-parity-inventory.md`
  - Current snapshot: 93 total commands, 87 shared, 0 raw WPF-only rows, 6 raw Avalonia-only shell rows, 0 actionable WPF/Avalonia missing commands, 0 explicit Avalonia gaps, 0 known-deferred commands, 6 platform-only commands, and 0 command-id aliases.
- Renderer-neutral planners now cover slide pane, canvas geometry/gestures, text layout, chart primitives, picture effects, slideshow host/playback, dialogs, insertion, and persistence under `freep/FreeP.App.Presentation`.
- `freep.layout` is no longer a silent command stub: both WPF and Avalonia route it through the shared `PresentationDesignCommandPlanner` layout-picker host intent. The remaining work is the actual picker UI/model selection flow.
- `tools/FreeP.RenderCompare` now includes pixel-diversity checks so blank or single-color output cannot silently pass as valid evidence.

### Main Gaps

1. Command-profile parity is no longer the leading FreeP WPF/Avalonia gap. The generated inventory reports 0 actionable WPF/Avalonia missing commands; the six raw Avalonia-only rows are platform-only shell commands.
2. Slide pane parity is partial:
   - WPF owns drag reorder, context menus, richer thumbnails, and section behavior in `freep/FreeP.App.Host/SlidePane.cs`.
   - Avalonia still has a simpler `ListBox` surface in `freep/FreeP.App.Avalonia/MainWindow.cs`.
3. Editing parity remains uneven:
   - WPF has rich text and table-cell editors.
   - Avalonia has simpler text editing and the rendering canvas still documents viewer-only interactive adorners.
4. Renderer duplication remains at the WPF/Avalonia realization edge even though many planners are now neutral.
5. PowerPoint-authoritative baselines cannot be claimed from this machine because `PowerPoint.Application` COM is not registered.
6. Fidelity gaps remain for PDF export, SmartArt/modern object editing, chart layout, OMML math layout, connector precision, media/presenter view depth, text effects, and true PowerPoint visual parity.

### FreeP Next Slices

1. Keep the generated FreeP command matrix green while implementation work deepens the command bodies behind shared planner intents.
2. Port WPF slide-pane interactions to Avalonia through the existing shared planner layer.
3. Close Avalonia rich editing and table-cell editing parity against WPF.
4. Add WPF/Avalonia evidence for export/backstage, presenter, comments/review/accessibility, and animation-pane workflows now that command-surface parity is green.
5. Run PowerPoint-backed render-compare baselines on a machine with PowerPoint COM installed, then use the harness for visual fidelity waves.

## Shared/Infrastructure Status

### Current Dashboard Assets

Use these as the current parity dashboard inputs:

- `docs/parity/functional-parity.json`
- `docs/parity/functional-parity.md`
- `docs/parity/dialog-parity-inventory.json`
- `docs/parity/dialog-parity-inventory.md`
- `docs/parity/surface-catalog.json`
- `docs/parity/command-inventory.json`
- `docs/testing/ui-test-catalog.md`
- `docs/unification/DEDUP-BACKLOG.md`
- `docs/unification/LOG.md`
- `tools/Generate-DialogParityInventory.ps1`
- `tools/Generate-CommandInventoryDocs.ps1`
- `tools/Test-GeneratedDocs.ps1`
- `tools/Test-RepositoryPreflight.ps1`
- `tools/FreeX.ParityCompare`
- `tools/FreeX.ParityCompare.Core`
- `tools/FreeW.RenderCompare`
- `tools/FreeP.RenderCompare`
- `freew/tools/FreeW.FidelityRender`
- `freew/tools/FreeW.PageLayoutShot`
- `freew/tools/FreeW.RibbonShot`

### Remaining Shared Work

1. Extend the generated inventory classifiers beyond raw command presence, especially for FreeW one-sided rows and shared planner-backed command bodies.
2. Add a unified rendered-evidence summary across FreeX, FreeW, and FreeP render/compare tools.
3. Keep shared boundary guards green:
   - `tests/SharedTestInfrastructure/PortableBoundaryGuard.cs`
   - `tests/Free.Shared.Ribbon.Tests`
   - `tests/Free.Shared.Theme.Tests`
   - `tests/Free.Shared.Pdf.Tests`
4. Add shared Shell/Opc test projects only when those APIs become broad enough to justify dedicated test assemblies.
5. Avoid forcing `tools/FreeX.ToolsShared` into FreeW/FreeP just to reuse tiny helpers. Create a neutral cross-suite tools package only if more shared tool helpers appear.

## Recommended Orchestration Order

1. Reconcile dirty lanes:
   - `FreeX-linux` for FreeW/Linux work.
   - `tester-release-20260627-r1` for generated FreeX parity artifacts.
2. Refresh the parity dashboard from stable `main`:
   - FreeX command/dialog/surface evidence.
   - FreeW WPF-vs-Avalonia command inventory classification.
   - FreeP WPF-vs-Avalonia command body/evidence depth.
   - Active deferred/platform-only allowlists.
   - Render/capture evidence availability.
3. Use dashboard gaps to choose implementation slices. Prefer small branches with one owned surface at a time.
4. For FreeX, start with qualitative dialog capture review and print/render evidence.
5. For FreeW, start with command-inventory classification plus reconciliation of the dirty Linux lane.
6. For FreeP, start with slide-pane/editing/evidence depth rather than command-profile expansion.
7. Keep merging verified slices quickly to `main`, then sync active branches from updated `main`.

## Immediate Next Action

The safest next implementation slice is not another dedup extraction. The obvious extraction backlog and the first FreeW/FreeP generated command inventories are closed. The next slice should be evidence and classification infrastructure:

1. Add a compact cross-app parity dashboard document or generated JSON summary that reads the existing FreeX, FreeW, and FreeP generated evidence.
2. Classify FreeW one-sided command rows so workers can distinguish real missing Avalonia behavior from profile-shape/platform-only noise.
3. Use that dashboard to rank the next code work for the 100% parity goal.

If the next slice must be app-specific, choose one of:

- FreeX qualitative dialog capture review.
- FreeW command-inventory classification, plus the safe product slice of Avalonia Backstage Info/Options safety parity.
- FreeP slide-pane/editing parity or workflow evidence depth.
