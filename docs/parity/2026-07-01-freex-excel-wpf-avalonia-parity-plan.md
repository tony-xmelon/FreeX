# FreeX vs Excel WPF/Avalonia Parity Plan - 2026-07-01

## Scope

This report is the FreeX-specific follow-up to the repo-wide Avalonia/WPF parity scope. It tracks FreeX against Excel for Windows, then maps the remaining gaps across both FreeX WPF and FreeX Avalonia.

The implementation rule for the next waves is:

1. Build shared model, policy, planner, parser, catalog, and test data first.
2. Keep WPF and Avalonia as thin renderers, adapters, or native-service bridges.
3. Treat generated command coverage, functional binding coverage, dialog route coverage, visual capture coverage, and paired Excel evidence as separate layers.
4. Do not use this coordination lane for product implementation.

Snapshot used for this report:

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- Refreshed from `origin/main`: `8c40670e6` (`test(freew): cover linux package metadata`).
- Report branch: `codex/freex-parity-dashboard-refresh-20260701`.
- Inputs: `docs/parity/command-surface.md`, `docs/parity/menu-toolbar.md`, `docs/parity/shortcuts.md`, `docs/parity/functional-parity.md`, `docs/parity/dialog-parity-inventory.md`, `docs/testing/ui-test-catalog.md`, and read-only WPF/Avalonia source audits.

## Current Dashboard

| Layer | Current state | Interpretation |
| --- | --- | --- |
| Excel command surface | `173` Implemented, `26` Partial, `0` Not Implemented, `0` Deferred, `25` Excluded | The supported visible Excel command surface is fully covered at the command-scope level, but `Partial` rows remain the practical parity backlog. |
| Menu/toolbar row surface | `174` Implemented, `26` Partial, `0` Not Implemented, `0` Deferred, `25` Excluded | Counts one Draw menu row separately; this is a counting-policy difference from `command-surface.md`, not evidence drift. |
| Shortcuts and keytips | `93` Parity, `0` Partial | Visible shortcut/keytip inventory is green. Future keytip work should preserve Excel sequences, including multi-key Alt continuations such as `Alt,D,F,F`. |
| WPF/Avalonia functional matrix | `531` commands, `473` parity, `0` Avalonia-missing, `48` WPF-missing, `10` both-missing | This is a command-binding matrix, not an Excel parity claim. `AVALONIA-MISSING` and intentional Linux omissions are now zero. The generated classifier should be the first stop before workers treat WPF/BOTH rows as missing behavior. |
| Dialog route inventory | `57` routes, `57` WPF captures, `57` Avalonia captures, `57` Avalonia harness routes, `57` shared/presentation-backed routes | Dialog route evidence is no longer the leading inventory gap; remaining work is qualitative visual review, foreground workflow proof, and pixel/interaction diffs. |

## Shared-First Baseline

The large dedup effort has moved FreeX much closer to the desired boundary. The current shared spine includes:

- Ribbon definitions and command surface: `src/FreeX.Ribbon.Definitions`, `shared/Free.Shared.Ribbon`, `shared/Free.Shared.Ribbon.Wpf`, `shared/Free.Shared.Ribbon.Avalonia`.
- App policy and planners: `src/FreeX.App.Services`, `src/FreeX.App.Presentation`.
- Shell and platform services: `shared/Free.Shared.Shell`, `shared/Free.Shared.Shell.Wpf`, `shared/Free.Shared.Shell.Avalonia`, `shared/Free.Shared.AppServices`.
- Drawing, shapes, and geometry: `shared/Free.Shared.Drawing`.
- PDF, OPC, theme, localization, and command infrastructure: `shared/Free.Shared.Pdf*`, `shared/Free.Shared.Opc`, `shared/Free.Shared.Theme*`, `shared/Free.Shared.Localization`, `shared/Free.Shared.Commands`.

Post-dedup source inspection shows these areas are already shared-first:

- WPF and Avalonia build the ribbon from the same `FreeXRibbon.Build()` definition.
- WPF ribbon rendering now delegates through a thin WPF host wrapper over `shared/Free.Shared.Ribbon.Wpf`.
- Avalonia ribbon rendering realizes the shared ribbon layout through `shared/Free.Shared.Ribbon.Avalonia`.
- Status bar data and presentation plans flow through neutral status models.
- Backstage rail ordering, selection, refresh, and command workflow are planned in shared/presentation code, with host-specific panes and native services on top.
- Worksheet context menu trees are shared `RibbonMenu` data with WPF and Avalonia renderers.
- Page layout, print preview instructions, export picker planning, chart layout, drawing geometry, selection-pane policy, AutoFilter criteria, conditional-format helpers, and several object/form-control planners now live in shared or presentation layers.

