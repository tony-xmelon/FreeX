# Avalonia vs WPF Parity Scope - 2026-06-27

## Purpose

This document refocuses the thread from a narrow FreeX Linux dialog-parity lane to a repo-wide WPF vs Avalonia parity program across:

- FreeX - spreadsheet app.
- FreeW - word-processing app.
- FreeP - presentation app.
- Shared infrastructure, render/capture tools, and guardrails.

The immediate goal is not to claim parity. The goal is to make the current WPF/Avalonia gap map explicit, avoid overlapping active worktrees, and choose the next implementation slices from evidence.

## Current Evidence

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- `main` was clean and synced with `origin/main` at `a2153c106` during this audit.
- `AGENTS.md` requires isolated worktrees, no implementation in `main`, frequent sync, subagents for independent work, and merge/push/cleanup after completed slices.
- This scope was produced from read-only subagent audits plus local orchestration inspection. No product code was edited for the audit.

## Active Worktrees To Avoid Overlapping

The following 2026-06-27 lanes already exist and should be treated as owned until they land or are explicitly abandoned:

| Worktree/branch | Observed purpose | Coordination risk |
| --- | --- | --- |
| `.worktrees/dedup-avalonia-shell-frame-20260627` | Adds `shared/Free.Shared.Shell.Avalonia` and touches FreeW/FreeP Avalonia shells. | Do not start parallel shell-frame extraction. |
| `.worktrees/dedup-guardrails-20260627` | Extracts shared portability guard logic into `tests/SharedTestInfrastructure/PortableBoundaryGuard.cs`. | Land this before adding new source-boundary guardrails. |
| `.worktrees/dedup-ribbon-adaptive-policy-20260627` | Moves WPF/Avalonia adaptive ribbon behavior toward shared policy. | Do not edit ribbon adaptive policy/renderers in parallel. |
| `.worktrees/dedup-shared-drawing-adoption-20260627` | Repoints FreeX-local drawing geometry toward `shared/Free.Shared.Drawing`. | Avoid drawing model/geometry churn until resolved. |
| `.worktrees/freep-wpf-pptx-lifecycle-20260627` | Makes WPF FreeP PPTX the primary file lifecycle. | Blocks FreeP file-lifecycle parity work on main. |
| `.worktrees/freep-pptx-package-retention-20260627` | Preserves unmodeled PPTX package parts. | Blocks PPTX package-retention follow-up on main. |
| `.worktrees/freep-avalonia-command-surface-20260627` | Adds Avalonia FreeP command surface. | Coordinate before expanding FreeP Avalonia ribbon commands. |
| `.worktrees/freep-render-harness-trust-20260627` | Hardens `tools/FreeP.RenderCompare`. | Coordinate before render-compare dedup/trust work. |
| `FreeX-linux` on `codex/linux-port-20260616` | Broad dirty FreeW/Linux parity lane. | Inspect as evidence source, but do not mix new dedup edits there. |

## Shared Spine Already In Place

The repo already has a substantial cross-host/shared tier:

- `shared/Free.Shared.Ribbon`
- `shared/Free.Shared.Ribbon.Wpf`
- `shared/Free.Shared.Ribbon.Avalonia`
- `shared/Free.Shared.Shell`
- `shared/Free.Shared.Shell.Wpf`
- `shared/Free.Shared.Theme`
- `shared/Free.Shared.Theme.Wpf`
- `shared/Free.Shared.Theme.Avalonia`
- `shared/Free.Shared.AppServices`
- `shared/Free.Shared.IO`
- `shared/Free.Shared.Opc`
- `shared/Free.Shared.Pdf`
- `shared/Free.Shared.Pdf.Wpf`
- `shared/Free.Shared.Pdf.Skia`
- `shared/Free.Shared.Drawing`
- `shared/Free.Shared.Localization`
- `shared/Free.Shared.Commands`

The high-leverage pattern is already established: neutral planner/model plus thin WPF/Avalonia renderer.

## FreeX Status

### Covered

- Ribbon definitions and command registry are heavily shared via `src/FreeX.Ribbon.Definitions`, `shared/Free.Shared.Ribbon`, `shared/Free.Shared.Ribbon.Wpf`, and `shared/Free.Shared.Ribbon.Avalonia`.
- Command binding parity is strong at the matrix level:
  - `docs/parity/functional-parity.json`
  - `docs/parity/functional-parity.md`
  - Reported snapshot: 531 commands, 468 parity, 2 Avalonia-missing, 48 WPF-missing, 13 both-missing.
  - The 2 Avalonia-missing commands were allowlisted JIS commands.
