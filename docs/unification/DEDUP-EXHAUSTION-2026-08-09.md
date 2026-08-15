# Dedup Exhaustion Report - 2026-08-09

> **Status: PRACTICAL DEDUP SCOPE EXHAUSTED; CERTIFIED FOR MAIN.** The certified code checkpoint is
> `330c37305442eae39f1be3dfc606563b09d02d66`. Every identified portable candidate has either moved into a
> shared/product-portable owner or been independently classified as native realization. The synchronized
> build, test, preflight, residual-measurement, and FreeX WPF visual gates are complete.

## Scope and evidence

This report tracks the dedup campaign on `codex/dedup-exhaustion-rescue-20260810`. Its merge base is
`origin/main` at `afb02e6b0af25250fdfa46e0a6900ea6c7f72d31`; the preserved clean visual baseline is the earlier
pre-campaign `7cb6df15b89da6e03378b590e3966779b79f69b7`. The implementation checkpoint includes all integrated
dedup work through `b9661deea0` and is a direct descendant of `origin/main` with no main-only commits.

The generated [residual metrics](dedup-residual-metrics.md) analyze the certified code checkpoint. Their
determinism fixture and repository `-Check` mode both pass.

The interpretation follows the [program principles](README.md), [architecture roadmap](ROADMAP.md),
[historical backlog](DEDUP-BACKLOG.md), generated residual evidence, and [execution log](LOG.md). Commit
references below are representative ownership anchors rather than a complete changelog.

## Current and desired architecture

