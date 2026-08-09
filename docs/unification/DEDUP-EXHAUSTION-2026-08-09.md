# Dedup Exhaustion Report - 2026-08-09

> **Status: DRAFT FOR FINAL INTEGRATION.** The practical extraction scope is exhausted at the campaign
> evidence tip, but the final synchronization, test gates, and visual parity comparison are still pending.
> This report does not claim those results.

## Scope and evidence

This report closes the implementation inventory for branch `codex/dedup-exhaustion-20260805`. The final
implementation checkpoint is synchronized commit `ad826713286f358f170fa1a7ba6b838d9af209a1`, whose recorded
upstream and merge base are both `e1225af9b1689b39050f8154774c2a097b92af95`. The regenerated residual
evidence was committed in `fd07a9db50d315a1a9b5dc0c68eaaed7b3da7a81`. Subsequent synchronization and
documentation commits do not replace the measured analysis commit or constitute final integration sign-off.
The commit references below are representative anchors, not an exhaustive changelog.

The interpretation follows the [program principles](README.md), [architecture roadmap](ROADMAP.md),
[closed historical backlog](DEDUP-BACKLOG.md), [generated residual metrics](dedup-residual-metrics.md), and
[execution log](LOG.md). The current generated metrics use analysis commit
`ad826713286f358f170fa1a7ba6b838d9af209a1` and therefore include the final implemented renderer slices and
the synchronization ownership fixes described below.

## Current and desired architecture

The desired architecture is now the current architecture for the identified dedup scope:

| Layer | Ownership |
|---|---|
| Product domain | FreeX cells/formulas, FreeW paragraphs/runs, and FreeP slides/shapes retain their distinct models and format semantics. |
| Focused portable workareas | `FreeX.App.Presentation` / `FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own product policy, sessions, planners, schemas, command construction, validation, and workflow state. |
| Shared application frame | Portable `Free.Shared.*` projects own cross-product ribbon, Backstage, shell, file lifecycle, print/export, options, diagnostics, localization mechanics, theme, drawing/OPC/PDF primitives, and test infrastructure. Platform-specific shared leaves realize those contracts. |
| Native renderers | WPF and Avalonia hosts construct controls, translate native events and pixels, project portable plans, apply effects, and manage native window/control lifetime. |

The steady-state goal is not source-identical WPF and Avalonia trees. It is one portable decision path feeding
two thin native realizations, with each app retaining a focused workarea over its real document domain.

## Campaign coverage

| Area | Result across the campaign | Representative history |
|---|---|---|
| Adaptive ribbon and ribbon shell | Adaptive WPF measurement, fallback, collapsed-group overflow, icon/style mechanics, keytip traversal, command profiles, registries, invocation, and contextual policy moved into shared or portable owners. Renderers retain control creation and measurement application. | `94bf9bb265`, `15b3885bb6`, `f489d50bc6`, `c12ce7cf52`, `dd59111e7b` |
| Backstage and application frame | Shared pane workflows, recent-file projection, print state, application command routing, and FreeW/FreeP/FreeX frame sessions replaced renderer-owned decisions. | `12352a509e`, `fcc360ac14`, `0401a323b2`, `6b8e258750`, `617eaa8618` |
| File I/O, print, and export | Resolved-save and path policy, file-format projection, recovery offers, file command orchestration, print selection/session workflow, CUPS/printer discovery, export picker planning, and renderer routing were centralized. Native pickers, OS printing, and final file effects stay in platform adapters. | `ef7ca9c590`, `321cd9e6a2`, `f6aee134b1`, `959f221b93`, `cf1ffca5ee`, `90db738918`, `f8f9cca5fb` |
| Main editor and status | Workbook, document-editor, presentation-workarea, and application-frame sessions now own portable command/state transitions. Status display/options flow through shared models and a portable FreeX update workflow; native bars and editors only project state and events. | `3c38b5ee29`, `58eda0a80b`, `65c9a5bc7e`, `a06faa6204`, `617eaa8618` |
| Localization and resources | Shared resource mechanics, catalog metadata, common shell text, About/legal resources, and thin localization facades replaced infrastructure copies. Product wording and localized catalog context remain product-owned. | `d0450c7d3f`, `d4f32dcefe`, `fce1268b87`, `dc1a6d71ee`, `2a295d6aa8`, `f05216fd53` |
| Dialogs | FreeX range-selection lifecycle, FreeW reference/formatting/options/document dialogs, and FreeP chart/slideshow/layout/hyperlink/form dialogs moved their validation, commit policy, sessions, action catalogs, and typed schemas into portable tiers. WPF/Avalonia controls and modal lifetime remain native. | `fff17b7acf`, `64319d5647`, `ae9ec58c0b`, `8f6314bb16`, `467648ee61`, `0c866df67a` |
| QuickAnalysis, PageLayout, charts, tables, text boxes, and shapes | FreeX selection and conditional-format policy, PageLayout workflows/outcomes, chart commands, structured-table selection/overlap, text-box editing, and drawing drag/completion moved out of renderer event handlers. The final slices also centralized FreeW table-border endpoint projection plus FreeP chart-marker and selection-adorner geometry. Shared drawing/chart geometry and FreeP shape traversal cover reusable planning below those flows. | `7e91e91ae2`, `18df014f7a`, `f8fbee3708`, `9b194796bb`, `a454b8933b`, `55d4adb72d`, `7d77db7196`, `50f48c1aca`, `ba00a89312`, `ec3faa3ee4` |
| Sister-app startup and chrome | FreeW startup/recovery policy, shared Avalonia Backstage/ribbon chrome, launch-smoke bootstrap, and sister-app shell behavior converged while executable startup and native window creation stayed local. | `6fbbde4093`, `959f221b93`, `955c2a7897` |
| Renderer planning | Portable geometry, text layout, render commands, pane/slideshow policy, and workarea sessions now feed FreeX/FreeW/FreeP renderers. Final FreeP work centralized chart-marker geometry, selection-adorner projection geometry, and inline baseline placement. Native canvas, drawing-context, accessibility, and animation realization remain in renderer packages. | `85b3c78807`, `d07cd19a63`, `2090efa777`, `df74a01411`, `9d98939999`, `320fd70985`, `649a373a1c`, `ba00a89312`, `ec3faa3ee4`, `3b149d3878` |
| Test and evidence infrastructure | Repository/source locators, temporary resources, localization contracts, evidence-tool workflow, ownership guards, and deterministic residual measurement were consolidated. The final upstream synchronization preserved shared animation, shell-runner, table-projection, and test-locator ownership and repaired the thin sister-app adapters. Product scenarios and framework-specific capture drivers remain separate where they exercise different native stacks. | `ac51cbf3be`, `ef17eb6297`, `8a11d2a9f0`, `f05216fd53`, `9c428f2f1c`, `7f7506e5d0`, `5c56d0198c`, `8fc243fc79`, `ad82671328`, `fd07a9db50` |

## Measurable renderer reduction

The deterministic checkpoint in [dedup-residual-metrics.md](dedup-residual-metrics.md), committed by
`fd07a9db50`, measured the eight configured renderer roots from merge base
`e1225af9b1689b39050f8154774c2a097b92af95` to synchronized analysis commit
`ad826713286f358f170fa1a7ba6b838d9af209a1`:

| Scope | Files changed | Added | Deleted | Net C# LOC |
|---|---:|---:|---:|---:|
| All C# | 1,750 | 135,195 | 81,030 | **+54,165** |
| Renderer C# | 460 | 26,618 | 63,352 | **-36,734** |

At that checkpoint, the renderers contained 309,986 measured code lines. Cross-root duplicate coverage was
11,205 lines (3.614679%) for exact windows and 11,963 lines (3.859207%) for normalized windows. FreeX and
FreeW roots were each below 1.4% normalized coverage. The larger remaining percentages are concentrated in
FreeP's parallel WPF/Avalonia app and rendering surfaces, where native control and rendering symmetry is much
greater.

## Remaining lexical residuals

The residual scan is a candidate generator, not a semantic equivalence proof. At its checkpoint it found no
exact whole-file cross-root duplicates and four normalized whole-file groups. The remaining candidates fall
into these categories:

- **Native dialog/control projection.** Parallel WPF/Avalonia dialogs still create fields, labels, controls,
  bindings, automation metadata, and modal behavior around shared sessions and schemas.
- **Canvas, gesture, and selection rendering.** FreeP `SlideCanvas`, gesture handlers, selection adorners,
  slideshow animation, and text/drawing projection contain similar algorithms expressed through different
  framework primitives after portable geometry and policy have already been planned.
- **Window and presentation lifetime.** Main windows, slide-show windows, presenter view, focus, ownership,
  timers, and framework event adaptation remain native even when they consume the same portable state.
- **Thin facade and bootstrap symmetry.** `UiText`, localization adapters, ribbon entry facades, startup, and
  launch-smoke wrappers are intentionally small per-host seams over shared implementations.
- **Visual-evidence and test-harness symmetry.** WPF and Avalonia capture drivers deliberately repeat scenario
  shape so the two native stacks can be compared. Capture mechanics and locators are shared; framework setup,
  interaction, and screenshots remain framework-specific.
- **Localized value overlap.** Equal strings across catalogs are lexical overlap, not proof of shared product
  ownership. Localization mechanics and contracts are shared; product wording stays with its translator and
  feature context.
- **Product and format semantics.** Cells/formulas, paragraphs/runs, slides/shapes, and XLSX/DOCX/PPTX-specific
  behavior remain separate even when small blocks happen to normalize alike.

The current measurement already includes the final FreeW table endpoint projection (`50f48c1aca`), FreeP chart
geometry (`ba00a89312`), selection-adorner geometry (`ec3faa3ee4`), and inline baseline (`3b149d3878`) slices.
The categories above are therefore the stable disposition; the line-ranked candidate list is evidence for
native-leaf classification and must not be read as a current extraction backlog.

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

These gates are intentionally blank for the final orchestrator. Do not convert a row to passed without the
actual synchronized SHA or command/evidence result.

| Gate | Status | Final evidence placeholder |
|---|---|---|
| Final synced commit | **PENDING** | `[orchestrator: sync the completed campaign with the final integration tip and record the resulting commit SHA]` |
| Builds and tests | **PENDING** | `[orchestrator: record repository preflight, Release build, default test lane, and applicable UI/ribbon lane commands and results]` |
| FreeX WPF visual parity | **PENDING** | `[orchestrator: record clean baseline/candidate capture commits, manifests, image counts, and comparison result]` |

No build or test command was run for this documentation-only slice, as requested. Final closure is gated on the
three rows above; until then this document is the campaign draft, not the integration sign-off.
