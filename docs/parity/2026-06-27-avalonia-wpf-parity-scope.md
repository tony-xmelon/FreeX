# Avalonia vs WPF Parity Scope - Updated 2026-07-04

## Purpose

This document tracks the repo-wide WPF vs Avalonia parity program across:

- FreeX - spreadsheet app.
- FreeW - word-processing app.
- FreeP - presentation app.
- Shared infrastructure, render/capture tools, generated evidence, and guardrails.

The target is 100% practical parity: shared policy where the platforms should behave the same, explicit platform-specific adapters where the UI stack requires them, and current evidence for any claim of visual or functional parity.

This update replaces the 2026-06-27 pre-dedup snapshot. The extensive dedup session has landed many items that were previously blockers; the remaining work is now mostly evidence, command-depth, renderer-edge fidelity, and app-specific workflow completion.

## Explicit Scope Exclusion (2026-08-24)

The active visual-parity program intentionally excludes Ink/Draw fidelity and map-chart fidelity in FreeX, FreeW, and FreeP until they are separately prioritized. Do not treat either area as current implementation or visual-calibration debt, and do not add fixture-specific rendering work for them under this program.

## Current Evidence

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- Audit worktree: `.worktrees/parity-scope-current-20260704`.
- `main` was clean and synced with `origin/main` at `f69136829` during this update.
- `AGENTS.md` requires isolated worktrees, no implementation in `main`, frequent sync, subagents for independent work, and merge/push/cleanup after completed slices.
- This report was refreshed from the generated parity inventories and dialog visual evidence after the FreeX sort-dialog evidence classification, FreeP slide-pane thumbnail evidence mode, and FreeW TOA evidence-blocker tracking slices landed.
- 2026-07-14 keyboard routing update: FreeX catalog-backed workbook shortcuts now have executable WPF matcher evidence plus Avalonia resolver/native-menu evidence from the shared `WorkbookKeyboardShortcutCatalog` route matrix.

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
- Keyboard route parity is now proven for the shared workbook shortcut matrix:
  - `src/FreeX.App.Presentation/Shell/WorkbookKeyboardShortcutCatalog.cs` owns the catalog-backed route matrix.
  - WPF matcher tests verify every catalog command/font/number-format/border/paste-special Windows chord reaches the expected `KeyboardShortcutMatcher` path.
  - Avalonia tests verify every catalog Windows chord and every native-menu chord resolves through the real `MainWindow` workbook shortcut resolver.
- Dialog route inventory is generated and current:
  - 57 total routes.
  - 57 WPF captures.
  - 57 committed Avalonia captures.
  - 57 Avalonia harness routes.
  - 57 shared-or-presentation-backed routes.
  - `docs/parity/dialog-visual-evidence-summary.md` compares the committed WPF/Avalonia capture manifests: 93 WPF manifest surfaces, 93 Avalonia manifest surfaces, 93 paired surface ids, 0 WPF-only ids, 0 Avalonia-only ids, and 0 nonblank failures.
  - The stale promoted WPF workbook-dialog evidence is closed: `dialog.OpenWorkbook` and `dialog.SaveAsWorkbook` now have direct 640x420 WPF captures paired with the 640x420 Avalonia captures.
  - Current scale-aware dialog triage is 19 paired dimension mismatches, all classified as expected platform/native differences. The previously promoted real logical-size rows (`dialog.PivotTableOptions`, `dialog.PivotTableOptions.LayoutAndFormat`, `dialog.ConditionalFormatNewRule`, and `dialog.Consolidate`) now match the shared expected-size contracts in checked-in evidence.
  - There are currently 0 stale promoted expected-size evidence rows; future stale-size rows should be resolved through direct parity capture before their dimensions are treated as product layout evidence.
- Much of the spreadsheet behavior now flows through shared or presentation planners:
  - Workbook lifecycle/open target: `src/FreeX.App.Services/WorkbookFileLifecycleCoordinator.cs`, `WorkbookOpenTargetPlanner.cs`.
  - Viewport/scroll planning: `src/FreeX.App.Services/WorkbookViewportScrollPlanner.cs`.
  - Backstage projection: `src/FreeX.App.Presentation/Backstage`.
  - Print render planning: `src/FreeX.App.Presentation/PageLayout/WorksheetPrintRenderPlanner.cs`.
  - Drawing and selection-pane policy: `src/FreeX.App.Presentation/DrawingUI`, `shared/Free.Shared.Drawing`.
  - Status bar and file workflow services: `shared/Free.Shared.AppServices`.

