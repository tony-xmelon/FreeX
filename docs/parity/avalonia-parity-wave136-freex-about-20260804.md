# Avalonia/WPF Parity Wave 136: FreeX About Dialog

Date: 2026-08-04

## Scope

The shared Avalonia About host now uses a measured `16.75` DIP line height for
the read-only About document. This corrects the cumulative paragraph-baseline
drift visible against the WPF authority while preserving the existing 560x420
geometry, read-only text behavior, keyboard defaults, accessibility metadata,
and scrollbar lane.

## Evidence and metrics

The current WPF authority was paired with fresh Linux Docker/Xvfb Avalonia
captures at 560x420 logical pixels. Lower is better:

| Pair | Triage | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Wave 134 baseline | 0.077246 | 0.057872 | 0.005549 | 0.013546 |
| Wave 136 final | **0.056193** | **0.046975** | **0.002421** | **0.006518** |

The final capture passed `app_exit=0`, `capture_validated=true`, nonblank
validation, and the exact 560x420 dimensions. A neighboring `17` DIP probe was
rejected because its composite triage rose to `0.062691`.

## Verification

- Focused FreeX Avalonia About parity tests passed after the metric update.
- Fresh capture command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\\tools\\Run-LinuxParityCapture.ps1 -OutputDir artifacts\\wave136-freex-about-lineheight-1675 -PublishDir artifacts\\wave136-freex-about-lineheight-1675\\publish -SurfaceId dialog.About -Width 560 -Height 420 -TimeoutSeconds 180 -ContainerName freex-wave136-about-lineheight-1675`.
- Focused metric command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\\tools\\Generate-DialogVisualEvidenceSummary.ps1` with the canonical WPF manifest and the fresh Wave 136 Avalonia manifest, writing only under `artifacts\\wave136-freex-about-lineheight-1675`.

## Canonical evidence

The Avalonia About PNG and its manifest row were promoted under
`docs/parity/dialog-visual-assets/avalonia-capture/`. The global dialog summary
and dashboard were intentionally left for integration.

## Residual

The pair still has expected cross-toolkit glyph rasterization and native
scrollbar color/thumb rendering differences. The platform-specific About text
also remains truthful: WPF names its WPF/OxyPlot stack while Avalonia names its
Avalonia stack.