- Dialog routes are mostly backed by shared service/presentation planners:
  - `docs/parity/dialog-parity-inventory.md`
  - `src/FreeX.App.Services`
  - `src/FreeX.App.Presentation`
- Status-bar planning is already shared through `Free.Shared.AppServices.StatusBarViewModel` and related planners.

### Main Gaps

1. Dialog visual parity remains the largest proven gap. The inventory has 57 dialog routes, shared backing, and Avalonia harness routes, but committed visual evidence is incomplete and prior Linux dialog work only landed 9 first-pass visual batches.
2. Shell chrome is still split:
   - WPF: `src/FreeX.App.Host/MainWindow.xaml` plus WPF partials.
   - Avalonia: `src/FreeX.App.Avalonia/MainWindow.cs`, including `BuildContent`, `BuildToolbar`, `BuildSheetTabsChrome`, `BuildStatusBar`, and `BuildWorksheetViewportChrome`.
3. Backstage differs:
   - WPF: `src/FreeX.App.Host/MainWindow.Backstage.cs`, `src/FreeX.App.Host/MainWindow.BackstageFrame.cs`.
   - Avalonia: `src/FreeX.App.Avalonia/MainWindow.Backstage.cs`.
4. Print preview/export differs:
   - WPF: `src/FreeX.App.Host/PrintRenderer*.cs`, `src/FreeX.App.Host/PrintPreviewDialog.cs`, `src/FreeX.App.Host/MainWindow.PrintExport.cs`.
   - Avalonia: `src/FreeX.App.Avalonia/MainWindow.PrintPreview.cs`.
5. Keyboard routing remains platform-local:
   - WPF: `src/FreeX.App.Host/KeyboardShortcutMatcher*.cs`, `src/FreeX.App.Host/MainWindow.KeyboardCommands.cs`.
   - Avalonia: native menu/key paths largely inside `src/FreeX.App.Avalonia/MainWindow.cs`.

### FreeX Next Slices

1. Continue dialog visual parity from the latest report, starting with `dialog.SelectDataSource` unless a fresh report changes ranking.
2. Extract/consume shared shell-frame/QAT/status model after the active shell-frame lane settles.
3. Move keyboard shortcut matching into a portable service and gate both hosts from one matrix.
4. Close print preview parity around drawing/chart content and platform print/export affordances.
5. Deduplicate contextual-tab state/action routing for chart/table/pivot/drawing surfaces.

## FreeW Status

### Covered

- Strong shared document core:
  - `freew/FreeW.Core.Model`
  - `freew/FreeW.Core.IO`
  - `freew/FreeW.App.Presentation`
- Both hosts consume shared ribbon/app-service/PDF/theme infrastructure.
- File lifecycle is partly shared through `Free.Shared.AppServices.FileCommandWorkflow`.
- Avalonia `DocumentView` is now substantial, not just a stub:
  - WPF: `freew/FreeW.App.Host/Editing/DocumentView.cs`
  - Avalonia: `freew/FreeW.App.Avalonia/Editing/DocumentView.cs`

### Main Gaps

1. WPF command surface remains broader. Audit estimate:
   - WPF: roughly 622 unique `freew.*` command ids.
   - Avalonia: roughly 275.
2. Avalonia Backstage actions are incomplete:
   - WPF: `freew/FreeW.App.Host/Backstage/BackstageView.cs`.
   - Avalonia: `freew/FreeW.App.Avalonia/Backstage/BackstageView.cs`.
   - Gaps include Print actions, Info safety actions, Options, and Save Copy behavior.
3. Print/export parity is incomplete:
   - WPF: `freew/FreeW.App.Host/PrintPreviewWindow.cs`, `PdfExport.cs`, `XpsExport.cs`.
   - Avalonia: `freew/FreeW.App.Avalonia/Pdf/FreeWAvaloniaPdfExport.cs`.
4. Proofing/help is shallow in Avalonia:
   - WPF has spellcheck, thesaurus, read aloud, custom dictionary, proofing language, About, Legal Notices, and update/help flows.
   - Avalonia mainly has Word Count plus partial help/proofing surface.
