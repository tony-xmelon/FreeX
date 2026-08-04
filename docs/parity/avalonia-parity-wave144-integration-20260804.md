# Avalonia parity Wave 144 integration

Date: 2026-08-04

## Integrated slices

- FreeX `dialog.PivotTableOptions.Display`: aligned the Avalonia parity fixture with the WPF authority (`PivotStyleLight16` and banded rows). The valid paired triage score improved from `0.069304` to `0.058731`, with exact `520x500` logical dimensions.
- FreeW `options.tab-auto-correct`: retained WPF evidence established a one-pixel content-width difference. The Avalonia selected content host now paints `517x387`, with focused tests retaining WPF action and geometry semantics.
- FreeP SmartArt: authored Basic Matrix diagrams now use the flat sibling topology consumed by the shared layout engine, including PPTX round-trip and paired renderer-contract coverage.
- Shared FreeX About presentation: WPF and Avalonia wrappers now consume one host-neutral presentation contract. WPF-only runtime package text remains in the WPF host and is supplied to the shared builder, preserving the portable macOS source boundary.

## Integration correction

The initial About extraction moved a WPF-only runtime notice into portable services and left the macOS source-readiness guard asserting the old construction path. Integration restored the notice to the WPF host, made it an explicit shared-builder input, and updated the readiness marker to enforce `FreeXAboutDialogPresentation` usage. Repository preflight then passed portable-source hygiene across 909 files.

## Evidence boundary

This wave closes the scoped semantic and visual differences above. It does not claim complete cross-app parity or replace unavailable authoritative WPF/Office captures. The retained FreeW WPF reference remains authoritative because a fresh local WPF `RenderTargetBitmap` attempt was blank and was not promoted.

## Verification

- Focused FreeX PivotTable Options tests: passed (Avalonia 3/3; WPF 18/18 in the worker lane).
- Focused FreeW Options tests: passed (Avalonia 6/6; WPF 4/4 in the worker lane).
- Focused FreeP SmartArt tests: passed (presentation 394, WPF 309, Avalonia 10 in the worker lane).
- Focused shared About tests after portability correction: passed (services 78/78; WPF host 6/6).
- Repository preflight after portability correction: passed.
- Full integrated Release build and final current-source checks are recorded in the integration commit/push summary.
