# FreeW Avalonia Parity Plan - 2026-07-01

## Purpose

This plan refreshes the old FreeW Avalonia catch-up document after the large dedup/shared-codebase effort. It is a WPF-vs-Avalonia implementation plan, not a WPF-vs-Microsoft Word gap list. The Word-facing WPF verdict lives in [freew-ms-word-parity-session-2026-06-21.md](freew-ms-word-parity-session-2026-06-21.md): WPF FreeW is in-scope exhausted/complete against Microsoft Word except explicit out-of-scope surfaces and open-ended evidence/polish.

Use [../parity/2026-06-27-avalonia-wpf-parity-scope.md](../parity/2026-06-27-avalonia-wpf-parity-scope.md) as the cross-app WPF-vs-Avalonia dashboard, but treat this file as the FreeW implementation order.

## Current July 1 State

The old snapshot that described Avalonia as a 22-command shell with no registry is obsolete. Current source has:

- `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs`.
- Shared ribbon definitions in `freew/FreeW.Ribbon.Definitions`.
- Shared Avalonia/WPF renderers through `shared/Free.Shared.Ribbon.Avalonia` and `shared/Free.Shared.Ribbon.Wpf`.
- Shared shell, IO, drawing, theme, PDF, and OPC infrastructure from the dedup work.
- A substantial Avalonia command surface that already covers more than the old five-tab starter shell.

The authoritative July 1 WPF/Avalonia command topology is the generated matrix in [../parity/freew-command-inventory.md](../parity/freew-command-inventory.md). It is built from compiled `FreeWRibbon.Build(FreeWRibbonCapabilities.Wpf/Avalonia)` profiles, including menu children. Source literal registry/definition hits are retained only as evidence columns and must not be treated as behavior proof or topology gates.

## Current July 7 Integrated Update

The command-surface phase is now exhausted for actionable WPF/Avalonia deltas. The generated FreeW command inventory reports `850` total commands with `0` actionable WPF gaps, `0` actionable Avalonia gaps, and `0` total actionable gaps. Raw `wpfOnly` / `avaloniaOnly` counts still include profile-shape, alias, deferred, and platform-specific rows; they are not implementation targets by themselves. The July 5 object-format behavior fix intentionally added explicit Avalonia menu-child rows for position, size, alt text, and shape-style choices; those rows are classified as profile-shape-only, not new cross-shell command debt.

The July 2 implementation wave also landed the last ready command-functional salvage slice (`freew.edit-hyperlink`, `freew.remove-hyperlink`, `freew.hyperlink-tooltip`, and `freew.link-bookmark`) and expanded the shared WPF/Avalonia visual evidence contract. `FreeW.App.Presentation` now owns visual evidence scenario identity, schema, expected output names, page geometry, section ownership, columns, page border, watermark, header/footer and notes expectations, table/drawing/chart/SmartArt expectations, and the nonblank/pixel-diversity trust contract. WPF `FreeW.FidelityRender` and Avalonia `FreeW.PageLayoutShot` now emit the same manifest shape while keeping renderer code host-thin.

The same wave closed the style-management planner gap by moving New Style / Modify Style / Manage Styles option planning, validation, row sorting, and reversible style-catalog mutation into shared layers (`StyleDialogPlanner` in presentation and `StyleCatalogCommand` in core model). WPF and Avalonia now act as thin dialog/rendering shells over the shared behavior.

Status 2026-07-03: the Review > Compare group now has model-backed Avalonia execution for Compare and Combine. Avalonia collects the source document paths and reviewer labels through thin shell dialogs, then runs the shared presentation workflow over `DocumentCompare` / `DocumentCombine`, loads the resulting blackline/combined document, and marks it as a new unsaved result.

Status 2026-07-03: Review > Thesaurus parity actions are integrated on `origin/main` (`6185e426d`, worker `cae248011a4203465215bc2c88c6919ace1fbf18`). Shared presentation planning now owns the thesaurus lookup, candidate selection, and replacement intent. Avalonia realizes synonym Replace over that shared plan, while WPF keeps the fuller pane host with Insert and Copy actions.

Status 2026-07-03: View-depth toggles for Split, Multiple Pages, and Side to Side now use a shared `FreeWViewDepthPlanner` policy in both WPF and Avalonia, with thin host workspace realization. Split shows the live editor above a read-only paginated snapshot. Multiple Pages and Side to Side swap the workspace to read-only paginated previews with a shared two-page-fit target. Side to Side also has read-only page-pair navigation on `origin/main` (`95146e749`, worker `baf46131a8dfc75dd76959deb64b08548a367764`); true dual-live split editing, responsive editable multi-page grids, and editable horizontal Side-to-Side page view remain explicit renderer limitations rather than fake parity.

Status 2026-07-03: character border/shading render parity is integrated on `origin/main` (`358180a07`, worker `a1ccee4f98a3e997525e480687a38d88a19b2a31`). Run-level decoration planning now flows through shared `FreeW.App.Presentation` policy with WPF/Avalonia render coverage; the integrated focused lane also covered the related character border/shading/language apply and round-trip tests.

Status 2026-07-03: the Word-baseline evidence fallback is integrated on `origin/main` (`e20690704`, worker `a503f396cd434960382d6caaf534f7caac03fd7a`). The baseline runner now uses an explicit WPF software-render fallback and keeps the no-Word path trustworthy instead of silently dropping baseline rows.

