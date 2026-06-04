# Commands Parity Large Pieces Design

## Goal

Close the remaining large command-parity gaps where FreeX already has a plausible model boundary, while keeping renderer-heavy and package-heavy work incremental and testable.

## Scope

This design covers:

- Selectable/vector PDF text
- Heading bookmark variants
- Fuller Excel PDF publish options
- Exact accounting layout widths
- OS-localized custom date/time patterns
- PivotTable compact/subtotal merge fidelity
- Native slicer/timeline drawing fidelity
- Full PivotStyle theme semantics

The work is intentionally decomposed into waves. Each wave must leave the app buildable, update `ARCHITECTURE.md` and `COMMAND_SURFACE_PARITY.md`, and merge to `main` before the next wave begins.

## Architecture

PDF export stays in `App.Host` because it consumes WPF `FixedDocument` output. Wave 1 extends `ExportOptions` with explicit PDF option state and richer bookmark modes. Wave 2 introduces a separate vector text overlay path in `PdfDocumentExporter` so the current raster output remains the visual source of truth while selectable text can be layered in deterministic page coordinates.

Custom number/date formatting remains in `Core.Calc.NumberFormatter`. Accounting-width fidelity will be modeled as deterministic string layout over the existing display formatter first, then later connected to renderer alignment only if needed. OS-localized date/time pattern behavior will use an explicit culture-provider seam instead of reading ambient OS settings directly from formatting code.

PivotTable fidelity stays model-first in `Core.Model` and materialization-first in `Core.Commands.PivotTableRefreshService`. Compact/subtotal merge behavior and PivotStyle theme semantics should be implemented as deterministic refresh/style decisions, with XLSX load/save metadata following the model. Slicer/timeline native drawing fidelity belongs mostly in `Core.IO`, because current model state and the host pane already support authored slicer/timeline selection; the missing piece is native floating-object package shape fidelity.

## Wave Order

1. **PDF publish options and heading bookmarks.** Add explicit bookmark modes, page opening hints, and publish option summaries. Implement sheet-name, print-title/header-derived, and page-number bookmark variants where metadata exists.
2. **Selectable/vector PDF text foundation.** Keep raster pages for visual fidelity, then add an opt-in text overlay extractor for simple `TextBlock` content in fixed pages. This creates searchable/selectable text without replacing the raster renderer.
3. **Custom format fidelity.** Improve accounting display widths and add an injectable OS-localized date/time pattern resolver for `[$-F800]` and `[$-F400]` style tokens.
4. **PivotTable layout/style fidelity.** Expand merge materialization for compact and subtotal cases, then replace the current palette resolver with theme-aware PivotStyle element resolution for modeled built-in styles.
5. **Native slicer/timeline drawing fidelity.** Promote slicer/timeline drawing anchors and nonvisual shape metadata into durable model fields, then write them back when FreeX authors or round-trips workbooks.

## Acceptance

Each wave needs:

- Focused failing tests before implementation.
- Full solution build before commit.
- Updated architecture and parity documentation.
- Merge/push to `main`, then sync the session branch from `main`.

The remaining command-parity rows should become narrower after each wave. If a gap still requires a new renderer, package model, or host UI subsystem, the docs must say exactly what remains instead of claiming full parity.
