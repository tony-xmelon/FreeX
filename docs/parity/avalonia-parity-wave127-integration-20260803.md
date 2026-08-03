# Avalonia parity Wave127 integration

Date: 2026-08-03

## Integrated slices

- FreeX reduced the current-source `dialog.FormatCells.Alignment` residual by moving its three checkbox rows onto a shared 16px alignment-tab contract. The change is limited to those existing controls and preserves their automation ids and formatting behavior.
- FreeW moved Cross Reference, Document Inspector, and Watermark action labels, ordering, default roles, and cancel roles into shared presentation plans consumed by both hosts. WPF still resolves common `OK` and `Cancel` labels through `ShellStrings.Current`, preserving localization and Alt accelerators.
- FreeP added renderer-neutral OMML `m:aln` alignment points for math runs and operator-emulator boxes, including CT_OnOff false handling and shared alignment across multiple equations in one math paragraph. Authored equation arrays retain their separate centering behavior.

## Evidence

- FreeX Format Cells Alignment remains 620x540 at 96 DPI. Its focused mean pixel difference improved from 2.5714% to 2.4652%, and its generated triage score improved from 0.086872 to 0.086598 without a hard regression.
- The merged Linux Format Cells capture completed in `freex-wave127-integration-formatcells-alignment-20260803` with `app_exit=0` and `capture_validated=true`. Its SHA-256 exactly matches the promoted canonical Avalonia PNG.
- FreeW promoted nine current-source canonical rows across the three targeted routes. All nine retain the honest `genuine-visual-mismatch` classification, while their prior default/cancel/order semantic differences are now null.
- FreeW's aggregate evidence remains 183 paired rows: 28 passes and 155 visual mismatches, plus 105 Avalonia-only artifact rows. This wave closes a functional semantic cluster and does not inflate the visual pass count.
- FreeP WPF and Avalonia hosts consume the same `MathBox` and `MathDrawOp` alignment plan; no host-specific math policy was added.

## Focused verification

- FreeX Format Cells planner tests: 5 passed; Avalonia targeted capture test: 1 passed.
- FreeW shared action-plan test: 1 passed; WPF localization/accelerator test: 1 passed; host boundary tests: 4 passed; Avalonia Watermark tests: 3 passed.
- FreeP parser/layout alignment tests: 3 passed; WPF renderer test: 1 passed; Avalonia renderer test: 1 passed.
- Dialog visual summary, cross-app dashboard generation/check, and dashboard aggregation guards passed.
- Repository preflight passed.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- The default non-UI solution lane ran one project at a time to avoid the known parallel-host memory contention: 21 TRX files, 36,297 discovered, 36,163 executed and passed, 134 intentionally skipped/not executed, and zero failures, errors, timeouts, or aborts. No Wave127 test process remained.

## Residuals

- `dialog.FormatCells.Alignment` remains the highest FreeX triage row at 0.086598, narrowly ahead of `dialog.CreateTable` at 0.085779; remaining differences are primarily frame, font, and native control rasterization.
- FreeW still has 155 genuine paired visual mismatches, 105 Avalonia-only artifact rows, and other semantic clusters including focus differences.
- FreeP still needs nested alignment contexts, broader OfficeMath spacing/default semantics, and PowerPoint-authoritative raster baselines.