Status 2026-07-03: post-field evidence updates are integrated on `origin/main`. Proofing language caret behavior now follows the shared-first model (`2081a0dc0`, worker `60c24b8d9`): applying Set Proofing Language with no selection writes the language to caret/typing state rather than mutating the previous run, while selected ranges still apply through the shared formatting path. The proofing language dialog planner is also present (`373714b9e`, worker `22f78afc3`), keeping dialog choices and apply intent in shared presentation planning. The field page-number visual evidence scenario is integrated (`11e7c74ee`, worker `ddba30497`) and extends the manifest-backed evidence set with page-number field rendering. The note-region visual planner is also integrated (`6e7c6f6ac`): shared `DocumentNoteRegionPlanner` now owns footnote/endnote note-region rows, including separators, labels, wrapped text, estimated height, and synthetic endnote-page shape, while WPF `PageBox` / `FreeW.FidelityRender` and Avalonia `FreeW.PageLayoutShot` consume the same plan.

Status 2026-07-03: table cell-border visual planning is integrated on `origin/main` (`6e8532452`, worker `19311c25e`). Shared `TableCellBorderVisualPlanner` now owns per-edge brush, thickness, dash, dotted, double, and mixed-color decisions. WPF renders the shared plan through a thin `TableCellBorderChrome` overlay instead of collapsing explicit borders to one brush/thickness, while Avalonia stores and draws the same `TableCellBorderVisualPlan` rather than remapping raw cell borders locally. Integrated validation observed in the parent thread: presentation table/evidence tests 83/83, WPF source/round-trip tests 2/2, Avalonia table/evidence tests 136/136, `dotnet build FreeW.slnx --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal` clean, and `tools\Run-FreeWWordBaselineEvidence.ps1 -RunRoot artifacts\freew-table-border-evidence -AllowMissingWord` trust passed with 60 evidence rows / 60 baseline rows.

Status 2026-07-03: protection history enforcement is integrated on `origin/main` (`6a21f6ff`). Shared `RestrictEditingEnforcementPolicy` now classifies `HistoryUndo` and `HistoryRedo`; WPF and Avalonia both gate `CanUndo` / `CanRedo` / `Undo()` / `Redo()` through that shared policy, and WPF also intercepts Ctrl+Z/Ctrl+Y when the document is protected or marked final. Integrated validation observed in the parent thread: presentation policy tests 27/27, Avalonia protection tests 6/6, WPF protection tests 9/9, and `FreeW.slnx` Release build clean.

Status 2026-07-03: cross-reference field refresh is integrated on `origin/main` (`abc9fb224`, merge `beae7616f`). `CrossReferences` in `FreeW.Core.Model` now owns shared recomputation of `REF`, `PAGEREF`, and `NOTEREF` cached display text for Update Fields. WPF and Avalonia `DocumentView.UpdateFields` are thin consumers of that shared resolver, so stale cross-reference text updates after target headings, bookmarks, or notes change while dangling targets preserve their prior cached text. Integrated validation observed in the parent thread: core model cross-reference tests 32/32, core IO round-trip tests 7/7, WPF cross-reference/complex-field tests 8/8, Avalonia cross-reference/update-fields tests 2/2, and `FreeW.slnx` Release build clean.

Status 2026-07-03: type-aware source entry is integrated on `origin/main` (`2fd6d16f`, merge `49ad3369c`). `SourceManagementDialogPlanner` now owns Book, Journal Article, and Web Site field visibility, labels, trimming, validation, and source construction. WPF and Avalonia Add/Edit Source dialogs render those shared type-specific fields, and WPF Insert Citation now adds the full `Source` object instead of reconstructing a book-only subset. Integrated validation observed in the parent thread: source planner tests 14/14, citation model tests 58/58, bibliography IO tests 8/8, WPF source-management tests 7/7, Avalonia references tests 41/41, and `FreeW.slnx` Release build clean.

Status 2026-07-03: Mark Citation dialog parity is integrated on `origin/main` (`edd31dc4f`, merge `cf5521140`). `MarkCitationDialogPlanner` now owns category choices, labels, seed trimming, validation, and `Citation` construction for Word's legal-authority workflow. WPF and Avalonia render thin dialogs over that planner, and Avalonia now passes full `Citation` objects with category and optional short citation instead of silently marking every authority as default Cases. Integrated validation observed in the parent thread: presentation planner tests 4/4, Avalonia references tests 43/43, WPF Mark Citation tests 8/8, Table of Authorities IO tests 5/5, Table of Authorities model tests 26/26, and `FreeW.slnx` Release build clean.

Status 2026-07-03: in-text citation author display normalization is integrated on `origin/main` (`ed973aa4`, merge `419eeb8ea`). Shared `Citations.FormatInText` now converts clear personal-author strings to Word-like family-name display for in-text citations, including `Smith, John` -> `(Smith, 2020)`, `Jane Q. Doe` -> `(Doe, 2020)`, two-author ampersand forms, and `et al.` for three or more authors, while preserving corporate or ambiguous author strings. WPF and Avalonia inherit the behavior through their existing `DocumentView.InsertCitation` paths. Integrated validation observed in the parent thread: citation model tests 71/71, Avalonia references tests 43/43, WPF citation insertion test 1/1, bibliography IO round-trip tests 8/8, and `FreeW.slnx` Release build clean.

Status 2026-07-04: Table of Authorities region placement/refresh planning is now shared through `TableOfAuthoritiesRegionPlanner`. WPF and Avalonia both consume the same insert/refresh plan for generated TOA paragraph insertion, stale-region deletion order, option flow, style registration, and the Word-like fallback where Refresh inserts at the document end when no prior TOA region exists. This closes a host-local divergence in Avalonia's generated-reference helper without changing the legal citation model.

