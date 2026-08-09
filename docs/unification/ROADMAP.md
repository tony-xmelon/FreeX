# FreeFamily Unification Architecture Roadmap

Updated 2026-08-09. Companion to `README.md` (principles), `LOG.md` (execution record),
and `dedup-residual-metrics.md` (generated residual evidence).

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
| Portable workarea/session tier | high adoption | high adoption | high adoption |
| Shared application frame | adopted | adopted | adopted |
| Shared theme/localization mechanics | adopted | adopted | adopted |

The shared spine contains 20 projects. Portable projects own decisions and contracts; WPF, Avalonia, Windows,
Skia, and other platform packages own realization only. The three product renderers now consume shared or
portable policy for the identified dedup scope:

- adaptive ribbon layout, command profiles, invocation, overflow, focus, keytips, and chrome;
- Backstage navigation/panes, recent files, file lifecycle, save/open/export/print workflows;
- application options, autosave, diagnostics, document state, status-bar planning, and shell messaging;
- dialog sessions, validation, range selection, commit planning, and shared compact-dialog mechanics;
- FreeX QuickAnalysis, PageLayout, chart/table/textbox/shape, formula, selection, and command workflows;
- FreeW editing/navigation, page layout, fields, image/chart/page-border rendering plans, and PDF projection;
- FreeP slideshow/media/pane policy, chart/table/text/shape flows, chart-option sessions, and rendering plans;
- OPC, DrawingML, colors, units, geometry, PDF, themes, localization mechanics, and test infrastructure.

## Workstreams

### WS-A - Renderer thinning - practical scope exhausted

The planned WPF/Avalonia policy extractions are complete. Residual renderer code is native widget construction,
framework event/lifecycle adaptation, pixel projection, accessibility/automation attachment, or product-domain
behavior. New extraction requires fresh evidence from the residual metric or a concrete duplicated change.

### WS-B - Product portable tiers - complete

`FreeX.App.Presentation`/`FreeX.App.Services`, `FreeW.App.Presentation`, and `FreeP.App.Presentation` own each
product's renderer-neutral workarea behavior. Their document models remain separate by design.

### WS-C - Shared document substrate - complete at the semantic boundary

OPC/package properties, secure XML, DrawingML units/colors/geometry, file descriptors, PDF primitives, and
text search are shared. XLSX, DOCX, and PPTX rules stay local when the formats encode different semantics.

### WS-D - Common application frame - complete at the native boundary

Ribbon, Backstage, shell workflow, theming, localization mechanics, options, diagnostics, file lifecycle,
print/export orchestration, and shared dialog mechanics are common. Platform packages remain thin realizers.

### WS-E - Test and evidence infrastructure - complete

Repository/source location, temporary resources, localization contracts, parity capture, image comparison, and
ownership guards are shared. Source guards defend architectural ownership; behavior tests remain preferred.

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

## Future trigger

Do not start another broad dedup campaign from file size alone. Re-open this roadmap only when one of these is
true:

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
