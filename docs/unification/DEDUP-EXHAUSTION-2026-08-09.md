# Dedup Exhaustion Report - 2026-08-09

> **Status: ACTIVE CAMPAIGN, INTEGRATION CHECKPOINT.** The current integrated implementation tip is
> `42e6ca0ca5f6028febf0a8fd8e541328351f19ae`. Substantial renderer and workflow ownership has moved into
> shared or product-portable tiers, but the residual audit still contains implementable scope. This report
> does not claim that scope is exhausted or that final validation has passed.

## Scope and evidence

This report tracks the continuing dedup campaign on `codex/dedup-exhaustion-rescue-20260810`. The branch was
synchronized with upstream at `7099fcdf2dda6cd64721651f838a403f742089e4`; the current documentation
checkpoint includes all integrated dedup work through `42e6ca0ca5`.

The generated [residual metrics](dedup-residual-metrics.md) remain the historical measurement produced for
analysis commit `ad826713286f358f170fa1a7ba6b838d9af209a1` and committed in `fd07a9db50d315a1a9b5dc0c68eaaed7b3da7a81`.
They have intentionally not been regenerated during active integration and must not be interpreted as a
measurement of `42e6ca0ca5`. Regeneration belongs to the final synchronized verification pass.

The interpretation follows the [program principles](README.md), [architecture roadmap](ROADMAP.md),
[historical backlog](DEDUP-BACKLOG.md), generated residual evidence, and [execution log](LOG.md). Commit
references below are representative ownership anchors rather than a complete changelog.

## Current and desired architecture

