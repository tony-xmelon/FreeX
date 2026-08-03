# Avalonia Parity Wave115: FreeX Insert Hyperlink

## Scope

Aligned the FreeX Avalonia `dialog.InsertHyperlink` presentation with the production WPF dialog while preserving the normal production prefill path. Shared planner metrics now define the dialog margin, link-type column, label column, editor/button sizing, row spacing, and list height consumed by both platform implementations.

The parity capture route now seeds a deterministic cell fixture before opening the dialog:

- Display text: `FreeX visual evidence`
- Target: `https://freex.example/insert-objects`
- Link type: Existing File or Web Page

This fixture is capture-only. Production `ShowInsertHyperlinkDialogAsync` continues to obtain its values from the selected range prefill contract.

## Evidence

The canonical Avalonia PNG was recaptured from the parity route on 2026-08-03 and paired with the existing WPF capture containing the same fixture. Both logical captures are 560x300. The regenerated evidence summary reports:

- `sampleMeanDelta`: `0.037252`
- `lumaDelta`: `0.001642`
- `nonBackgroundDelta`: `0.029813`
- `triageScore`: `0.068810`

The earlier `0.094874` score was not a valid visual baseline because the committed pair contained different content (`North`/`https://` on Avalonia versus the full hyperlink fixture on WPF). It is retained only as historical context, not as a layout-quality comparison.

## Verification and limitation

Focused Release services tests passed (`95/95`), and the Avalonia and WPF production projects built with zero warnings and errors. The Avalonia parity capture completed successfully and produced a nonblank canonical PNG. This worker did not run a Linux Docker/Xvfb capture; the fresh capture was produced by the Avalonia parity harness on the Windows host, so no Linux-specific raster claim is made here.
