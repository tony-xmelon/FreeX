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

## Current July 2 Update

The command-surface phase is now exhausted for actionable WPF/Avalonia deltas. The generated FreeW command inventory reports `797` total commands with `0` actionable WPF gaps, `0` actionable Avalonia gaps, and `0` total actionable gaps. Raw `wpfOnly` / `avaloniaOnly` counts still include profile-shape, alias, deferred, and platform-specific rows; they are not implementation targets by themselves.

The July 2 implementation wave also landed the last ready command-functional salvage slice (`freew.edit-hyperlink`, `freew.remove-hyperlink`, `freew.hyperlink-tooltip`, and `freew.link-bookmark`) and expanded the shared WPF/Avalonia visual evidence contract. `FreeW.App.Presentation` now owns visual evidence scenario identity, schema, expected output names, page geometry, section ownership, columns, page border, watermark, header/footer and notes expectations, table/drawing/chart/SmartArt expectations, and the nonblank/pixel-diversity trust contract. WPF `FreeW.FidelityRender` and Avalonia `FreeW.PageLayoutShot` now emit the same manifest shape while keeping renderer code host-thin.

The same wave closed the style-management planner gap by moving New Style / Modify Style / Manage Styles option planning, validation, row sorting, and reversible style-catalog mutation into shared layers (`StyleDialogPlanner` in presentation and `StyleCatalogCommand` in core model). WPF and Avalonia now act as thin dialog/rendering shells over the shared behavior.

The next parity work should therefore avoid command-count chasing. Remaining value is in deeper proof: Word-baseline visual comparison, broader fixture coverage beyond the current mixed-section/table/floating object/chart/SmartArt/WordArt evidence set, and behavior evidence where a command exists but Word-like results are still only weakly proven. The Word-baseline summary path now reports baseline ids, candidate paths, status counts, skip reasons, tolerance limits, and changed-pixel metrics when comparison PNGs are available.

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

### 3. Print Preview and Print Planning

Use WPF as the behavior oracle, then move print preview and print decisions into host-neutral presentation policy where possible: page setup summaries, preview mode state, export vs print routing, safety prompts, and evidence fixture selection.

Avalonia should implement the same policy through its Skia/PDF and print surfaces. Do not bury print behavior in `DocumentView.cs` unless it is strictly renderer geometry.

### 4. References, Source Management, and Table of Authorities

Close the references family by separating semantic document data from UI:

- `FreeW.Core.Model` for bibliography sources, citations, authorities, captions, footnotes/endnotes, cross-reference anchors, and generated fields.
- `FreeW.Core.IO` for DOCX read/write and round-trip preservation.
- `FreeW.App.Presentation` for source-management, cross-reference, citation style, table-of-authorities, and update planners.
- WPF/Avalonia dialogs as thin views over those planners.

### 5. Review Depth: Proofing, Thesaurus, Protection, Compare/Combine

Treat Review features as policy first. Shared planners should own available actions, state, document mutations, conflict messages, and allowlists. Host shells should provide only the UI realization, file pickers, and visual markers.

Prioritize proofing/thesaurus/protection/compare-combine where WPF already proves user-facing behavior and Avalonia can reuse the semantic/planner contract.

### 6. Read, Split, and Window Behaviors

Classify view/window behavior carefully because some WPF implementation details are UI-stack-specific. Put durable policy in `FreeW.App.Presentation`: mode availability, pane relationships, zoom/read-state decisions, split-window lifecycle, and window-management intent. Let WPF and Avalonia realize those intents through host adapters.

### 7. Visual Parity Capture

Create an evidence loop for the remaining visual/fidelity work. The minimum capture set should exercise:

- Pagination and page geometry.
- Tables, including styles, borders, sizing, and cell text direction.
- Floating objects, z-order, wrap modes, and grouping.
- Headers/footers and footnotes/endnotes.
- Charts.
- SmartArt.
- WordArt and watermark.

Prefer a small fixture matrix with WPF and Avalonia output side by side, plus source-backed notes for expected differences. The 2026-06-25/26 FreeW visual reports in `docs/fidelity` are the current WPF evidence baseline; extend from there instead of treating their old harness blind spots as product blockers.

Status 2026-07-02: shared contract expanded. The current smoke path generates 17 F2/page-composition DOCX fixtures, WPF renders 35 PNGs, Avalonia renders 22 PNGs, and `FreeW.VisualEvidenceSummary` combines them into 57 trusted evidence rows. It now includes paired footnote/endnote placement, section geometry, table layout, drawing objects, chart/SmartArt composition, WordArt-over-watermark stress, and WordArt plus picture-watermark layout stress evidence. Word-baseline comparison is attached to the same manifest path: the runner can consume an existing Word PNG root or generate one with `-IncludeWordBaseline`, and the shared policy aliases comparable Avalonia rows to F2 baselines while marking unmapped or out-of-scope rows as skipped. If Word COM is unavailable, `-AllowMissingWord` now records `word-baseline-unavailable` comparison rows instead of dropping the baseline section or failing trust; a forced no-Word run reported `skipped=4, word-baseline-unavailable=53`. WPF has true `f2-section-landscape` portrait/landscape page dimensions; Avalonia now renders that scenario through shared section-surface page slices, so its two evidence rows carry mixed portrait/landscape capture dimensions, section ownership, and section-page-surface metadata. The next visual increment should use that oracle to prioritize Word-baseline pixel comparison rather than inventing a parallel harness.

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