Status 2026-07-05: object-format behavior parity is integrated on `origin/main` (`ccf1b934e`). Avalonia now treats Picture Format / Shape Format `Position`, `Size`, `Alt Text`, and `Shape Styles` as dropdown/menu choices instead of mutating the document when a top-level opener is clicked with no selected value. Explicit menu commands apply the chosen position, size, alt-text preset, or shape-style preset. Avalonia selected-image and selected-shape left/center/right alignment now matches the WPF behavior by aligning the containing paragraph rather than routing those commands through floating-object placement. The behavior remains thin-host over shared command/catalog data in `FreeW.Ribbon.Definitions` and shared object-format planners. Validation observed on the integration branch and main: `dotnet build FreeW.slnx --configuration Release --no-restore` clean and `PictureDrawingContextualTabTests` 22/22.

Status 2026-07-07: the shared equation visual-planning tranche is integrated on `origin/main` through `EquationVisualPlanner`. Scripts, fractions/radicals, n-ary/large operators, matrices, accents/bars/delimiters/group chars, and function-apply all use shared presentation planning first, with WPF and Avalonia consuming the same plan through thin renderer/evidence paths. The generated visual evidence set now includes `equation-structures`, and the no-Word generated-corpus path wrote 25 DOCX fixtures including `equation-structures.docx`. Integrated validation reported by the workers: presentation equation tests 14/14, WPF equation source/round-trip 33/33, Avalonia equation/source 38/38, IO `EquationRoundTripTests` 19/19, presentation visual evidence/baseline 88/88, WPF source/evidence 2/2, and Avalonia source/evidence 2/2.

Status 2026-07-07: Source Manager bibliography source-type breadth is now shared-first across WPF and Avalonia. `ce11e085f` adds Patent, Interview, and Misc; `e61d1272e` adds Film, Sound Recording, Art, Internet Site, and Performance; and `bba3e7018` adds bibliography Case while keeping it separate from the Table of Authorities `Citation` model. The model, DOCX read/write mapping, bibliography formatting, source-management field planner, and master-source persistence all live in shared FreeW layers, so both hosts render thin dialogs over the same source-type catalog.

Status 2026-07-07: block-level bibliography content-control fidelity is now shared-first. `45dc2a2bc` adds model metadata for body block content controls, preserves and emits Word bibliography `w:sdt/w:sdtContent` regions with bibliography `docPartObj` metadata, marks generated bibliography regions through `BibliographyRegionPlanner`, counts block controls in save-compatibility evidence, and keeps that metadata through combine/compare/merge/mail-merge transforms. WPF and Avalonia stay thin because they consume the shared document model and bibliography plan.

Status 2026-07-13: nested OfficeMath work has started through narrow shared slots. `d24964d11` adds nested equation numerator/denominator slots for fractions, `91de41490` adds nested radical radicands, `19568dc8b` adds nested delimiter content, `8b7fe1b3a` adds nested function arguments, `69460408b` adds nested n-ary lower/upper/operand slots, `592b5e055` adds nested base/subscript/superscript slots for `m:sSub`, `m:sSup`, and `m:sSubSup`, `daf281698` adds nested decorator base/content slots for accent, bar, and group-char OMML structures, `87e42483b` / `80963aaec` add nested radical degree child math runs, and `7afbb13bd` / `08f3d5857` / `adc10c3c3` add nested matrix and equation-array cell child math runs. The shared model, DOCX reader/writer, and equation visual planner own those slots; WPF and Avalonia continue to consume the shared flattened segment contract plus the nested slot plans without host-specific equation engines.

Status 2026-07-07: floating-object text-wrap planning is now shared-first. `5d57019e1` adds `DocumentFloatingTextWrapLinePlan` for square/tight lateral insets and top-and-bottom Y-band advancement, routes Avalonia wrap emission through that planner, and moves WPF wrap-reservation text-width policy into `DocumentViewLayoutPlanner`. WPF still relies on FlowDocument `Floater` reservations for live editing rather than a full shared line-by-line renderer, but the no-shared-planner gap for modeled square/tight/top-and-bottom floating wraps is closed.

Status 2026-07-07: live Table of Authorities page references are now shared-first through `fdde659bb`. `TableOfAuthorities.Build` keeps its text-only fallback when there is no live layout evidence, but accepts explicit host page references when WPF/Avalonia can locate hidden legal citation marks. WPF now resolves valid single-page live layouts to page 1 instead of dropping page numbers, and Avalonia resolves citation marks from placed run layout rather than only the owning block's first page.

Status 2026-07-07: shared SmartArt layout geometry breadth is integrated through `d04a6573b`. `ChartSmartArtVisualPlanner` now produces stable renderer-neutral geometry/signatures for `cycle1`, `radial1`, `matrix1`, `horizbullet1`, `stepup1`, and `stepdown1`; WPF `SmartArtRenderer` and Avalonia document rendering consume that shared plan through thin renderer paths. This closes the generic-shape fallback for those modeled layout IDs without claiming Word's full SmartArt auto-layout engine.