Progress note, 2026-07-14: print/export drawing evidence now has a host-neutral summary over the same `PageContentLayout` model consumed by print preview and export renderers. `PrintExportDrawingEvidencePlanner` reports printable chart blocks, selectable chart text overlays, text boxes, and text-box text runs page-by-page, with focused tests proving visible chart/text-box content is included and hidden/off-page drawing content is filtered by the render model before WPF or Avalonia realize it.

Progress note, 2026-07-14: export publish option rejection now has a host-neutral evidence summary after the drawing-evidence slice. `ExportPublishOptionEvidencePlanner` proves rendered page-range rejection for empty, start-after-last, and end-after-last output, PDF/A and tagged-PDF rejection for PDF, and XPS normalization that clears PDF-only choices before either host paints or writes the final output.

## Remaining Gap Map

### 1. Supported Excel Command Surface Partials

The `26` Partial rows in the generated command-surface summary are the main supported-surface backlog. They cluster into these implementation families:

- File/Backstage: PDF/XPS export, Options, Info, Share, Account.
- QAT: customization depth and import/export limits.
- Home formatting: full border drawing fidelity, theme colors/effects, custom number formats, full locale/accounting fidelity, conditional formatting manager breadth, table style/theme depth, and cell style semantics.
- Insert: PivotTable, PivotChart, Table, Comment/Note, and advanced chart families.
- Draw: interactive drag handles, gradients/effects, and Selection Pane depth.
- Page Layout: preset and custom theme support.
- Formulas and Data: Error Checking and Flash Fill inference/cleanup.
- Review: Spell Check, Accessibility Checker, new comments, and threaded comments.

These are not all equal priority. The highest-value practical gaps are the ones users compare directly with Excel during normal adoption: filters, formatting popups, tables/Pivots/charts, print/export, keyboard continuations, comments, and proofing/accessibility affordances.

### 2. WPF/Avalonia Command Binding and Classification

The generated WPF/Avalonia functional matrix is close, and the command/keytip slice has cleared the previous Avalonia paper-size gaps:

- `AVALONIA-MISSING` is `0`.
- Intentional Linux omissions are `0`.
- Many WPF-missing rows are combo boxes, gallery pseudo-items, Help-tab buttons, or controls driven through non-Click paths. The generated classification dashboard should be the first stop before workers treat them as missing behavior.
- Current generated matrix refresh now counts Help `Copy Diagnostics`, Help `Legal Notices`, and Review `Convert to Comments` as `PARITY` in both WPF and Avalonia. These three previously prioritized real behavior gaps are guarded by `PrioritizedCommandCleanupRows_RemainBoundInBothHosts`; the remaining WPF/BOTH rows are inventory or gallery classification noise.

### 3. Dialog and Native Surface Evidence

Dialog route plumbing and committed route evidence are now balanced:

- WPF has `57` committed dialog captures.
- Avalonia has `57` committed dialog captures and `57` harness routes.
- All `57` dialog routes are classified as shared/presentation-backed.
- The committed manifest comparison has `15` paired WPF/Avalonia surface ids, `0` WPF manifest ids without an Avalonia pair, and `78` additional Avalonia captured surface ids across `54` route families.
- Native file, Save As, export, and print surfaces still need foreground-sensitive evidence on both hosts.

### 4. Visual and Workflow Fidelity

The remaining Excel adoption risk is mostly visual/workflow fidelity:

- AutoFilter, number format, borders, conditional formatting, and context-menu popups need Excel-like richness and paired evidence.
- PivotTable, slicer, timeline, table, and chart workflows need shared render plans and paired WPF/Avalonia evidence.
- Chart/drawing object editing needs hit-testing, selection, handles, gradients/effects, layering, print/export, and XLSX persistence proof.
- Print/export now has shared printed-page drawing/chart evidence for chart blocks, selectable chart text overlays, and text-box text runs, plus shared evidence that invalid rendered page ranges, PDF/A, tagged PDF, and XPS PDF-only option leakage are rejected or normalized before output. It still needs stronger final PDF/XPS vector graphics, full chart text coverage, PDF/A/tagged-PDF output support, XPS parity claims beyond option normalization, and native dialog continuation evidence.
- Comments, threaded comments, proofing, spell check, accessibility, and protection need shared models/planners with thin host UI.

## Implementation Plan

### Wave 0 - Dashboard Hygiene

