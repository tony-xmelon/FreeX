# FreeFamily Unification Architecture Roadmap

Updated 2026-08-23 at implementation checkpoint `fe9d2d97ee`. Companion to `README.md` (principles), `LOG.md`
(execution record), and `dedup-residual-metrics.md` (current deterministic residual evidence).

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
| Portable workarea/session tier | exhausted to native adapters | exhausted to native adapters | exhausted to native adapters |
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

The final continuation also shares desktop URI launching, OOXML protection hashing, Legal Notices presentation,
directional-arrowhead/WordArt policy, startup lifetime, application-frame titles, FreeW pagination/dialog/field
workflows, FreeP Backstage/slideshow/pane/text contracts, FreeX renderer/accessibility/shell policies, sister-app
Avalonia startup, platform print-service selection, packaging-smoke execution, ribbon menu icons, localized planner
resources, static semantic command IDs, and workbook keyboard shortcut aliases.

## Workstreams

### WS-A - Renderer thinning - implementation complete

All measured candidates were extracted or classified from the final tree. Remaining matches are native control,
event, focus, geometry/materialization, drawing, media, accessibility-attachment, and capture adapters.

### WS-B - Product portable tiers - implementation complete

`FreeX.App.Presentation`/`FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own each
product's renderer-neutral workarea behavior. Their document models remain separate by design. The later
FreeP/FreeW autosave, recovery, recovery-planning, and dictionary-storage copies have been consolidated.

### WS-C - Shared document substrate - mature

OPC/package properties, secure XML, DrawingML units/colors/geometry, file descriptors, PDF primitives, and
text search are shared. The continuation added one OOXML protection hash implementation and shared
directional-arrowhead geometry. XLSX, DOCX, and PPTX rules stay local when the formats encode different
semantics.

### WS-D - Common application frame - mature

Ribbon, Backstage, shell workflow, theming, localization mechanics, options, diagnostics, file lifecycle,
print/export orchestration, desktop URI launching, Legal Notices, and shared dialog mechanics are common.
FreeW application workflow/dialog contracts and FreeP Backstage/header-footer contracts have joined that frame;
all three Avalonia apps now share startup lifetime policy and shared title contracts. Autosave snapshot storage
is shared already; the current queue consolidates the duplicated FreeP/FreeW session and recovery layers above it.

### WS-E - Test and evidence infrastructure - visual evidence current

Repository/source location, temporary resources, localization contracts, parity capture, image comparison, and
ownership guards are shared. Source guards defend architectural ownership; behavior tests remain preferred.
The 2026-08-22 FreeX WPF run captured and reviewed 116/116 surfaces. Focused tests and broader integration gates
belong to future implementation slices when new duplicate behavior appears.

## Remaining campaign queue

No material implementation slice remains at the 2026-08-23 checkpoint. Integration verification, merge/push,
and campaign-owned worktree cleanup close the campaign. See `DEDUP-CERTIFICATION-2026-08-23.md` for the final
whole-production audit, residual classification, metrics, and FreeX visual evidence.

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

After this campaign is integrated, do not start another broad dedup campaign from file
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

The latest classification and visual evidence are in `DEDUP-CERTIFICATION-2026-08-22.md`.