5. Dialog depth differs:
   - WPF has mature dialog files across `freew/FreeW.App.Host`.
   - Avalonia has partial equivalents such as `FontDialog.cs`, `ParagraphDialog.cs`, `PageSetupDialog.cs`, `DesignDialogs.cs`, `InsertDialogs.cs`, and `MailMergeDialogs.cs`.
6. Object/image/chart commands and rich formatting are still uneven. Some Avalonia commands are explicit no-op/deferred placeholders in `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs`.

### FreeW Next Slices

1. Generate a fresh WPF-vs-Avalonia FreeW command inventory and classify every missing Avalonia command as backed, deferred, platform-only, or obsolete.
2. Enable Avalonia Backstage Print/Export/SaveCopy/Info actions using existing shared planners and callbacks.
3. Close proofing/help basics in Avalonia: About, Legal Notices, Copy Diagnostics, spell toggle/status, and honest service stubs where native capability is absent.
4. Convert one high-value dialog family to shared planning plus Avalonia UI. Good candidates: Cross Reference and Manage Sources.
5. Add one render/print parity lane that exercises WPF and Avalonia on the same DOCX fixture.

## FreeP Status

### Covered

- Shared domain and presentation spine:
  - `freep/FreeP.Core.Model/Presentation.cs`
  - `freep/FreeP.Core.Model/Slide.cs`
  - `freep/FreeP.Core.IO/PptxPackageReader.cs`
  - `freep/FreeP.Core.IO/PptxPackageWriter.cs`
  - `freep/FreeP.App.Presentation/SlideCompositor.cs`
  - `freep/FreeP.App.Presentation/EditingSession.cs`
  - `freep/FreeP.App.Presentation/SnapEngine.cs`
  - `freep/FreeP.App.Presentation/SlideShowController.cs`
- WPF and Avalonia both have canvas/rendering projects:
  - `freep/FreeP.App.Rendering.Wpf`
  - `freep/FreeP.App.Rendering.Avalonia`
- `tools/FreeP.RenderCompare` exists and can compare WPF/Avalonia/PowerPoint evidence, but its trust-hardening work is active in a separate worktree.

### Main Gaps

1. File lifecycle is split on `main`:
   - WPF still uses `.fxp` in `freep/FreeP.App.Host/FileCommands.cs`.
   - Avalonia uses `.pptx` directly in `freep/FreeP.App.Avalonia/MainWindow.cs`.
   - Active branch `freep-wpf-pptx-lifecycle-20260627` likely addresses this but is not on `main`.
2. Ribbon/command parity is a major gap:
   - WPF: `freep/FreeP.App.Host/FreePRibbon.cs`, `freep/FreeP.App.Host/FreePRibbonCommands.cs`.
   - Avalonia: `freep/FreeP.App.Avalonia/FreePRibbonAvalonia.cs`, currently much thinner.
3. Slide thumbnails are not equivalent:
   - WPF: `freep/FreeP.App.Host/SlidePane.cs` has richer thumbnails, sections, context menu, and drag reorder.
   - Avalonia rebuilds a basic `ListBox` inline in `freep/FreeP.App.Avalonia/MainWindow.cs`.
4. Renderer duplication remains:
   - WPF: `freep/FreeP.App.Rendering.Wpf/SlideCanvas.cs`.
   - Avalonia: `freep/FreeP.App.Rendering.Avalonia/SlideCanvas.cs`.
   - Both consume `SlideCompositor`, but duplicate chart/text/picture/effects realization.
5. Selection/editing parity is incomplete:
   - WPF has `InCanvasTextEditor.cs` and `InCanvasTableCellEditor.cs`.
   - Avalonia has `AvaloniaInCanvasTextEditor.cs` with rich per-run editing deferred.
6. PPTX package retention is not yet on `main`; active branch `freep-pptx-package-retention-20260627` owns it.
7. Slideshow/media/presenter-view depth is incomplete; Avalonia `SlideShowWindow.cs` defers transition sound/media.

### FreeP Next Slices

