# FreeFamily Unification Architecture Roadmap

Updated 2026-08-10 at integrated campaign checkpoint `42e6ca0ca5`. Companion to `README.md` (principles),
`LOG.md` (execution record), and `dedup-residual-metrics.md` (historical generated residual evidence at
`ad82671328`, pending regeneration for the final synchronized tree).

## Vision

FreeX (spreadsheet), FreeW (word processor), and FreeP (presentations) run on Windows through WPF and on
Linux/macOS through Avalonia. Each product should be, as close as practical:

- a thin native renderer that constructs widgets, projects a portable plan, and applies native effects;
- a focused product workarea over its genuinely distinct document model; and
- a consumer of a shared application frame for ribbon, Backstage, shell, dialogs, services, file lifecycle,
  print/export, localization mechanics, theming, and test infrastructure.

WPF remains the Windows renderer for fidelity and performance. Avalonia remains the cross-platform renderer.
The objective is dual thin renderers, not renderer replacement.

## Current state

| Dimension | FreeX | FreeW | FreeP |
|---|---|---|---|
| Windows WPF | mature | mature | mature |
| Linux/macOS Avalonia | strong | strong | strong |
| Portable workarea/session tier | high adoption; validation/text tail active | high adoption; projection/catalog tail active | high adoption; slideshow/media tail active |
| Shared application frame | adopted | adopted | adopted |
| Shared theme/localization mechanics | adopted | adopted | adopted |

The shared spine contains 20 projects. Portable projects own decisions and contracts; WPF, Avalonia, Windows,
Skia, and other platform packages own realization only. The three product renderers now consume shared or
portable policy for most campaign scope:

- adaptive ribbon layout, command profiles, invocation, overflow, focus, keytips, and chrome;
- Backstage navigation/panes, recent files, file lifecycle, save/open/export/print workflows;
- application options, autosave, diagnostics, document state, status-bar planning, and shell messaging;
- dialog sessions, validation, range selection, commit planning, and shared compact-dialog mechanics;
- FreeX QuickAnalysis, PageLayout, chart/table/textbox/shape, formula, selection, and command workflows;
- FreeW editing/navigation, page layout, fields, image/chart/page-border rendering plans, and PDF projection;
- FreeP slideshow/media/pane policy, chart/table/text/shape flows, chart-option sessions, and rendering plans;
- OPC, DrawingML, colors, units, geometry, PDF, themes, localization mechanics, and test infrastructure.

The current continuation also shares desktop URI launching, OOXML protection hashing, Legal Notices
presentation, directional-arrowhead/WordArt policy, FreeW pagination and application-dialog workflows, FreeP
Backstage/lifecycle/pane/header-footer contracts, and additional FreeX renderer/core policies. The active
residual queue below prevents a completion claim at this checkpoint.

## Workstreams

### WS-A - Renderer thinning - in progress

Most planned WPF/Avalonia policy extractions are complete, including the current FreeX renderer, FreeW border,
and FreeP canvas/pane slices. The adversarial audit still identifies portable slideshow geometry/orchestration,
document projection rules, semantic IDs/text, and adoption holes in native files. Scope is exhausted only after
those candidates are extracted or explicitly classified from the final tree.

### WS-B - Product portable tiers - residual ownership active

`FreeX.App.Presentation`/`FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own each
product's main renderer-neutral workarea behavior. The current queue finishes typed validation and semantic
text in FreeX, projection/catalog policy in FreeW, and slideshow/media coordinators in FreeP. Their document
models remain separate by design.

### WS-C - Shared document substrate - mature, final audit active

OPC/package properties, secure XML, DrawingML units/colors/geometry, file descriptors, PDF primitives, and
text search are shared. The continuation added one OOXML protection hash implementation and shared
directional-arrowhead geometry. XLSX, DOCX, and PPTX rules stay local when the formats encode different
semantics; final audit classification is still pending.

### WS-D - Common application frame - residual adoption active

Ribbon, Backstage, shell workflow, theming, localization mechanics, options, diagnostics, file lifecycle,
print/export orchestration, desktop URI launching, Legal Notices, and shared dialog mechanics are common.
FreeW application workflow/dialog contracts and FreeP Backstage/header-footer contracts have joined that frame;
older call-site adoption and a small semantic-text tail remain.

### WS-E - Test and evidence infrastructure - final gates pending

Repository/source location, temporary resources, localization contracts, parity capture, image comparison, and
ownership guards are shared. Source guards defend architectural ownership; behavior tests remain preferred.
Several integrated slices intentionally deferred focused or broad verification, and the final synchronized
preflight/build/test/visual gates have not run.

## Current residual implementation queue

1. **FreeX:** finish typed localized validation/focus descriptors, Manage Conditional Formats text resolution,
   threaded-comment localization, semantic-ID catalogs, and the small zoom fallback.
2. **FreeW:** centralize equation presets, table-grid projection, list-marker sequencing, heading style tokens,
   and native-selection range projection; adopt shared comment/style contracts at the remaining old call sites.
3. **FreeP:** centralize slideshow mask timelines, caption/fullscreen geometry, OLE activation, media-pane
   orchestration, dialog automation-ID composition, and remaining review/table display strings.
4. **Integration:** rerun interrupted and unrun focused tests, resolve source-guard findings, regenerate residual
   metrics at the final SHA, then execute the full synchronized validation and FreeX WPF visual comparison.

## Deliberate exceptions

These are not unfinished dedup work:

- cells/formulas versus paragraphs/runs versus slides/shapes;
- XLSX, DOCX, and PPTX package semantics that are not the same standard primitive;
- product command/profile text and localized resource content;
- native WPF/Avalonia control trees, data binding, routed/pointer events, window ownership, and modal lifetime;
- renderer-specific drawing/PDF projection after geometry and policy have already been planned portably;
- product-only workflows with no second consumer and no stable neutral contract.

Coincidentally equal resource values are not a sharing signal. Localization infrastructure and contracts are
shared; product wording stays in the product catalog so translators and feature owners retain context.

## Future trigger after this campaign

After the active residual queue is finished or classified, do not start another broad dedup campaign from file
size alone. Re-open this roadmap only when one of these is true:

1. `tools/Measure-DedupResiduals.ps1` identifies a new high-confidence cross-renderer block with reusable policy.
2. The same behavior change must be implemented in two renderers or products.
3. A new sister app would otherwise copy an existing workflow.
4. A native file contains decision, validation, command construction, or geometry that can be behavior-tested
   without referencing its UI framework.

## Integration gate

Every renderer-thinning campaign must run repository preflight, the Release solution build, the default test
lane, the UI lane when WPF behavior or UI infrastructure changed, and the focused ribbon lane for adaptive
ribbon work. FreeX WPF must also be parity-captured against a clean pre-campaign `origin/main` baseline and
the resulting manifests/images compared before merge.

All of these final synchronized gates remain pending at `42e6ca0ca5`.