Goal: make the parity dashboard trustworthy before code work begins.

- Keep `command-surface.md`, `menu-toolbar.md`, `functional-parity.md`, and `dialog-parity-inventory.md` generated.
- Add a compact human dashboard that links command, shortcut, functional, dialog, visual, and paired Excel evidence.
- Classify every `WPF-MISSING`, `AVALONIA-MISSING`, and `BOTH-MISSING` matrix row as behavior gap, non-Click inventory row, pseudo-command, platform-only, deferred, or excluded.
- Regenerate and check docs with `tools\Test-GeneratedDocs.ps1` and `tools\Test-RepositoryPreflight.ps1`.

Deliverable: one docs/tools branch only; no product edits.

### Wave 1 - Shared Contract and Boundary Gates

Goal: make shared-first the default enforcement mechanism.

- Define shared command descriptors for command IDs, keytips, shortcuts, access keys, and continuation sequences.
- Add shared renderer contracts for dialogs, popups, galleries, context menus, and print/export prompts.
- Add boundary tests that fail when command policy, popup contents, dialog state, or workbook mutation logic lands in WPF/Avalonia host code instead of shared/presentation code.
- Keep host-specific code limited to native control creation, focus wiring, coordinate translation, file/print picker bridges, and renderer-specific painting.

Primary owners: `src/FreeX.App.Presentation`, `src/FreeX.App.Services`, `shared/Free.Shared.*`, and targeted tests.

### Wave 2 - Command Binding Cleanup

Goal: clear real command binding gaps and stop noisy false gaps.

- Keep page-size commands such as `B4 (JIS)` and `B5 (JIS)` covered in both hosts so Avalonia remains at zero missing rows.
- Normalize WPF non-Click controls and gallery pseudo-items in the functional matrix instead of reporting them as missing handlers.
- Preserve the Help copy diagnostics, Legal Notices, and Review convert-to-comments bindings in both hosts; keep Home border/color pseudo-items in the gallery evidence lane unless shared catalogs expose per-choice behavior.
- Keep Excel keyboard adoption protected while doing this. The shortcut/keytip suite must continue to cover direct shortcuts, shifted/controlled variants, Alt keytips, and multi-key continuations such as Data > Filter.

Primary owners: ribbon definitions, command registry/adapters, functional parity tests, shortcut/keytip tests.

### Wave 3 - Dialog Capture Parity

Goal: convert route and capture availability into qualitative visual proof.

- Create shared dialog capture descriptors so WPF and Avalonia use the same route ID, initial state, workbook fixture, and expected assertions.
- Review the paired WPF/Avalonia dialog captures for concrete layout, focus, keyboard, and interaction diffs.
- Promote the `78` additional Avalonia captured surface ids into paired WPF evidence where those surfaces represent in-scope desktop parity claims.
- Add foreground workflow proof for native file, Save As, export, and print surfaces that cannot be reduced to static route captures.

Primary owners: dialog planners, Avalonia parity capture harness, WPF capture references, generated dialog inventory.

### Wave 4 - Popup, Gallery, and Keyboard Workflow Fidelity

Goal: close the adoption gaps users hit while working quickly.

- AutoFilter: shared checklist/search/icon row model, criteria state, keyboard navigation, and Excel-like menu continuations.
- Number format and accounting: shared popup model with richer labels, previews, and locale/accounting behavior.
- Borders and conditional formatting galleries: shared item catalogs, remembered line style/color state, icon-set/color-scale/data-bar menus, and paired screenshots.
- Context menus: shared model plus WPF/Avalonia sizing, focus return, enabled-state, and keyboard proof.
- Keytips: preserve Excel Alt navigation and continuation chains through shared descriptors, then thin WPF/Avalonia display and routing layers.

Progress note, 2026-07-02: AutoFilter popup row presentation state is now shared through `AutoFilterMenuEntryPresentation`, covering icon kind, focus role, search participation, and continuation hints for sort, clear, filter-by-color, filter-family, search, select-all, and checklist rows. WPF and Avalonia keep thin adapter coverage over the shared plan; remaining evidence work is foreground visual capture and richer opened-state screenshots.

Primary owners: popup planners, shortcut/keytip services, ribbon renderers, foreground capture harness.

### Wave 5 - Pivot, Table, Chart, and Drawing Shared Render Plans

Goal: put the high-value visual workflows on shared render plans.