1. Land or finish WPF `.pptx` primary lifecycle, then align Avalonia dirty gate, recent files, Save As, and open/save semantics.
2. Land package-retention snapshot coverage so unknown PPTX parts, relationships, and content types survive round-trip.
3. Build a shared FreeP command/ribbon catalog, then close Avalonia ribbon gaps by tab group: Insert, Design, Transitions, Animations.
4. Extract a shared slide-pane planner and port WPF thumbnail sorter/context behavior to Avalonia.
5. Harden `tools/FreeP.RenderCompare` with blank/diversity checks before using it as a parity gate.

## Shared/Infrastructure Status

### Top Dedup Gaps

1. `shared/Free.Shared.Shell.Avalonia` should become the Avalonia equivalent of `shared/Free.Shared.Shell.Wpf`. Active shell-frame lane owns this.
2. Finish `shared/Free.Shared.Drawing` adoption and remove FreeX-local drawing clones. Active drawing lane owns this.
3. Centralize adaptive ribbon collapse policy so WPF and Avalonia renderers are thin realizers over one policy. Active ribbon-adaptive lane owns this.
4. Promote OPC path/rels/content-type helpers and core document properties into `shared/Free.Shared.Opc`.
5. Extend FreeX's command parity matrix pattern to FreeW and FreeP.
6. Consolidate render-compare primitives across `tools/FreeX.*Compare`, `tools/FreeW.RenderCompare`, and `tools/FreeP.RenderCompare` while preserving app-specific tolerances.

### Core Dashboard Assets

Use these as the initial parity dashboard inputs:

- `docs/parity/functional-parity.json`
- `docs/parity/functional-parity.md`
- `docs/parity/dialog-parity-inventory.json`
- `docs/parity/dialog-parity-inventory.md`
- `docs/parity/surface-catalog.json`
- `docs/parity/command-inventory.json`
- `docs/testing/ui-test-catalog.md`
- `tools/FreeX.ParityCompare`
- `tools/FreeX.ParityCompare.Core`
- `tools/FreeW.RenderCompare`
- `tools/FreeP.RenderCompare`
- `freew/tools/FreeW.FidelityRender`
- `freew/tools/FreeW.PageLayoutShot`
- `freew/tools/FreeW.RibbonShot`

### Guardrails To Add

1. Shared `PortableBoundaryGuard` contract under `tests/SharedTestInfrastructure` after the active guardrails lane lands.
2. Contract tests in:
   - `tests/Free.Shared.Ribbon.Tests`
   - `tests/Free.Shared.Theme.Tests`
   - `tests/Free.Shared.Pdf.Tests`
   - future Shell/Opc shared test projects once APIs are authoritative.
3. Per-app command matrix emitters for FreeW and FreeP, modeled after FreeX's WPF/Avalonia command-binding matrix.
4. Rendered evidence summary ingestion from FreeX/FreeW/FreeP render-compare tools into one dashboard artifact.

## Recommended Orchestration Order

1. Land guardrails first. This is low product risk and makes later cross-host drift visible.
2. Land ribbon adaptive policy next, with focused WPF/Avalonia renderer tests.
3. Land Avalonia shell-frame extraction after guardrails; it introduces a new shared project and touches FreeW/FreeP shell startup.
4. Land shared drawing adoption after checking FreeP render-harness branches.
5. Land FreeP file lifecycle and package-retention branches before expanding FreeP Avalonia command/ribbon work on main.
6. Build a cross-app parity dashboard from stable `main`:
   - FreeX command/dialog/surface evidence.
   - FreeW WPF-vs-Avalonia command inventory and render evidence.
   - FreeP WPF-vs-Avalonia command inventory and render evidence.
   - Active deferred/platform-only allowlists.
7. Resume targeted implementation slices from the dashboard. Prefer small branches, one owned surface at a time, with preflight/build/default-test validation before merging.

## Immediate Next Action

Do not start new implementation in shell, ribbon adaptive policy, drawing, or FreeP file lifecycle until the active worktrees above are reconciled.

The safest next orchestration slice is:

1. Check which active worktrees are merge-ready.
2. Integrate completed guardrail and shared-policy lanes first.
3. Then create the cross-app parity dashboard generator/summary from stable `main`.

If implementation must start before those land, choose a non-overlapping documentation or inventory slice:

- FreeW command inventory generator.
- FreeP command inventory generator.
- FreeX dialog visual parity continuation on a single dialog route, avoiding shared shell/ribbon/drawing files.