Status 2026-07-13: comments-only protection/proofing and Mark as Final evidence are now part of the shared visual-evidence contract. `e84689909` records CommentsOnly protection, Restrict Editing checked state, proofing diagnostic preservation, blocked body-edit/body-format/proofing-replace/history commands, and allowed classified comment workflows. `9875df66d` / `93c9f81d` switches the generated review-protection fixture to Mark as Final checked, requires shared manifest validation for that state, blocks editing/proofing/history/comment mutations with `MarkedAsFinal`, and surfaces "Mark as Final checked" in normalized WPF/Avalonia evidence markdown. WPF `FreeW.FidelityRender` and Avalonia `FreeW.PageLayoutShot` emit the shared manifest facts through thin evidence-tool paths. Raw proofing pixel equivalence remains separate work.

Status 2026-07-13: retained-model review safety is now covered for the generated Review Compare/Combine visual proof lane. `DocumentCompare` and `DocumentCombine` copy the revised document's preserved package shell into the result instead of dropping unmodelled settings/custom-property/custom XML state, and the shared visual-evidence manifest records matching WPF/Avalonia retained-safety signatures for `review-compare-visual-proof` and `review-combine-visual-proof`. The no-Word smoke evidence is paired-renderer proof only: Word PNG baselines still require a Word COM-capable machine.

Status 2026-07-07: table-fill and multi-section header/footer image evidence also moved forward through the shared visual contract. `ff1c69434` aligns table effective-fill and style-derived header-fill signatures in `FreeWVisualEvidencePlanner` / `VisualEvidenceManifestNormalizer`, and `1e9cbb3f4` routes the Avalonia `f2-hf-images` page captures through shared section-page surface planning while preserving the selected section's header/footer image slots. These are WPF/Avalonia evidence-trust closures, not real Word PNG baseline claims.

The next parity work should therefore avoid command-count chasing, avoid reopening modeled equation structures as WPF-vs-Avalonia gaps, avoid treating basic bibliography source-type breadth or block-level bibliography content-control regions as still open, treat nested fractions/radical radicands/radical degree/delimiter content/function arguments/n-ary/script/decorator/matrix/equation-array slots as already covered, treat square/tight/top-and-bottom floating text-wrap planning as shared, treat live TOA page-number resolution as covered when a host has live layout/body-mark evidence, treat the six July 7 SmartArt layout IDs as shared geometry rather than host-specific renderer gaps, treat comments-only and MarkedAsFinal protection/proofing command evidence as covered through the shared manifest, treat retained-model review safety as covered for the generated compare/combine proof fixtures, and treat table-fill signatures plus `f2-hf-images` section-page capture as covered evidence plumbing. Remaining value is in stronger visual proof and behavior evidence: real Word-baseline PNG comparison on a machine with Word COM, broader fixture coverage beyond the current mixed-section/table-cell-border/table-fill/header-footer-image/floating object/chart/SmartArt/WordArt/run-decoration/reference-heavy/equation-structures/review-protection-proofing-depth evidence set, high-risk command behavior evidence beyond the current generated evidence rows, file-format honesty/evidence for macro/template preservation and import-only formats, and explicit closure or deferral of remaining engine-limited surfaces such as pixel-faithful equation geometry/spacing, structured bibliography fidelity beyond the block-level region, stronger references-heavy visual/round-trip proof including TOA baselines, deeper floating-object reflow/Word-baseline proof beyond the shared wrap-line contract, additional SmartArt layouts/full auto-layout and Word-baseline comparison, raw proofing-pixel details, editable multi-page/side-to-side layouts, and direct native-printer selection. The Word-baseline summary path now reports baseline ids, candidate paths, status counts, skip reasons, tolerance limits, and changed-pixel metrics when comparison PNGs are available. On this machine Word COM remains unavailable, so integrated `-AllowMissingWord` runs must not be read as full MS Word visual parity.

## Architecture Rule

Every gap must be classified in this order:

1. `FreeW.Core.Model` for semantic document state and commands.
2. `FreeW.Core.IO` for file-format behavior and round-trip semantics.
3. `FreeW.App.Presentation` for host-neutral planners, policies, workflows, and view models.
4. `FreeW.Ribbon.Definitions` for command topology, labels, grouping, contextual tabs, and capability profiles.
5. `Free.Shared.*` only for cross-app infrastructure, never Word-only behavior.
6. WPF/Avalonia renderer or shell realization last.

This is the implementation rule, not just an architecture preference. Word-processing semantics belong in `FreeW.Core.*` or `FreeW.App.Presentation`. Shared infrastructure such as ribbon rendering, shell chrome, file pickers, OPC, themes, drawing helpers, and PDF helpers belongs under `Free.Shared.*` only when it is genuinely cross-app.

## Shared Spine Now Available

Current shared or host-neutral assets relevant to FreeW parity:

- `freew/FreeW.Core.Model`.
- `freew/FreeW.Core.IO`.
- `freew/FreeW.App.Presentation`.
- `freew/FreeW.Ribbon.Definitions`.
- `shared/Free.Shared.Ribbon.Avalonia`.
- `shared/Free.Shared.Ribbon.Wpf`.
- `shared/Free.Shared.Shell.*`.
- `shared/Free.Shared.IO`.
- `shared/Free.Shared.Drawing`.
- `shared/Free.Shared.Theme.*`.
- `shared/Free.Shared.Pdf.*`.
- `shared/Free.Shared.Opc`.

The direction is now "shared first, thin hosts last." WPF should remain the reference and verification oracle, but new WPF-touching work should pay down host-local behavior into shared FreeW planners or definitions when practical. Avalonia should realize the shared command/planner surface and avoid growing a second app engine inside `freew/FreeW.App.Avalonia/Editing/DocumentView.cs`.

## Remaining Gap Model

Treat each WPF-vs-Avalonia delta as one of these classes:

| Class | Meaning | Preferred owner |
| --- | --- | --- |
| Implemented | WPF and Avalonia both expose the command and equivalent behavior. | Generated matrix and behavior tests. |
| Placeholder | Visible command exists but routes to stub, disabled state, or incomplete behavior. | `FreeW.App.Presentation` contract plus thin renderer callback. |
| Semantic gap | Model command/state or file-format behavior is missing or not portable. | `FreeW.Core.Model` or `FreeW.Core.IO`. |
| Planner gap | Behavior exists in WPF-local code and should become host-neutral. | `FreeW.App.Presentation`. |
| Topology gap | Tab/group/contextual command shape differs. | `FreeW.Ribbon.Definitions`. |
| Renderer gap | Shared behavior exists; host cannot display or interact with it yet. | WPF/Avalonia renderer, with focused visual evidence. |
| Platform-only | Correctly host-specific because the OS/UI stack differs. | Host adapter with an explicit reason. |
| Deferred/out of scope | Cloud/account, Developer/macros/VBA/XML mapping, ink/Draw, e-mail-send merge, online media/templates, cloud Translate, or open-ended polish/evidence. | Documented allowlist. |

Prefer behavior/contract tests for new work. Do not add new source-string guard plans except where a guard pattern is already established and directly protects an architectural boundary.

## Prioritized Shared-First Slices

### 1. Generated WPF/Avalonia Ribbon Parity Matrix

Build the FreeW equivalent of the FreeX generated command dashboard. The matrix should read ribbon definitions and command registries, then emit a compact report with command id, tab/group/context, WPF registry state, Avalonia registry state, implementation class, and notes. This replaces all stale hand-counts.

Use it to rank every later slice. Do not start by manually porting a long list from `FreeWRibbonCommands.cs`.

Status 2026-07-02: done for actionable command topology. Continue to run the generator as a guard, but do not open new implementation slices from profile-shape-only rows.

### 2. Backstage Options and Info Safety

Make Backstage Options and Info safety actions honest in both shells. Classify each action through the shared order:

- Core state for document protection, finalization, metadata, accessibility, and inspection facts.
- IO behavior for any saved document flags.
- Presentation planners for pane content, disabled states, warnings, and routing.
- Thin WPF/Avalonia callbacks for dialogs and native shell affordances.

Avoid fake Microsoft account, cloud location, or online service placeholders.

Status 2026-08-14: Backstage Options and Info safety are implemented through shared planners and thin Avalonia callbacks. The Info safety rows read live document state from the shared model, including Mark as Final, protection mode, inspector metadata counts, and accessibility issue counts. Direct printer selection is also closed: Avalonia selects the Windows or CUPS platform print service, discovers queues, collects a shared `PrintSelection`, renders a page-settings-aware PDF through `FreeWPortablePrintWorkflow`, and submits it to the selected queue. A native operating-system print panel is still platform-specific polish, not a missing direct-print workflow.

### 3. Print Preview and Print Planning

Use WPF as the behavior oracle, then move print preview and print decisions into host-neutral presentation policy where possible: page setup summaries, preview mode state, export vs print routing, safety prompts, and evidence fixture selection.

Avalonia should implement the same policy through its Skia/PDF and print surfaces. Do not bury print behavior in `DocumentView.cs` unless it is strictly renderer geometry.

Status 2026-07-03: Print pane capability/status is now shared through `BackstageDirectPrintCapability`. WPF's native `PrintDialog` path is classified as host-backed by the shared planner. Avalonia has backed Print Preview plus a clearly labeled Create PDF fallback from the preview toolbar, while direct native printer selection remains deferred because the current Avalonia target exposes no native `PrintDialog` or printer service.

Status 2026-07-03: Backstage print evidence contracts are hardened on `origin/main` (`1d6df5241`, worker `8a13d769f`). The evidence checks now assert the shared direct-print capability/status contract and the honest Avalonia fallback shape, so future Backstage print changes should update that contract rather than reintroducing host-local status drift.

Status 2026-07-03: Backstage print/export visual evidence now requires real capture-source metadata in the normalized summary path. `FreeW.VisualEvidenceSummary` rejects metadata-only Backstage rows even when the PNG file exists: WPF Backstage rows must declare either the composite renderer or the explicit software renderer capture source, Avalonia Backstage rows must declare the Avalonia render-target capture source, and placeholder/fallback capture metadata remains a failed row that removes the page from trusted pair coverage. This keeps the dashboard claim honest: missing real captures fail the summary instead of being inferred from manifest shape alone.

### 4. References, Source Management, and Table of Authorities

Close the references family by separating semantic document data from UI:

- `FreeW.Core.Model` for bibliography sources, citations, authorities, captions, footnotes/endnotes, cross-reference anchors, and generated fields.
- `FreeW.Core.IO` for DOCX read/write and round-trip preservation.
- `FreeW.App.Presentation` for source-management, cross-reference, citation style, table-of-authorities, and update planners.
- WPF/Avalonia dialogs as thin views over those planners.