- PivotTable, slicer, and timeline: shared visual plans for field buttons, filters, dropdown targets, style/chrome, grouped outlines, slicers, and timelines.
- Tables: shared table style/theme materialization, totals row, filters, structured-reference state, and style option plans.
- Charts: shared chart render scene for titles, axes, labels, legends, shape styles, advanced chart family fallbacks, and export/print text coverage.
- Drawing: shared hit-testing, selection handles, object layering, gradient/effect descriptors, selection pane state, and context menus.
- WPF and Avalonia should only realize the shared scene into platform visuals.

Primary owners: `src/FreeX.App.Presentation`, `shared/Free.Shared.Drawing`, chart/table/pivot tests, WPF/Avalonia render adapters.

### Wave 6 - Workbook Fidelity, Print, and Export

Goal: make parity claims survive open/save/export and printed output.

- Continue package-preserving XLSX save and unsupported-feature warning coverage for partial Excel features.
- Improve PDF/XPS export around vector graphics, chart text, annotations, document metadata, page ranges, and unsupported option rejection. The first unsupported-option proof slice is covered by `ExportPublishOptionEvidencePlannerTests`, which verifies rendered page-range rejection, PDF/A/tagged-PDF rejection for PDF, and XPS clearing of PDF-only choices before either host paints the result.
- Pair WPF and Avalonia print/export behavior through shared planners and platform print/file-picker bridges. The first drawing/chart proof slice is covered by `PrintExportDrawingEvidencePlannerTests`, which verifies shared printed-page evidence for chart text overlays and text-box text before either host paints the result.
- Add Excel-authored corpus fixtures for the gaps this wave claims to close.

Primary owners: core IO, presentation print/export planners, PDF exporters, corpus tests, Excel-open smoke where available.

### Wave 7 - Review, Proofing, Accessibility, and Comments

Goal: close the remaining user-facing review workflows without coupling to Microsoft cloud services.

- Shared comment/note/thread model for local workbook comments, with explicit boundaries for cloud-only threaded behavior.
- Shared accessibility issue model and UI plan for workbook/sheet/chart/table checks.
- Shared spell-check/proofing planner with platform-specific dictionary or service bridges.
- Protection and allow-edit-range workflows remain shared models with host-specific dialogs.

Primary owners: review planners, core command services, dialog renderers, accessibility/proofing tests.

### Wave 8 - Paired Excel Evidence and Release Gate

Goal: make "matches Excel" evidence current and repeatable.

- For every closed wave, commit paired WPF/Avalonia evidence plus either Excel reference evidence or a documented reason Excel automation is unavailable.
- Keep generated docs green and use the same fixture names across command, dialog, visual, and corpus tests.
- Add a release gate summary with:
  - supported command-surface partials remaining,
  - WPF/Avalonia binding deltas remaining,
  - dialog capture deltas remaining,
  - visual evidence families remaining,
  - intentional exclusions and platform-only allowances.

## Suggested Worker Split

Use separate worktrees and subagents for implementation. Suggested first lanes:

| Lane | Ownership | First deliverable |
| --- | --- | --- |
| Dashboard/classifier | `docs/parity`, generated-doc tools, functional matrix tests | Matrix rows classified without changing product behavior. |
| Command/keytip cleanup | ribbon definitions, shortcut/keytip services, WPF/Avalonia command adapters | Keep `B4/B5 (JIS)` parity covered, protect Excel Alt continuations, and close the remaining real functional-binding rows. |
| Dialog visual review | WPF/Avalonia capture assets, dialog planners, generated dialog inventory | Qualitative diff notes for paired captures plus WPF pairs for high-value additional Avalonia surfaces. |
| AutoFilter/popup parity | filtering planners, popup/gallery renderers, foreground evidence | Richer shared popup model plus keyboard/foreground evidence beyond the now-present route capture. |
| Pivot/chart/drawing scene plans | presentation planners, shared drawing, host renderers | One high-value shared scene plan proven in both hosts. |
| Print/export fidelity | print/export planners, PDF/XPS exporters, native dialog services | Shared print/export evidence and PDF/XPS partials reduced. |

Do not run these from `main`. Each lane should merge only its own verified changes, push, and remove its worktree after integration.

## Verification Policy

Minimum report/dashboard validation:

- `tools\Test-GeneratedDocs.ps1`
- `tools\Test-RepositoryPreflight.ps1`
- `git diff --check`

Minimum product-lane validation depends on touched code, but the default gate remains:

- `dotnet build FreeX.slnx -c Release`
- focused tests for the changed shared layer and both host adapters
- generated docs checks when command/dialog artifacts move
- foreground or paired visual evidence for UI behavior claims

The release claim should only advance when command, shortcut, dialog, visual, workbook fidelity, and host parity evidence all agree.