| Layer | Current checkpoint | Desired state |
|---|---|---|
| Product domain | FreeX cells/formulas, FreeW paragraphs/runs, and FreeP slides/shapes retain distinct models and format semantics. | Keep genuine document-domain and XLSX/DOCX/PPTX differences product-owned. |
| Focused portable workareas | `FreeX.App.Presentation` / `FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own renderer-neutral workflow, validation, layout, and command policy. | Each app exposes one focused workarea containing all renderer-neutral product decisions. |
| Shared application frame | Portable `Free.Shared.*` projects own ribbon, Backstage, lifecycle, URI launching, protection hashing, Legal Notices presentation, common geometry, localization mechanics, theme, drawing/OPC/PDF primitives, and test infrastructure. | Cross-product application-frame policy is implemented once, with product descriptors supplying text and capabilities. |
| Native renderers | WPF and Avalonia construct controls, translate native input, project portable plans, apply effects, and manage native lifetime. | Native hosts are thin realizers with no duplicated validation, workflow, semantic text, or portable geometry decisions. |

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

## Integrated continuation through `b9661deea0`

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

The final continuation added portable FreeX pivot, consolidate/find/update, options, calculation, formula-range,
focus-cycle, command-routing, and accessibility-tree ownership; portable FreeW review/watermark/zoom, comment,
screen-clip, generated-reference, complex-field insertion, table-focus, and read-aloud resource ownership; and
portable FreeP identity/clone, pane, dialog, measured-text, slideshow-mask, presenter-refresh, canvas-automation,
and keytip ownership. Shared Avalonia keytip input and startup lifetime now serve all sister apps. The last frame
pass removed dead FreeX recovery orchestration, routed FreeW titles through its frame descriptor, and exposed
FreeP's title as the shared `ApplicationWindowTitleSpec` directly.

The closing waves then standardized FreeW/FreeP Avalonia startup and packaging-smoke envelopes; centralized
platform print-service selection; removed the FreeP WPF ribbon adapter; added portable Custom Show and media-pane
host coordination; centralized FreeW floating-position registration; moved menu icon metadata and static FreeX
ribbon command identity into shared/portable catalogs; converged localized AutoFilter and workbook-info planner
resources; removed dead reflective/pass-through facades; replaced high-volume WPF/Avalonia test reflection with
typed tool-host access; centralized FreeX shortcut aliases; and removed the final FreeX ribbon-renderer facade.
Representative closing commits are `59b388af63`, `08287dd03c`, `77f8bef490`, `8bb26a047b`, `9c7c3e7c78`,
`49a5c94a0d`, `8ee9595de8`, `e7c1ec098e`, `ecbf22ff20`, `842e355bff`, `d16222f515`, `1b3f96c645`, and
`cdf8ed85b7`.

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

## Final measurable renderer reduction

The deterministic checkpoint measures eight renderer roots from merge base `afb02e6b0a` to code checkpoint
`330c373054`: 790 renderer files changed, 45,595 lines added, 158,628 deleted, for a **113,033 renderer C# LOC
reduction**. The renderers contain 249,903 measured code lines. Cross-root coverage is 7,954 exact lines
(3.182835%) and 8,388 normalized lines (3.356502%). FreeX is at 0.183030%-0.185341% exact and
0.206539%-0.206786% normalized; FreeW is at 1.099110%-1.111338% exact. FreeP remains 10.582481%-18.309002%
because its largest matched blocks are native pane,
dialog, slideshow, media, text-measurement, drawing, accessibility, and visual-capture realizers around shared
plans; two independent audits found no further stable renderer-neutral contract in those blocks.

## Residual audit conclusion

- **FreeX:** residual matches are native text/control mutation, popup selection, focus application, selection and
  status projection, picker/dialog realization, and platform window lifetime. Portable formula, command,
  validation, file, options, accessibility, ribbon, Backstage, and recovery decisions are shared.
- **FreeW:** residual matches are native table/author editor trees, Outline/Page Setup/Find-Replace controls,
  selection rendering, geometry, focus, event translation, and document-view materialization. Portable editing,
  fields/references, pagination, dialogs, style, review, print/file, and frame policy are shared.
- **FreeP:** residual matches are native slideshow snapshots/storyboards/timers/media controls, pane and dialog
  construction, canvas measurement/drawing/UIA, gesture pointer/cursor/adorner application, presenter projection,
  and visual-evidence capture. Their routing, state, validation, geometry plans, animation steps, and workflows
  are already portable.
- **Cross-product:** file outcomes, temporary resources, localization mechanics, messages, options persistence,
  ribbon infrastructure, Avalonia startup lifetime, and application-frame title policy are shared. Product text,
  capability descriptors, native effects, and distinct XLSX/DOCX/PPTX semantics remain intentionally local.

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

## Final validation - COMPLETE

Do not convert a row to passed without evidence from the final synchronized implementation SHA.

| Gate | Status | Required evidence |
|---|---|---|
| Residual audit and metrics | **PASSED** | Three fresh final audits found no P0-P2 practical scope; metrics self-test and `-Check` pass at `330c373054`. |
| Final synced commit | **PASSED** | The campaign includes the then-current `origin/main` merge plus the incoming FreeW dedup reconciliation; the documentation/promotion commit is a descendant of this certified checkpoint. |
| Builds and tests | **PASSED** | Repository preflight passed; the synchronized Release solution build completed with 0 warnings/errors. Default tests were assertion-clean after focused reruns: FreeP Avalonia 679/679 and the isolated FreeX clipboard flavor 1/1. FreeX Avalonia 2,046/2,046, Host logic 1,451/1,456 plus 4 benchmark skips and the focused clipboard pass, Presentation 5,247/5,248 plus one benchmark skip, Services 3,083/3,083, Core IO 5,274/5,330 plus 56 benchmark skips, Core Model 5,893/5,934 plus 41 benchmark skips, and all shared/FreeP/capture projects passed. Ribbon assertions passed 59/59; UI host batches passed with only declared skips. |
| FreeX WPF visual parity | **PASSED** | Baseline `afb02e6b0a` captured 115 comparable surfaces; candidate `330c373054` captured 116/116, including the newly covered sheet-tab overflow surface. Of 115 comparable PNGs, 89 are byte-identical and 26 intentional shared ribbon/frame surfaces differ. Home, Page Layout, contextual ribbon, grid/status, Backstage, and dialog results were visually inspected with no missing or overlapping UI. |

All identified practical extraction scope and certification gates are complete. Remaining lexical matches are
documented native control, input, drawing, accessibility, animation, lifetime, and capture realizations.

## Repo-wide region classification - 2026-08-15

The certification above rested on per-campaign audits. This section closes the last measurement gap by
classifying *every* remaining renderer-to-renderer duplicated region in all three apps at once, so the
"remaining lexical matches are native realization" claim is enumerated rather than asserted.

Method note, because it changes the numbers: raw sliding-window counts overstate duplication by roughly 8x,
since one duplicated region is recounted at every window offset. Overlapping windows are merged into
contiguous *regions* before counting. A normalized or structural matcher is also unusable here - C#
declaration shapes repeat everywhere, so it reports FreeP enum members as "matching" FreeW record parameters.
Only exact post-comment, post-brace matches are counted.

| App | Regions | Backed by a shared type named inside the region | Native-only |
|---|---|---|---|
| FreeP | 76 | ~47% (remainder is interface impls, ribbon-profile delegate table, parameter forwarding) | - |
| FreeW | 21 | 17 | 4 |
| FreeX | 2 | 1 | 1 |

All five native-only FreeW/FreeX regions fall into categories this document already reserves as native, and
each was checked individually rather than pattern-matched:

- **Input translation** - `DocumentView.ToEditorInputKey` and `FormulaBarWpfInputAdapter`/`FormulaBarAvaloniaInputAdapter`.
  These look identical because WPF and Avalonia both spell their enum members `Key.Enter`, `Key.Tab`, and so on,
  but the parameter is `System.Windows.Input.Key` in one and `Avalonia.Input.Key` in the other - two unrelated
  CLR types. The *target* enums (`DocumentEditorInputKey`, `FormulaEditorKey`) are already neutral and already
  shared, so the portable half is extracted; only the type-to-type translation is mirrored, and it cannot be
  shared without generics or reflection that would cost more than the duplication.
- **Control field declarations** - `PageSetupDialog` and `TablePropertiesDialog` backing fields. `TextBox` and
  `ComboBox` are likewise different types per framework; this is control construction.
- **Neutral-enum-to-control lookup** - `PageSetupDialog`'s switch from `PageSetupDialogControlKind` to a field.
  The enum and the focus plan driving it are shared; the switch returns a native control by definition.

Conclusion: 99 regions repo-wide, none of them an unextracted portable decision. Cross-app neutral-to-neutral
exact duplication is zero. The neutral and shared tiers are now measured roots in `Measure-DedupResiduals.ps1`,
so neutral-to-neutral duplication and portable logic leaking back into a shell both regress visibly instead of
being assumed absent - that check did not exist when the campaign closed, and it is what caught the two
thin-renderer leaks fixed after certification.