| Layer | Current checkpoint | Desired state |
|---|---|---|
| Product domain | FreeX cells/formulas, FreeW paragraphs/runs, and FreeP slides/shapes retain distinct models and format semantics. | Keep genuine document-domain and XLSX/DOCX/PPTX differences product-owned. |
| Focused portable workareas | `FreeX.App.Presentation` / `FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own most workflow, validation, layout, and command policy. A small audited tail is still moving out of native hosts. | Each app exposes one focused workarea containing all renderer-neutral product decisions. |
| Shared application frame | Portable `Free.Shared.*` projects own ribbon, Backstage, lifecycle, URI launching, protection hashing, Legal Notices presentation, common geometry, localization mechanics, theme, drawing/OPC/PDF primitives, and test infrastructure. | Cross-product application-frame policy is implemented once, with product descriptors supplying text and capabilities. |
| Native renderers | WPF and Avalonia mostly construct controls, translate native input, project portable plans, apply effects, and manage native lifetime. Audited FreeX, FreeW, and FreeP policy residuals remain. | Native hosts are thin realizers with no duplicated validation, workflow, semantic text, or portable geometry decisions. |

The target is one portable decision path feeding two native realizations. It is not source-identical WPF and
Avalonia trees, and it does not collapse the three real document domains into a false common model.

## Campaign coverage before the current continuation

The earlier campaign checkpoint had already established broad shared ownership across the originally
identified scope. The continuation below extends this base; it does not replace it.

| Area | Integrated campaign result | Representative history |
|---|---|---|
| Adaptive ribbon and ribbon shell | Adaptive WPF measurement, fallback, collapsed-group overflow, icon/style mechanics, keytip traversal, command profiles, registries, invocation, and contextual policy moved into shared or portable owners. Renderers retain control creation and measurement application. | `94bf9bb265`, `15b3885bb6`, `f489d50bc6`, `c12ce7cf52`, `dd59111e7b` |
| Backstage and application frame | Shared pane workflows, recent-file projection, print state, application command routing, and FreeW/FreeP/FreeX frame sessions replaced renderer-owned decisions. | `12352a509e`, `fcc360ac14`, `0401a323b2`, `6b8e258750`, `617eaa8618` |
| File I/O, print, and export | Resolved-save and path policy, file-format projection, recovery offers, file command orchestration, print selection/session workflow, CUPS/printer discovery, export picker planning, and renderer routing were centralized. Native pickers, OS printing, and final file effects stay in platform adapters. | `ef7ca9c590`, `321cd9e6a2`, `f6aee134b1`, `959f221b93`, `cf1ffca5ee`, `90db738918`, `f8f9cca5fb` |
| Main editor and status | Workbook, document-editor, presentation-workarea, and application-frame sessions own portable command/state transitions. Status display/options flow through shared models and a portable FreeX update workflow; native bars and editors project state and events. | `3c38b5ee29`, `58eda0a80b`, `65c9a5bc7e`, `a06faa6204`, `617eaa8618` |
| Localization and resources | Shared resource mechanics, catalog metadata, common shell text, About/legal resources, and thin localization facades replaced infrastructure copies. Product wording and localized catalog context remain product-owned. | `d0450c7d3f`, `d4f32dcefe`, `fce1268b87`, `dc1a6d71ee`, `2a295d6aa8`, `f05216fd53` |
| Dialogs | FreeX range-selection lifecycle, FreeW reference/formatting/options/document dialogs, and FreeP chart/slideshow/layout/hyperlink/form dialogs moved validation, commit policy, sessions, action catalogs, and typed schemas into portable tiers. WPF/Avalonia controls and modal lifetime remain native. | `fff17b7acf`, `64319d5647`, `ae9ec58c0b`, `8f6314bb16`, `467648ee61`, `0c866df67a` |
| QuickAnalysis, PageLayout, charts, tables, text boxes, and shapes | FreeX selection and conditional-format policy, PageLayout workflows/outcomes, chart commands, structured-table selection/overlap, text-box editing, and drawing drag/completion moved out of renderer event handlers. FreeW table-border endpoint projection plus FreeP chart-marker and selection-adorner geometry also moved portably. | `7e91e91ae2`, `18df014f7a`, `f8fbee3708`, `9b194796bb`, `a454b8933b`, `55d4adb72d`, `7d77db7196`, `50f48c1aca`, `ba00a89312`, `ec3faa3ee4` |
| Sister-app startup and chrome | FreeW startup/recovery policy, shared Avalonia Backstage/ribbon chrome, launch-smoke bootstrap, and sister-app shell behavior converged while executable startup and native window creation stayed local. | `6fbbde4093`, `959f221b93`, `955c2a7897` |
| Renderer planning | Portable geometry, text layout, render commands, pane/slideshow policy, and workarea sessions feed FreeX/FreeW/FreeP renderers. Native canvas, drawing-context, accessibility, and animation realization remain renderer responsibilities. | `85b3c78807`, `d07cd19a63`, `2090efa777`, `df74a01411`, `9d98939999`, `320fd70985`, `649a373a1c`, `ba00a89312`, `ec3faa3ee4`, `3b149d3878` |
| Test and evidence infrastructure | Repository/source locators, temporary resources, localization contracts, evidence workflow, ownership guards, and deterministic residual measurement were consolidated. Product scenarios and framework-specific capture drivers remain separate where they exercise different native stacks. | `ac51cbf3be`, `ef17eb6297`, `8a11d2a9f0`, `f05216fd53`, `9c428f2f1c`, `7f7506e5d0`, `5c56d0198c`, `8fc243fc79`, `ad82671328`, `fd07a9db50` |

## Integrated continuation through `42e6ca0ca5`

| Area | Integrated ownership change | Commits |
|---|---|---|
| FreeX renderer integration | Centralized read-only workbook sessions, structural viewport shifts, shrink-to-fit sizing, A1/date display routing, and print-directory text so WPF and Avalonia project the same decisions. | `c182a994fb` |
| FreeX core and formatting | Centralized numeric precision, chart-series column mapping, Excel column-width conversion, culture-aware date entry, color parsing, and scalar display formatting across input, IO, model, calc, and dialogs. | `7d2fd2865e`, `ba7f1254cd` |
| FreeX typed localized validation | Added the portable `LocalizedTextDescriptor` foundation plus typed Advanced Filter validation/focus output and Backstage account text resolution. This is an integrated partial, not completion of all audited dialog and semantic-text migrations. | `7eaff8971a` |
| Shared cross-product utilities | Added one desktop external-URI launcher for FreeX/FreeP and FreeW adoption paths, one OOXML protection password hash implementation for FreeX/FreeW, shared directional-arrowhead and WordArt foreground policies, and shared Legal Notices presentation/section models with product descriptors and thin WPF/Avalonia renderers. | `dcdecbf185`, `dc444a4360`, `96c9a5c594`, `feaf0e2527` |
| FreeW pagination and rendering | Moved generated-reference pagination context, reference editing coordination, and table-cell border visual planning out of WPF/Avalonia rendering code. | `dbc8e216af` |
| FreeW application workflow and dialogs | Centralized application-frame/data-folder descriptors, shell text, document-properties input capture, comment-initials policy, style planning, zoom planning, and desktop URI routing contracts. Native dialogs now gather/project values around portable sessions. | `cfdc42febb` |
| FreeP canvas and table layout | Centralized pointer/gesture interaction planning and inline-table logical row projection used by both WPF and Avalonia. | `d283932f2b` |
| FreeP Backstage and lifecycle | Added a portable presentation file-lifecycle adapter, shared Backstage action binding and automation-ID token composition, and portable print-surface state. | `612863ee39` |
| FreeP panes and workarea | Centralized pane accessibility, pane text resources, review/workarea semantics, selection/design/table-insertion planning, and application-frame descriptors. | `f986e18fef` |
| FreeP header/footer dialog | Expanded `HeaderFooterDialogSession` to own field projection, enabled state, input capture, apply semantics, focus, and select-all behavior for both renderers. | `42e6ca0ca5` |
| Ownership/readiness tests | Updated macOS readiness checks to recognize shared ownership and exercise the real source tree. | `9e834098f3` |

## Verification ledger

Verification recorded while producing the integrated slices is intentionally uneven because several agent
lanes were integration-first and reserved broad gates for the final synchronized tree.

| Slice | Recorded result |
|---|---|
| macOS readiness ownership (`9e834098f3`) | Real readiness script passed across 1,012 source files. |
| FreeX color/scalar formatting (`ba7f1254cd`) | 71 focused service tests and 2 Avalonia tests passed. |
| Shared protection hashing (`dc444a4360`) | Focused helper and ownership tests passed. |
| FreeP canvas/table planning (`d283932f2b`) | Focused FreeP builds and tests passed. |
| FreeX renderer integration (`c182a994fb`) | Focused runs passed: Services 36, Presentation 4, WPF UI 1, Avalonia 20, viewport 5, read-only 5, and Host 6. |
| FreeX core policies (`7d2fd2865e`) | Touched FreeX projects built successfully; the Core.Model test rerun was cancelled after import fixes and remains pending. |
| FreeP Backstage/lifecycle (`612863ee39`) | FreeP/FreeW Presentation, Host, and Avalonia builds passed; focused tests mostly passed, with one FreeW presentation run interrupted. |
| FreeW pagination/border (`dbc8e216af`) | 14 focused presentation tests passed; border tests, renderer source guards, and a broader build remain pending. |
| FreeP pane/workarea (`f986e18fef`) | `FreeP.App.Presentation` built successfully; focused tests were not completed. |
| Typed validation, renderer utilities, FreeW workflow/dialogs, Legal Notices, and FreeP header/footer (`7eaff8971a`, `96c9a5c594`, `cfdc42febb`, `feaf0e2527`, `42e6ca0ca5`) | No completed build/test run was recorded before integration; their focused and broad verification is intentionally pending. |

No build or test command is run by this documentation-only lane.

## Historical measurable renderer reduction

The deterministic checkpoint in [dedup-residual-metrics.md](dedup-residual-metrics.md), committed by
`fd07a9db50`, measured the eight configured renderer roots from merge base
`e1225af9b1689b39050f8154774c2a097b92af95` to analysis commit
`ad826713286f358f170fa1a7ba6b838d9af209a1`:

| Scope | Files changed | Added | Deleted | Net C# LOC |
|---|---:|---:|---:|---:|
| All C# | 1,750 | 135,195 | 81,030 | **+54,165** |
| Renderer C# | 460 | 26,618 | 63,352 | **-36,734** |

At that historical checkpoint, the renderers contained 309,986 measured code lines. Cross-root duplicate
coverage was 11,205 lines (3.614679%) for exact windows and 11,963 lines (3.859207%) for normalized windows.
These values demonstrate campaign direction but do not include the continuation integrated through
`42e6ca0ca5`.

## Current residual audit

The latest adversarial and cross-app audits still identify practical portable ownership. The active residual
categories are:

- **FreeX typed validation and semantic text.** Complete the dialog validation/focus descriptor migrations,
  Manage Conditional Formats text resolution, threaded-comment localization, semantic-ID catalogs, and the
  remaining small zoom-validation fallback.
- **FreeW document projection and catalog policy.** Centralize the equation preset catalog, canonical table-grid
  projection, list-marker sequencing, heading style-token projection, and native-selection range projection;
  finish adopting the shared comment-initials and style-planning contracts at older Ribbon/DocumentView sites.
- **FreeP slideshow and media orchestration.** Move mask timelines, caption/fullscreen geometry, OLE activation
  routing, and media-pane orchestration into portable coordinators.
- **FreeP semantic projection cleanup.** Consolidate remaining dialog automation-ID composition and review/table
  display-string composition where they encode policy rather than native control construction.
- **Integration and evidence.** Re-run ownership guards and the interrupted/unrun focused tests, regenerate the
  residual metrics at the final SHA, execute all required gates serially, and compare FreeX WPF visual evidence
  with the clean pre-campaign baseline.

The audit may retire a candidate after inspection when it is only native control construction, framework event
adaptation, drawing-context projection, accessibility attachment, window lifetime, or deliberately parallel
visual-evidence setup. Such classification must be recorded from the final tree rather than assumed from the
historical metrics.

## Extraction rule

A lexical match is practical portable logic when it represents the same decision independent of framework:
validation/defaulting, state transition, command construction, workflow ordering, option/session schema,
portable geometry/layout planning, or a shared package/service rule. Extract it when there is a stable neutral
contract, at least two real consumers (or an imminent sister-app consumer), and behavior can be tested without
loading WPF or Avalonia.

Keep code native when its responsibility is control construction, binding, routed/pointer event translation,
window ownership or modal lifetime, accessibility attachment, pixel/drawing-context projection, native file or
print effects, or framework-specific test/capture setup. Mirrored source in those leaves is intentional when
the portable decision is already shared and the remaining symmetry is the cost of realizing or testing two
native UI frameworks. File size or lexical equality alone is not a reason to extract.

## Final validation - PENDING

Do not convert a row to passed without evidence from the final synchronized implementation SHA.

| Gate | Status | Required evidence |
|---|---|---|
| Residual audit and metrics | **PENDING** | Finish or classify the active audit categories, regenerate metrics for the final SHA, and pass the metrics check. |
| Final synced commit | **PENDING** | Synchronize the completed campaign with the final integration tip and record the resulting commit SHA. |
| Builds and tests | **PENDING** | Record repository preflight, Release build, default test lane, applicable UI/ribbon lanes, and all focused reruns listed above. |
| FreeX WPF visual parity | **PENDING** | Record baseline/candidate capture commits, manifests, image counts, and the comparison result. |

Until these rows are complete, this document is an active campaign record rather than dedup exhaustion or
integration sign-off.