### Main Gaps

1. Dialog route evidence is no longer the leading inventory gap: the generated inventory is 57/57 for WPF captures, Avalonia captures, Avalonia harness routes, and shared/presentation-backed routes, and the committed manifest PNGs are 93/93 paired. Remaining work is qualitative visual review, scale-aware pixel comparison, foreground workflow proof, interaction diffs, and policy review of expected platform/native differences rather than missing route assets or the resolved logical-size rows.
2. Shell, backstage, and print/export are partly deduped at the policy layer but still have host-local renderer edges:
   - WPF keeps `MainWindow.xaml`, `PrintRenderer*`, and native `PrintDialog` behavior.
   - Avalonia keeps substantial `MainWindow.cs`, custom print/preview, Skia/PDF, and capture glue.
3. Catalog-backed keyboard routing is no longer an unproven split: WPF and Avalonia are both gated by `WorkbookKeyboardShortcutCatalog` for the shared workbook shortcut matrix. Remaining keyboard work is limited to host-local non-catalog gestures, keytip continuations, and deeper workflow proof where the route is already known.
4. Contextual chart/table/pivot/drawing commands have strong command binding coverage, but still need workflow evidence across WPF and Avalonia.

### FreeX Next Slices

1. Continue visual review of the 19 scale-aware paired dialog dimension outliers, all currently policy-classified as expected platform/native differences. Keep raw PNG pixel mismatches separate from product layout work because many normalize away by capture DPI; the resolved shared-size rows (`dialog.PivotTableOptions`, `dialog.PivotTableOptions.LayoutAndFormat`, `dialog.ConditionalFormatNewRule`, and `dialog.Consolidate`) should stay guarded by generator/tests instead of reappearing as next-slice product layout work.
2. Extend non-catalog keyboard/keytip workflow evidence now that catalog-backed workbook shortcut matching is proven from one matrix.
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
- Avalonia Backstage Info safety actions are now backed by shared planners and thin callbacks, and Backstage Print uses a shared direct-print capability/status policy with evidence contracts covering the honest Avalonia Print Preview/Create PDF fallback.
- Review > Thesaurus now has shared presentation planning for lookup, selection, and Insert/Copy action intent. Both WPF and Avalonia expose Insert and Copy over that shared plan; Insert routes through the editor command bus and Copy respects honest platform clipboard availability.
- Review > Proofing Language now has shared-first caret behavior and dialog planning: selected ranges apply through the shared run-formatting path, while no-selection apply updates caret/typing language state instead of mutating the preceding run.
- View > Side to Side now has read-only page-pair navigation in the shared paginated preview path; editable horizontal page view remains deferred.
- The latest local no-Word baseline evidence run covers 20 DOCX fixtures including `references-heavy-fields`, reports 80 trusted WPF/Avalonia evidence rows, and the Word-baseline runner reports 80 baseline comparison rows. Status remains no-Word fallback only on this machine (`skipped=4`, `word-baseline-unavailable=76`); no real Word PNGs were generated.
- The drawing-effects evidence contract is integrated on `origin/main` (`006988bfe`) and now promotes the `drawing-objects-complex` grouped child shape glow (`GroupChild0:Shape:glow`) to paired trusted WPF/Avalonia rendered evidence when both host manifests report the same child summary. Top-level effect-bearing objects remain separately reported for `drawing-objects-complex` (3 effect objects: shape shadow, image shadow/glow/reflection/artistic effect, WordArt glow) and `wordart-watermark-stress` (2 effect objects: shape shadow, WordArt glow). This is renderer-parity evidence only on this machine; the real Word COM PNG baseline is still unavailable in the local no-Word fallback run.
- The note-region visual planner is integrated on `origin/main` (`6e7c6f6ac`): shared `DocumentNoteRegionPlanner` owns footnote/endnote note-region rows, WPF `PageBox` / `FreeW.FidelityRender` and Avalonia `FreeW.PageLayoutShot` use the shared plan, and Avalonia F2 footnote/endnote captures now draw visible note rows instead of metadata-only note flags.
- The table cell-border visual planner is integrated on `origin/main` (`6e8532452`): shared `TableCellBorderVisualPlanner` owns per-edge brush, thickness, dash, dotted, double, and mixed-color decisions; WPF renders through a thin `TableCellBorderChrome` overlay and Avalonia draws from the same plan.
- Protection history guards are integrated on `origin/main` (`6a21f6ff`): shared `RestrictEditingEnforcementPolicy` owns undo/redo allow/block decisions, exposes the host-neutral mutation classification used for comments-only history, WPF and Avalonia both gate history mutation through it, and WPF intercepts Ctrl+Z/Ctrl+Y under the same policy.
- Cross-reference Update Fields refresh is integrated on `origin/main` (`abc9fb224`, merge `beae7616f`): shared `CrossReferences` recomputes `REF`, `PAGEREF`, and `NOTEREF` cached text, with WPF/Avalonia document views acting as thin consumers.
- Type-aware source entry is integrated on `origin/main` (`2fd6d16f`, merge `49ad3369c`): shared `SourceManagementDialogPlanner` exposes the modeled Book, Journal Article, and Web Site fields to WPF/Avalonia Add/Edit Source dialogs, and WPF Insert Citation now adds the full source object.
- Mark Citation dialog/legal category parity is integrated on `origin/main` (`edd31dc4f`, merge `cf5521140`): shared `MarkCitationDialogPlanner` owns legal category choices, labels, seed trimming, validation, and `Citation` construction, with WPF/Avalonia thin dialogs and Avalonia full category/short-citation insertion.
- In-text citation personal-author display is integrated on `origin/main` (`ed973aa4`, merge `419eeb8ea`): shared `Citations.FormatInText` renders clear personal authors by family name for Word-like in-text citations while preserving corporate/ambiguous author strings and leaving bibliography/source storage unchanged.
- Structured source-author persistence is now shared-first for the modeled Book, Journal Article, and Web Site source types: `Source` keeps Word-style `b:NameList/b:Person` rows alongside the flat display author, DOCX read/write preserves personal authors as `NameList/Person`, and corporate or ambiguous legacy strings continue to serialize as `b:Corporate`. WPF and Avalonia source dialogs route author projection through `SourceManagementDialogPlanner`.
- Table of Authorities region planning is integrated on `origin/main`: shared `TableOfAuthoritiesRegionPlanner` owns generated paragraph insertion position, stale generated-region deletion order, option flow, and style registration. WPF and Avalonia now share the Word-like fallback where Refresh Table of Authorities inserts at the document end when no prior TOA region exists.
- Numeric citation numbering is implemented in shared core: IEEE/Vancouver in-text citations now use source-order markers such as `[1]` / `[2]` in both WPF and Avalonia insertion paths, repeated source tags reuse the same number, and numeric bibliography/reference-list output keeps source order with numbered entries.
- References-heavy visual evidence and TOA evidence-blocker tracking are integrated on `origin/main`: `references-heavy-fields` is part of the generated visual evidence contract, and `freew_visual_evidence_summary.json` now emits both `referencesHeavyProofReadiness` and `remainingEvidenceBlockers` for `references-heavy-toa-page-number-fidelity`, including semantic generated-TOA page-reference evidence separately from the remaining real-MS-Word-PNG baseline requirement.
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
3. Remaining behavior/evidence work should focus on Word-like results that are weakly proven, especially source-manager breadth beyond modeled document-local Book/Journal/Web fields and structured people/corporate authors, citation field/live-renumbering behavior beyond family-name and numeric source-order display, TOA live page-number/rendered evidence beyond the shared mark dialog and generated-region planner, rich rendering, and visual evidence. Proofing language apply now has shared caret/range behavior and dialog planning, cross-reference refresh is shared, type-aware source entry is shared, structured source-author persistence is shared, Mark Citation category/short-citation entry is shared, in-text personal-author display is shared, numeric citation display is shared, and host-neutral protection history classification/mutation is guarded in both hosts, so new work should target unproven behavior or evidence rather than duplicating those contracts.
4. Avalonia Backstage Options and Info safety are now wired through shared planners. The remaining Backstage print limitation is direct native printer selection: WPF is host-backed through `PrintDialog`, while Avalonia exposes Print Preview and Create PDF because the current Avalonia target has no native printer dialog/service API.
5. Print/export parity is incomplete. Avalonia PDF export and preview fallback are backed and evidence-contracted, but direct native print remains deferred and renderer-fidelity evidence still needs broader print-pipeline coverage.
6. Rich rendering is improving: drawing-effects evidence now covers top-level effect-bearing shape/image/WordArt objects, and table cell-border rendering now shares the same per-edge visual plan across WPF/Avalonia. SmartArt and grouped-child DrawingML-heavy surfaces are still simplified or intentionally unclaimed compared with WPF/Word.
7. Split and page-preview modes are backed as read-only snapshots, and Side-to-Side page-pair navigation is implemented for that read-only path. True dual-live split editing, editable responsive multi-page grids, and editable horizontal Side-to-Side page view remain deferred.
8. Full MS Word visual parity is not proven locally. Real Word PNG comparison remains limited by Word COM availability on this machine, so no-Word fallback evidence, including the new visible note-region, drawing-effects, and table cell-border rows, must not be read as an authoritative Word visual match.

