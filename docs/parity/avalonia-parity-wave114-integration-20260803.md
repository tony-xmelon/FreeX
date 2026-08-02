# Avalonia parity Wave114 integration (2026-08-03)

## Scope

- FreeX: align `dialog.FindReplace` geometry through shared WPF-authoritative metrics while preserving the WPF visual baseline.
- FreeW: align the six Page Setup states through one shared presentation and validation contract.
- FreeP: replace Grid Matrix's generic matrix fallback with dedicated shared live geometry.

## Delivered

- FreeX Find/Replace now shares field, result-column, button, tab, and spacing metrics across WPF and Avalonia. Avalonia also corrects its clipped Options header and vertical band placement without changing the auto-sized WPF Options expander. Fresh WPF captures remained at the prior 720x430 reference; the current Linux Avalonia after-capture could not be produced because both owned Xvfb container attempts exited without PNG output, so no unproved after/after visual score is claimed.
- FreeW Page Setup now shares window, tab, row, field, action, label, and validation policy across both hosts. All six canonical states were recaptured. Initial/populated/Margins improved from 15.665% to 15.246% changed pixels, Layout from 7.086% to 6.722%, Paper from 4.835% to 4.692%, and validation from 15.784% to 15.345%. No semantic differences were introduced and unrelated comparison rows retained the same semantic hash.
- FreeP Grid Matrix now renders the first four top-level items as a centered, deterministic 2x2 quadrant plan with stable roles and names and no flow connectors. WPF and Avalonia remain thin consumers of the same shared geometry, and the drawing cache survives schema-shaped PPTX save/reload.

## Focused verification

- FreeX worker lanes: 34 service tests, 8 Avalonia source tests, and 22 WPF dialog tests passed; WPF and Avalonia Release builds completed without warnings or errors.
- FreeW worker lanes: 8 planner tests, 4 WPF tests, and 4 Avalonia visual tests passed; six WPF and six Avalonia canonical states plus three production Linux/Xvfb states were captured.
- FreeP parent lanes: 1 presentation geometry test, 3 WPF/package tests, and 1 Avalonia host test passed after integration.

## Remaining

- FreeX still needs a successful current Linux after-capture for Find/Replace before its visual improvement can be quantified honestly. The next measured dialog candidates remain Insert Hyperlink, Options Formulas, Zoom, and Page Setup.
- FreeW Page Setup residuals are native text, border, tab, checkbox, focus, and 1-3 px control-template rasterization differences. Other genuine visual mismatches remain, led by Legal Notices and backstage surfaces.
- FreeP still has generic Basic Matrix behavior, broader SmartArt family/effect fidelity work, and no PowerPoint-authoritative visual baseline.