Status 2026-07-03/04: cross-reference Update Fields behavior is now shared through `FreeW.Core.Model.CrossReferences` and consumed by both WPF and Avalonia document views. Source entry is also type-aware through the shared source-management planner for the three modeled source types. Mark Citation category/short-citation entry is now shared through `MarkCitationDialogPlanner` and rendered by thin WPF/Avalonia dialogs. In-text personal-author display is normalized in shared `Citations.FormatInText`, closing the known APA surname-only gap while preserving corporate/ambiguous strings. Tagged citation insertion and Update Fields now flow through shared `CITATION` complex-field runs, and generated bibliography/reference-list refresh uses shared planning. Later July 7 tranches completed the targeted Word/OOXML source-type breadth, preserved block-level bibliography content-control regions, and added live TOA page references when host layout can locate the citation mark. Remaining references depth should focus on structured bibliography fidelity beyond that block-level region, richer master-source-library semantics, and real visual/round-trip evidence for references-heavy documents rather than reimplementing cross-reference refresh, source-entry field policy, Mark Citation validation, citation-field resolution, source-type breadth, TOA live page-number resolving, or bibliography-region planning in host code.

Status 2026-07-04: Table of Authorities output/refresh region planning moved into shared presentation policy. `TableOfAuthoritiesRegionPlanner` now owns generated paragraph planning, stale TOA paragraph deletion indices, insertion position, option propagation, and style registration; WPF and Avalonia execute that plan through their own command buses. The host-visible parity improvement is that Refresh Table of Authorities now behaves like Insert when no TOA region exists, placing the generated table at the document end in both hosts instead of Avalonia inserting it at the top of the document.

Status 2026-07-04: IEEE/Vancouver numeric citation display is now shared in `FreeW.Core.Model.Citations`. WPF and Avalonia insertion paths call the document-aware formatter, so numeric in-text citations use source-order markers like `[1]` / `[2]` and repeated source tags reuse the same number. Numeric bibliography/reference-list output also keeps source order and prefixes entries with the assigned marker. The remaining limitations at that point were live Word `CITATION` / `BIBLIOGRAPHY` field semantics, automatic renumbering of already-inserted visible text after source edits, full Word structured bibliography fidelity, and real references-heavy visual/round-trip evidence; `45dc2a2bc` supersedes the block-level bibliography content-control part of that structured-bibliography gap.

Status 2026-07-04: live citation field/update-fields parity is implemented as a shared-first slice. Tagged Insert Citation paths now create Word-like `CITATION <tag>` complex-field runs in both WPF and Avalonia, while untagged sources keep the existing plain-text fallback. `ComplexFieldEngine` recomputes those fields from `TextDocument.Sources` and the current `BibliographyStyle`, preserving cached text when a source tag is missing/deleted, so IEEE/Vancouver citation fields renumber after source-order changes on Update Fields. Generated bibliography/reference-list regions now use shared `BibliographyRegionPlanner` insert/refresh planning in both hosts, and `45dc2a2bc` now preserves the block-level bibliography content-control wrapper for those regions. `fdde659bb` adds live TOA page references when host layout can locate the hidden legal citation mark. Remaining references limits are structured bibliography fidelity beyond the block-level region, richer master-source-library semantics, and real references-heavy visual/round-trip evidence.

Status 2026-07-04/07: references-heavy visual evidence is now part of the shared generated-corpus contract. The new `references-heavy-fields` fixture exercises typed bibliography sources, visible `CITATION`, `BIBLIOGRAPHY`, and cached `TOA` complex fields, generated bibliography paragraphs, hidden legal-authority marks, and generated Table of Authorities paragraphs. WPF `FreeW.FidelityRender`, Avalonia `FreeW.PageLayoutShot`, `FreeW.VisualEvidenceSummary`, and the Word-baseline generation plan now expect paired evidence for this scenario. The live TOA page resolver slice (`fdde659bb`) closes the shared product blocker when host layout can locate citation marks; remaining references-heavy work is stronger rendered/round-trip and real Word PNG baseline proof.

Status 2026-07-04/07: the visual evidence summary reports references-heavy TOA page references as machine-checkable data. `freew_visual_evidence_summary.json` schema v17 includes `remainingEvidenceBlockers`; when `references-heavy-fields` has trusted WPF/Avalonia evidence, the summary records semantic generated-TOA page-reference evidence (for example, `Example v. FreeW -> 1, 2`) and still reports whether real MS Word PNG baselines are available. If the semantic TOA page-reference metadata is missing, the blocker is reported as a shared product/evidence-contract gap instead of being hidden behind Word COM availability. `fdde659bb` closes the live resolver part of that blocker for host-backed layouts, while the explicit external Word-baseline blocker remains so no-Word runs do not imply Microsoft Word visual parity.

### 5. Review Depth: Proofing, Thesaurus, Protection, Compare/Combine

Treat Review features as policy first. Shared planners should own available actions, state, document mutations, conflict messages, and allowlists. Host shells should provide only the UI realization, file pickers, and visual markers.

Prioritize proofing/thesaurus/protection/compare-combine where WPF already proves user-facing behavior and Avalonia can reuse the semantic/planner contract.

Status 2026-07-03: Compare/Combine execution is implemented for Avalonia through `ReviewCompareCombineWorkflow` plus thin file-picker/dialog callbacks. Remaining Review-depth work should focus on proofing/protection evidence and any behavior still not proven by focused tests, not on these two command callbacks.

Status 2026-07-03: Thesaurus behavior parity is implemented through shared presentation planning plus thin host realization. Avalonia supports synonym Replace from the shared planner, and WPF retains the richer Insert/Copy pane actions. Integrated validation observed: presentation 3/3, WPF 15/15, Avalonia 41/41.

Status 2026-07-03: Proofing language behavior has moved further into shared presentation policy. The caret/no-selection path now preserves Word-like typing intent by updating caret language state, selected ranges still apply through the shared run-formatting path, and the proofing language dialog planner records the backed dialog options/apply intent for both hosts. Remaining Review-depth proofing work should focus on evidence and behavior not yet proven by those shared contracts, not on duplicating language-apply logic in host code.