### FreeW Next Slices

1. Keep the generated FreeW command inventory current as command slices move, but use it as a guard rather than a command-count backlog.
2. Reconcile or land the active `FreeX-linux` FreeW work before duplicating effort in the same files.
3. Continue the Avalonia Backstage print lane by adding real native print only if the target exposes a printer API; otherwise keep the shared capability/status policy, evidence contract, Print Preview, and Create PDF fallback honest while broadening print/export evidence.
4. Close one high-value behavior family with shared planning plus Avalonia UI where Word-like results are still weakly proven.
5. Extend the WPF/Avalonia render or print evidence lane from the current no-Word baseline, keeping the shared note-region, top-level drawing-effects, table cell-border, protection-history, cross-reference-refresh, references-heavy, and generated review compare/combine retained-model safety rows covered in both renderers, then run real Word PNG baselines on a machine with Word COM installed.

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
  - Current snapshot: 102 total commands, 94 shared, 0 raw WPF-only rows, 8 raw Avalonia-only shell/profile rows, 0 actionable WPF/Avalonia missing commands, 0 explicit Avalonia gaps, 0 known-deferred commands, 8 platform-only commands, and 0 command-id aliases.
- Renderer-neutral planners now cover slide pane, canvas geometry/gestures, text layout, chart primitives, picture effects, slideshow host/playback, dialogs, insertion, and persistence under `freep/FreeP.App.Presentation`.
- `freep.layout` is no longer a silent command stub: both WPF and Avalonia route it through the shared `PresentationDesignCommandPlanner` layout-picker host intent. The remaining work is the actual picker UI/model selection flow.
- `tools/FreeP.RenderCompare` now includes pixel-diversity checks so blank or single-color output cannot silently pass as valid evidence.
- `tools/FreeP.RenderCompare --slide-pane-thumbnail-compare` now creates WPF/Avalonia/PowerPoint slide-pane thumbnail evidence directories, emits WPF-vs-Avalonia and PowerPoint-backed diff rows, and reports PowerPoint rows as `n/a` when `PowerPoint.Application` COM is unavailable.
- `tools/FreeP.RenderCompare --notes-page-preview-evidence` now writes a shared notes-page preview PDF plus CSV evidence rows for WPF/Avalonia from the common notes-page render plan without requiring PowerPoint COM.
- `tools/FreeP.RenderCompare --export-backstage-evidence` now writes shared Backstage export/print CSV evidence rows for fixed-layout PDF, image sequence, full-page print package handoff, 3-up handouts, and video frame-package planning. WPF/Avalonia rows are local no-COM evidence; PowerPoint baseline cells remain `n/a/deferred`.
- Modern comments/review now has paired WPF and Avalonia execution evidence for shared reply mutation, pane refresh, dirty-state propagation, and PowerPoint modern author identity reuse through `PresentationReviewWorkflowPlanner`.
- Slide-pane drag reorder now uses a shared drag-session planner for start thresholding, insertion target projection, drop completion, and cancellation. WPF and Avalonia remain thin pointer adapters, and Avalonia headless tests cover drag preview feedback plus completed reorder.

