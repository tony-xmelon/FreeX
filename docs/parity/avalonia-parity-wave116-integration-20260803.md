# Avalonia parity Wave116 integration (2026-08-03)

## Scope

- FreeX: replace stale `dialog.Options.Formulas` evidence, remove one Avalonia-only row, and align the current production surface to WPF.
- FreeW: reduce cumulative Avalonia row drift in the WPF-authority Backstage Open pane.
- FreeP: replace the admitted `hierarchy1` generic hierarchy path with dedicated shared live geometry.

## Delivered

- FreeX Options Formulas now preserves iterative calculation controls on both hosts while removing Avalonia's extra master error-checking row. The legacy persisted setting is carried through unchanged and individual rule switches retain their shared command behavior. The old WPF PNG predated the WPF iterative controls, so both hosts were recaptured from current source at 744x777. The fresh Avalonia capture was produced under Ubuntu 24.04 Docker/Xvfb. The generated triage score fell from the stale pair's 0.092999 to 0.044740; non-background delta fell from 0.054211 to 0.005006.
- FreeW Backstage Open now constrains Avalonia action buttons to the WPF link-button's 17-DIP footprint, eliminating cumulative vertical drift across recent rows without changing WPF, callbacks, search, tabs, scrolling, automation, or focus behavior. Against one fresh WPF capture, the fresh pre-edit versus final changed-pixel ratio improved from 18.5663% to 16.8494%, mean channel delta from 16.2118 to 14.2007, and perceptual hash distance from 11 to 6. The older canonical 15.3122% row is not a valid direct baseline because its WPF raster content differed.
- FreeP `hierarchy1` now dispatches to a dedicated shared top-down tree plan with root, branch, leaf, and parent-child connector roles. Existing repository package fixtures and `parOf` hierarchy evidence justify the structure; reader admission is unchanged, WPF and Avalonia remain thin consumers, and cache regeneration preserves the shared plan through save/reopen. `list2` was not specialized because the repository does not establish distinct layout-specific geometry for it.

## Focused verification

- FreeX worker lanes: 44 service tests passed; WPF and Avalonia Release builds completed without warnings or errors; current-source WPF and Linux Docker/Xvfb Avalonia captures are nonblank and 744x777; generated summary checking passed.
- FreeW worker lanes: 39 Avalonia Backstage tests passed; WPF and Avalonia harness Release builds completed without warnings or errors; one fresh paired 560x600 capture passed both content gates; generated inventory/comparison guards passed.
- FreeP worker lanes: 204 presentation SmartArt tests, 252 WPF/package tests, and 1 Avalonia compositor test passed; the FreeP Release solution build completed without warnings or errors; generated inventory and documentation guards passed.

## Remaining

- FreeX still has native text/control rasterization residuals and natural lower-list scrolling on Options Formulas. Find/Replace needs a successful current Linux recapture before its remaining score is treated as current; Zoom and Page Setup remain measured candidates.
- FreeW Backstage Open remains a genuine visual mismatch dominated by native tabs, scrollbar/search chrome, and text rasterization. Backstage Export and Customize Theme Colors remain useful next slices.
- FreeP still needs broader evidence-backed SmartArt specialization, effects fidelity, chart/media functional depth, and PowerPoint-authoritative visual baselines where a COM-capable environment is available.