Status 2026-07-03: protection now guards undo/redo history mutation through shared policy in both hosts. The next shared-policy slice adds typed history classification for the FreeW command bus: comments-only protection allows undo/redo for classified comment entries while still blocking body-edit, body-formatting, mixed, or unknown history entries. Avalonia comment insert/reply/resolve/delete commands are classified through the shared bus, and WPF consumes the same policy for classified command-bus history while preserving native RichTextBox undo/redo as unknown generic history. Remaining blocker: WPF's native text undo stack is still not introspectable at per-entry depth, so any native WPF history that is not routed through the shared command bus remains conservatively blocked under comments-only protection.

Status 2026-07-04: comments-only protection history classification evidence is refreshed on `codex/freew-comments-protection-history-20260704`. The shared policy test now proves unknown history remains blocked, and the Avalonia protection test proves classified comment insert, reply, resolve, and delete history entries can each undo/redo under comments-only protection while the existing body-history case remains blocked. Product behavior was already shared through `RestrictEditingEnforcementPolicy`; the remaining limitation is unchanged: WPF native RichTextBox text undo/redo entries are generic/unknown unless they came through the shared command bus, so they stay conservatively blocked under comments-only protection.

Status 2026-07-13: comments-only protection/proofing and Mark as Final evidence are refreshed through the shared visual manifest (`e84689909`, `9875df66d`, `93c9f81d`). WPF and Avalonia now report the same fixture facts for protection state, proofing diagnostics, blocked body/proofing/history/comment mutations, classified comment workflows where allowed, and Mark as Final checked state. The remaining review limitation is no longer absence of shared evidence for CommentsOnly or MarkedAsFinal; it is WPF native RichTextBox history introspection, retained-model review safety, and raw proofing-pixel differences.

### 6. Read, Split, and Window Behaviors

Classify view/window behavior carefully because some WPF implementation details are UI-stack-specific. Put durable policy in `FreeW.App.Presentation`: mode availability, pane relationships, zoom/read-state decisions, split-window lifecycle, and window-management intent. Let WPF and Avalonia realize those intents through host adapters.

Status 2026-07-03: View-depth shared policy now covers the backed subset plus Side-to-Side page-pair navigation. `FreeW.App.Presentation.Shell.FreeWViewDepthPlanner` owns mode exclusivity, preview intent, read-only limitations, the two-page-fit target, and read-only pair navigation for WPF and Avalonia; each `MainWindow` only swaps the host workspace. Integrated validation observed: presentation 15/15, WPF 21/21, Avalonia 21/21. Remaining limitation: the secondary split pane and page-preview modes are read-only snapshots, Multiple Pages is not yet an editable responsive page grid, and editable horizontal Side-to-Side page view remains deferred.

### 7. Visual Parity Capture

Create an evidence loop for the remaining visual/fidelity work. The minimum capture set should exercise:

- Pagination and page geometry.
- Tables, including styles, borders, sizing, and cell text direction.
- Floating objects, z-order, wrap modes, and grouping.
- Headers/footers and footnotes/endnotes.
- Charts.
- SmartArt.
- WordArt and watermark.
- Equations and OfficeMath structures.

Prefer a small fixture matrix with WPF and Avalonia output side by side, plus source-backed notes for expected differences. The 2026-06-25/26 FreeW visual reports in `docs/fidelity` are the current WPF evidence baseline; extend from there instead of treating their old harness blind spots as product blockers.

Status 2026-07-03/04: shared contract expanded and the fallback path is integrated. The latest local `tools/Run-FreeWWordBaselineEvidence.ps1 -AllowMissingWord` pass rendered 19 DOCX fixtures / 31 WPF outputs through the explicit software fallback and `FreeW.VisualEvidenceSummary` reported 60 trusted evidence rows plus 60 baseline comparison rows. Because Word COM is unavailable on this machine, comparison status was `skipped=14` and `word-baseline-unavailable=46`; no real Word PNGs were generated. The generated-corpus plan has since grown to 25 fixtures, including `references-heavy-fields` and `equation-structures`; the latest no-Word generated-corpus validation path wrote those DOCX fixtures while still treating Word baselines as unavailable on this machine. The evidence set includes the existing paired footnote/endnote placement, section geometry, table layout and custom cell-border planning, drawing objects, chart/SmartArt composition, WordArt/watermark stress coverage, run-decoration border/shading scenarios, the integrated field page-number visual scenario, the references-heavy field scenario, and the equation-structures scenario. The integrated drawing-effects contract (`006988bfe`) proves top-level effect-bearing objects in WPF/Avalonia evidence summaries and manifests: `drawing-objects-complex` reports 3 effect objects across shape shadow, image shadow/glow/reflection/artistic effect, and WordArt glow; `wordart-watermark-stress` reports 2 across shape shadow and WordArt glow. The grouped-child evidence slice now promotes the `drawing-objects-complex` group child shape glow (`GroupChild0:Shape:glow`) to paired trusted WPF/Avalonia rendered evidence only when both host manifests agree on the same child summary; this remains renderer evidence, not a real Word PNG parity claim. The integrated note-region planner slice (`6e7c6f6ac`) upgrades the F2 footnote/endnote captures from metadata-only note flags to visible note rows: WPF draws the shared plan through `PageBox` and `FreeW.FidelityRender`, and Avalonia overlays the same `DocumentNoteRegionPlanner` output in `FreeW.PageLayoutShot` for `f2-footnotes` and the synthetic `f2-endnotes` page. WPF has true `f2-section-landscape` portrait/landscape page dimensions; Avalonia renders that scenario through shared section-surface page slices, so its evidence rows carry mixed portrait/landscape capture dimensions, section ownership, and section-page-surface metadata. The table cell-border planner slice (`6e8532452`) closes the previous WPF/Avalonia renderer split for dashed, dotted, double, thick, and mixed-color explicit cell borders through a shared presentation plan plus thin host drawing. The next visual increment should use that oracle to prioritize real Word-baseline pixel comparison rather than inventing a parallel harness.

