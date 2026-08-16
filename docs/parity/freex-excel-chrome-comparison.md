# FreeX / Excel app-chrome comparison

This lane turns retained Excel and FreeX foreground captures into an explicit,
reproducible Office-vs-app-chrome report. It is deliberately separate from the
cross-platform WPF/Avalonia screenshot dashboard: capture coverage, pixel
triage, and visual-parity acceptance are different facts.

## Command

```powershell
dotnet run --project tools/FreeX.ExcelChromeCompare --configuration Release -- --out artifacts/parity/freex-excel-chrome
```

The command is read-only with respect to the capture inputs. It reads:

- Excel foreground ribbon evidence: `tools/screenshots_excel/screenshot_manifest.json`
- FreeX WPF foreground ribbon evidence: `tools/screenshots/screenshot_manifest.json`
- FreeX Avalonia Windows foreground ribbon evidence:
  `tools/screenshots_avalonia_ribbon/screenshot_manifest.json`

It writes `report.json` and `report.md` beneath the chosen output directory.
Only fixed-width pairs (`1100`, `900`, and `750`) receive a metric. The tool
rescales the two top-band images to their shared logical viewport using the
manifest DPI metadata before calculating the mean RGB absolute delta. It does
not letterbox, crop, or silently compare unequal maximized windows.

## Current mapping and limits

| Scope | Excel reference | FreeX WPF | FreeX Avalonia | Treatment |
|---|---|---|---|---|
| Ribbon, 1100/900/750 logical widths | 27 complete rows | 27 matching foreground top-band rows | 27 matching foreground top-band rows | DPI-normalized provisional triage for both shells; not an acceptance threshold. |
| Ribbon, maximized width | 9 complete rows | 9 complete rows at another maximized viewport | 9 complete rows at another maximized viewport | Coverage-only; no metric because maximized viewports differ. |
| Draw ribbon | Captured at all four widths | Captured at all four widths | Captured at all four widths | Included in both 27-row fixed-viewport triage sets and the coverage-only maximized set. |
| Office popups and native dialogs | Six retained Excel tours | Historical WPF tours | No same-viewport Avalonia foreground artifacts | Coverage evidence only. Element/window crops are not a common rectangle, so a full-image pixel delta would be misleading. |

The canonical Avalonia visual manifests contain 94 deterministic dialog
surfaces, but they intentionally do not contain an operating-system desktop
title bar, Excel-equivalent ribbon top band, or foreground popup rectangle.
The new foreground harness is intentionally separate from that deterministic
corpus: it launches the Windows Avalonia host, checks process/title foreground
ownership before every input and screenshot, and writes the same
`ribbon:<width>:<tab>` keys and logical viewport metadata as the Excel/WPF
lanes. The comparison tool refuses to load a missing Avalonia foreground
manifest rather than treating the dialog corpus as app-chrome evidence.

## Reading the report

`provisional-pixel-comparison` means the pair has a shared fixed logical
viewport and a reproducible delta. It does **not** mean pass, fail, or Office
equivalence, and it does not establish an acceptance threshold.

`coverage-only` identifies a real pair whose images are not geometrically
comparable, such as maximized windows. `source-skipped` is reserved for a
future unavailable tab; the current 36-row run has no skipped tab. Neither
status is a pass.

## Next evidence needed

1. Refresh the three matrices after a renderer or Office UI change. Both app
   commands discard a partial matrix and retain a blocker manifest when
   anything other than their expected app owns foreground.
2. Give popup/dialog capture contracts a shared client rectangle before using
pixel deltas for them; the present crops establish coverage, not geometry.

## First reproducible triage run (2026-08-16)

The current guarded interactive run retained all 36 rows for each of Excel,
WPF, and Avalonia. The 27 fixed-viewport rows produce a 13.937% mean / 14.399%
maximum RGB delta for WPF versus Excel and a 15.639% mean / 16.048% maximum
for Avalonia versus Excel. Nine maximized rows are coverage-only. These values
are a review queue baseline, not an acceptance threshold.

## Resolved runtime capture blocker — 2026-08-16

An inherited `DOTNET_ROOT=C:\Users\ali\.dotnet` pointed the WPF apphost at an
incomplete user-local 10.0.0 runtime despite the installed global desktop
runtime. The capture apphost now embeds global runtime search, and the script
can launch the matching DLL through `dotnet` as a compatibility route. The
direct apphost and guarded foreground host now reach `Book1 - FreeX`; the
complete WPF and Avalonia matrices above were captured after that repair.
