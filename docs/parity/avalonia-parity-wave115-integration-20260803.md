# Avalonia parity Wave115 integration (2026-08-03)

## Scope

- FreeX: make `dialog.InsertHyperlink` comparison evidence content-equivalent and align Avalonia geometry to the WPF-authoritative metrics.
- FreeW: reduce the genuine Legal Notices long-document raster mismatch without changing WPF or the short-document baseline.
- FreeP: replace Basic Matrix's generic matrix fallback with dedicated shared live geometry.

## Delivered

- FreeX Insert Hyperlink now uses one deterministic comparison fixture on both hosts: display text `FreeX visual evidence` and target `https://freex.example/insert-objects`. Production prefill behavior is unchanged. Both comparison windows are 560x300 logical pixels; the corrected pair measures 3.7252% sample mean delta, 0.1642% luma delta, 2.9813% non-background delta, and a 0.068810 triage score, down from the invalid prior score of 0.094874. The fresh Avalonia capture came from the Windows parity harness, so this wave does not claim a Linux raster result for this dialog.
- FreeW Legal Notices now applies a 15.0 line height only to Avalonia long documents while retaining 14.6 for the short document and leaving WPF metrics unchanged. Changed-pixel results improved from 18.2777% to 17.7898% for Legal Notices, 16.5145% to 16.4640% for Privacy, 17.9952% to 17.6137% for Third-Party Notices, and 18.5226% to 17.9728% for Third-Party License Texts. The Initial and Project License states are unchanged.
- FreeP Basic Matrix now renders the first four top-level model nodes as a centered whole diamond and four rounded quadrants, with stable names and order and no connectors. Unused nodes remain editable, cache regeneration preserves the same geometry and diamond preset, and WPF and Avalonia remain thin consumers of the shared implementation. Unsupported live `matrix1` admission was removed because no fixture or package evidence establishes its semantics; cached fallback reading remains available.

## Focused verification

- FreeX worker lanes: 95 service tests passed; WPF and Avalonia Release builds completed without warnings or errors. The WPF host source-test project compiled but is not configured as a test project.
- FreeW worker lanes: 12 Avalonia Legal Notices tests, 9 WPF authority/provider tests, 1 shared-metrics test, 190 WPF harness states, and 288 Avalonia harness states passed; the FreeW Release solution build completed without warnings or errors.
- FreeP worker lanes: 355 presentation tests, 246 WPF/package tests, and 2 Avalonia tests passed; the FreeP Release solution build completed without warnings or errors. Save/reopen validation confirmed five shapes, no connectors, a diamond preset, and preservation of unused nodes.

## Remaining

- FreeX still needs a current Linux capture for Insert Hyperlink. The next measured dialog candidates are Options Formulas and Zoom.
- FreeW Legal Notices remains a genuine visual mismatch dominated by native text and control rasterization. Backstage Open/Export and Customize Theme Colors remain useful next slices.
- FreeP still needs broader SmartArt layout and effect fidelity plus stronger PowerPoint-authoritative visual evidence. Chart, Zoom, and media behavior also remain candidates for deeper functional validation.