### Main Gaps

1. Command-profile parity is no longer the leading FreeP WPF/Avalonia gap. The generated inventory reports 0 actionable WPF/Avalonia missing commands; the eight raw Avalonia-only rows are platform-only shell/profile commands.
2. Slide pane parity is partial:
   - Drag reorder and context actions now flow through shared planner contracts in both hosts.
   - WPF still owns richer thumbnail rendering and deeper section behavior in `freep/FreeP.App.Host/SlidePane.cs`.
   - Avalonia still has a simpler `ListBox` realization in `freep/FreeP.App.Avalonia/MainWindow.cs`.
   - The focused thumbnail evidence mode can now generate WPF/Avalonia bitmap comparisons, but PowerPoint-authoritative thumbnail baselines still need a COM-capable machine and a no-COM success policy for local evidence loops.
3. Editing parity remains uneven:
   - WPF has rich text and table-cell editors.
   - Avalonia now shares table-cell rich edit selection/result metadata and selected bullet/numbering preset state with WPF through `TableCellEditPlanner`, but its editor widget remains simpler than WPF's native rich editor.
4. Renderer duplication remains at the WPF/Avalonia realization edge even though many planners are now neutral.
5. PowerPoint-authoritative baselines cannot be claimed from this machine because `PowerPoint.Application` COM is not registered.
6. Fidelity gaps remain for PDF export, SmartArt/modern object editing, chart layout, OMML math layout, connector precision, media/presenter view depth, text effects, and true PowerPoint visual parity.