Latest grouped-child drawing-effect evidence update: the visual-evidence schema now separates top-level claimed drawing effects, rendered grouped-child effects, and still-planned grouped-child effects. The shared `drawing-objects-complex` fixture records 3 claimed top-level effect objects and 1 rendered grouped child effect (`GroupChild0:Shape:glow`) when WPF and Avalonia both report the same child summary. This closes the prior planned-only WPF/Avalonia grouped-child evidence gap for the shape-glow fixture. `d04a6573b` later adds shared SmartArt geometry for `cycle1`, `radial1`, `matrix1`, `horizbullet1`, `stepup1`, and `stepdown1`; broader grouped DrawingML, further SmartArt layout breadth/full auto-layout, and real Word pixel comparison remain open visual-parity work.

Status 2026-07-13: the equation visual-evidence path is now part of the same shared-first loop. The `equation-structures` fixture exercises the modeled OfficeMath structures that the lightweight shared planner supports, and both hosts consume that planner rather than carrying separate equation render logic. Nested fraction numerator/denominator slots are modeled and round-tripped through `d24964d11`; nested radical radicands are modeled and round-tripped through `91de41490`; nested delimiter content is modeled and round-tripped through `19568dc8b`; nested function arguments are modeled and round-tripped through `8b7fe1b3a`; nested n-ary limits and operands are modeled and round-tripped through `69460408b`; nested script base/subscript/superscript slots are modeled and round-tripped through `592b5e055`; nested accent/bar/group-char base slots are modeled and round-tripped through `daf281698`; nested radical degree child runs are modeled and round-tripped through `87e42483b`; nested matrix/equation-array cell child runs are modeled and round-tripped through `7afbb13bd` and `08f3d5857`. Remaining equation visual work should be scoped as Word PNG baseline comparison and equation geometry/spacing fidelity; it should not create a second Avalonia-specific equation engine or treat each already-modeled `MathRunKind` as a new command/topology gap.

Status 2026-07-07: the floating-object wrap planner is also shared-first. `DocumentFloatingTextWrapLinePlan` now represents square/tight line insets and top-and-bottom band advancement in `FreeW.App.Presentation`; Avalonia consumes that plan for line width and emission, and WPF consumes the shared reservation-width policy with focused evidence that square/tight/top-and-bottom wraps produce non-overlapping shared metadata. Remaining floating-object visual work is now stronger Word-baseline/pixel proof and deeper renderer behavior, especially WPF's live FlowDocument `Floater` dependency, not duplicate wrap math in host code.

Status 2026-07-14: floating-wrap all-up evidence runner drift is closed. The generated Word-baseline corpus now writes and renders the WPF `f2-01-float-wrap` fixture through shared `FreeWVisualEvidenceDocumentFactory.BuildFloatingWrapEvidenceDocument`, so the normalized no-Word summary reports the floating-wrapping proof row as paired-renderer-ready instead of missing WPF evidence. This remains paired WPF/Avalonia evidence only; on machines without Word COM, the Word PNG baseline row stays explicitly `word-baseline-unavailable`.

Status 2026-07-07: table fill and multi-section header/footer image evidence are now stronger in the no-Word WPF/Avalonia path. `ff1c69434` keeps table cell fill signatures and style-derived header fill signatures aligned through the shared planner/normalizer, while `1e9cbb3f4` moves Avalonia `f2-hf-images` page 1/2 capture to section-page surfaces so page 2 cannot silently pass as a blank desk capture. This closes the immediate evidence-trust issue Carver exposed; real Word pixel comparison is still the authority for final visual parity.

## WPF Work Rule

WPF is complete for Microsoft Word in-scope parity and should not be churned just to match Avalonia. Touch WPF only when:

- It supplies reference behavior/evidence for a matrix row.
- A WPF-local behavior must be extracted into `FreeW.Core.*`, `FreeW.App.Presentation`, or `FreeW.Ribbon.Definitions`.
- A regression or false parity claim is found by the generated matrix or visual evidence loop.

## Avalonia Work Rule

Avalonia should catch up by realizing the shared surface:

- Use `FreeWAvaloniaRibbonCommands.cs` for command wiring.
- Use `FreeW.Ribbon.Definitions` for topology and capability profiles.
- Use `FreeW.App.Presentation` planners before adding shell logic.
- Keep `DocumentView.cs` focused on rendering, hit-testing, and editing mechanics.
- Add renderer features behind focused behavior and visual tests, not as broad rewrites.

## Validation Plan For Future Implementation

For each implementation slice:

1. Regenerate or update the FreeW WPF/Avalonia command matrix.
2. Add behavior/contract tests at the lowest shared layer that owns the behavior.
3. Add WPF/Avalonia host tests only for renderer or shell realization.
4. Add visual capture when the slice affects layout, rendering, pagination, floating objects, or dialogs.
5. Run the focused project tests plus the repo preflight required by `AGENTS.md` before integration.

This documentation refresh did not change product or test code.