### FreeP Next Slices

1. Keep the generated FreeP command matrix green while implementation work deepens the command bodies behind shared planner intents.
2. Port WPF slide-pane interactions to Avalonia through the existing shared planner layer.
3. Close Avalonia rich editing and table-cell editing parity against WPF.
4. Continue WPF/Avalonia evidence for presenter, remaining comments/review/accessibility depth, and animation-pane workflows now that command-surface parity is green; export/backstage now has a first no-COM package-handoff evidence row beyond notes-page PDF.
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
2. Refresh the parity dashboard from stable `main` when generated inventories or evidence summaries change:
   - FreeX command/dialog/surface evidence.
   - FreeW WPF-vs-Avalonia command inventory classification.
   - FreeP WPF-vs-Avalonia command body/evidence depth.
   - Active deferred/platform-only allowlists.
   - Render/capture evidence availability.
3. Use dashboard gaps to choose implementation slices. Prefer small branches with one owned surface at a time.
4. For FreeX, start with qualitative dialog capture review and print/render evidence.
5. For FreeW, start with behavior/evidence gaps such as stronger render evidence, not command-count expansion.
6. For FreeP, start with slide-pane/editing/evidence depth and no-COM evidence hygiene rather than command-profile expansion.
7. Keep merging verified slices quickly to `main`, then sync active branches from updated `main`.

## Immediate Next Action

The safest next implementation slice is not another dedup extraction. The obvious extraction backlog and the first FreeW/FreeP generated command inventories are closed. The next slice should be evidence, classification, or one narrow behavior family:

1. Keep this cross-app dashboard current from generated evidence rather than hand-counted command rows.
2. Reduce FreeX dialog visual mismatches by aligning one real layout target or explicitly classifying stale evidence.
3. Keep no-COM evidence paths honest for FreeW and FreeP so local WPF/Avalonia work is green without implying Microsoft Word/PowerPoint visual parity.

If the next slice must be app-specific, choose one of:

- FreeX policy review for one of the remaining expected platform/native dialog differences, or direct recapture if future generated evidence promotes a stale expected-size row.
- Another weakly proven FreeW shared behavior family, such as stronger render evidence.
- FreeP slide-pane thumbnail evidence no-COM success policy or richer editing evidence.
